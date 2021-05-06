#!/usr/bin/env python
import argparse
import glob
import os
import subprocess


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '--type',
            action='store_true',
    )
    parser.add_argument(
            '-c',
            '--line-number',
            type=int,
            default=1,
    )
    return parser.parse_args()


class Passmenu:
    def __init__(self, line_number: int):
        self.line_number = line_number

    def get_password_files(self):
        prefix = os.environ.get('PASSWORD_STORE_DIR') or \
            '{HOME}/.password-store'.format(HOME=os.environ['HOME'])
        filenames = glob.iglob(f'{prefix}/**/*.gpg', recursive=True)
        return sorted(f[len(prefix) + 1:-4] for f in filenames)

    def make_selection(self):
        self.selection = subprocess.run(
                ["fzf"],
                check=True,
                input="\n".join(self.get_password_files()),
                text=True,
                stdout=subprocess.PIPE,
        ).stdout.rstrip("\n")

    def get_selection(self):
        if not hasattr(self, 'selection'):
            self.make_selection()
        return self.selection

    def copy_password(self, seconds: int):
        selection = self.get_selection()
        if seconds is not None:
            os.environ['PASSWORD_STORE_CLIP_TIME'] = str(seconds)
        self.clear_clipboard()
        subprocess.run(
                ['pass', 'show', f'-c{self.line_number}', selection],
                check=True,
        )

    def clear_clipboard(self):
        subprocess.run(["xclip", "-selection", "clipboard", "/dev/null"], check=True)


def main():
    args = parse_args()
    passmenu = Passmenu(args.line_number)
    if args.type:
        selection = passmenu.get_selection()
        pw = subprocess.run(
                ['pass', 'show', selection],
                check=True,
                capture_output=True,
        ).stdout.splitlines()[args.line_number - 1]
        subprocess.run(
                ['xdotool', 'type', '--clearmodifiers', '--file', '-'],
                check=True,
                input=pw,
        )
    else:
        password_store_clip_seconds = 10
        passmenu.copy_password(seconds=password_store_clip_seconds)
        line_strs = {
            1: "password",
            2: "username",
        }
        line_str = line_strs.get(args.line_number, f"line {args.line_number}")


if __name__ == '__main__':
    main()
