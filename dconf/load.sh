#!/bin/sh
set -e
sed --expression "s:/home/isabelle/:$HOME/:" dconf.dump | dconf load /
