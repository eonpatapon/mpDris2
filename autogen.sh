#!/bin/sh

autoreconf -fi

if [ -z "$NOCONFIGURE" ]; then
	./configure --sysconfdir=/etc "$@"
fi
