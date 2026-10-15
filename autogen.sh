#!/bin/sh

autoreconf -fvi -I /usr/share/gettext/m4 || exit

intltoolize -f || exit

if [ -z "$NOCONFIGURE" ]; then
    ./configure --sysconfdir=/etc "$@"
fi
