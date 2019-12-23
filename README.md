# mpDris2

mpDris2 provide MPRIS 2 support to mpd (Music Player Daemon).

mpDris2 is run in the user session and monitors a local or distant mpd server.

# Installation

## Stable release

Download the latest release at https://github.com/eonpatapon/mpDris2/releases

    tar zvxf mpDris2-X.X.tar.gz
    cd mpDris2-X.X
    ./autogen.sh --sysconfdir=/etc
    make install (as root)

## From git

    git clone git://github.com/eonpatapon/mpDris2.git
    cd mpDris2
    ./autogen.sh --sysconfdir=/etc
    make install (as root)

Logout/login from your session.
Default prefix is ``/usr/local``.

# Configuration

By default, mpDris2 will try to connect to localhost:6600.

To set a different host or port copy the example configuration file
``/usr/[local]/share/doc/mpdris2/mpDris2.conf`` to ``~/.config/mpDris2/mpDris2.conf``.

Use the configuration to enable notifications and multimedia keys support (on
the GNOME desktop).

You need also to set the ``music_dir`` option for mpDris2 to export covers
paths in the MPRIS metadata.

Restart your session or mpDris2 after changing mpDris2.conf.

## Sample configuration

    [Connection]
    host = 192.168.1.5
    port = 6600
    music_dir = /media/music/

    [Bling]
    notify = False
    mmkeys = True
