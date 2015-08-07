#!/bin/sh

autoreconf -f -i || exit

intltoolize -f || exit

if [ -z "$NOCONFIGURE" ]; then
	./configure --sysconfdir=/etc "$@"
fi
