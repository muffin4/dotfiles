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
            '--matching',
    )
    parser.add_argument(
            '-c',
            '--line-number',
            type=int,
            default=1,
    )
    return parser.parse_args()


class Passmenu:
    def __init__(self, line_number: int, matching: str):
        self.line_number = line_number
        self.matching = matching

    def get_password_files(self):
        prefix = os.environ.get('PASSWORD_STORE_DIR') or \
            '{HOME}/.password-store'.format(HOME=os.environ['HOME'])
        filenames = glob.iglob(f'{prefix}/**/*.gpg', recursive=True)
        return sorted(map(lambda f: f[len(prefix) + 1:-4], filenames))

    def get_prompt(self):
        prompts = {
            1: 'pass password',
            2: 'pass username',
        }
        return prompts.get(self.line_number, f'pass line {self.line_number}')

    def get_command_line(self):
        prompt = self.get_prompt()
        command_line = ['rofi', '-dmenu', '-p', prompt, '-no-show-match']
        if self.matching:
            command_line += ['-matching', self.matching]
        return command_line

    def make_selection(self):
        command_line = self.get_command_line()
        self.selection = subprocess.run(
                command_line,
                check=True,
                input="\n".join(self.get_password_files()),
                text=True,
                capture_output=True,
        ).stdout.rstrip('\n')

    def get_selection(self):
        if not hasattr(self, 'selection'):
            self.make_selection()
        return self.selection

    def copy_password(self, seconds: int):
        if not hasattr(self, 'selection'):
            self.make_selection()
        if seconds is not None:
            os.environ['PASSWORD_STORE_CLIP_TIME'] = str(seconds)
        self.clear_clipboard()
        subprocess.run(
                ['pass', 'show', f'-c{self.line_number}', self.selection],
                check=True,
        )

    def clear_clipboard(self):
        subprocess.run(["xclip", "-selection", "clipboard", "/dev/null"], check=True)


def main():
    args = parse_args()
    passmenu = Passmenu(args.line_number, args.matching)
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
