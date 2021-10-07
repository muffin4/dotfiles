#! /bin/sh
set -e

cd "$HOME/.config/kitty"

dark=themes/Tango_Dark.conf
light=themes/Tango_Light.conf
target=theme.conf

if ! [ -a "$target" ]; then
	ln -vs "$light" "$target"
	exit 0
fi

if ! [ -h "$target" ]; then
	echo "$target is not a symbolic link"
	exit 1
fi

if [ "$target" -ef "$dark" ]; then
	ln -vsf "$light" "$target"
elif [ "$target" -ef "$light" ]; then
	ln -vsf "$dark" "$target"
else
	echo "unexpected link in $target" >&2
	exit 1
fi
