# mpDris2

[![Build](https://github.com/b0bbywan/mpDris2/actions/workflows/build.yml/badge.svg)](https://github.com/b0bbywan/mpDris2/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/b0bbywan/mpDris2)](https://github.com/b0bbywan/mpDris2/releases)
[![License: GPL-3.0-or-later](https://img.shields.io/badge/license-GPL--3.0--or--later-blue)](COPYING)
[![Python](https://img.shields.io/badge/python-3.11%2B-blue)](pyproject.toml)
[![MPD](https://img.shields.io/badge/MPD-F18D00)](https://www.musicpd.org/)
[![APT](https://img.shields.io/badge/apt-odio.love-A80030)](https://apt.odio.love)

mpDris2 provide MPRIS 2 support to mpd (Music Player Daemon).

mpDris2 runs in the user session and monitors a local or distant mpd server.

## Contents

- [Features](#features)
- [Install](#install)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Development](#development)
- [Build a .deb](#build-a-deb)
- [Cover art](#cover-art)
- [Used in](#used-in)
- [Contributing](#contributing)
- [Credits](#credits)
- [License](#license)

## Features

- Full MPRIS 2 interface (playback control, metadata, seek, volume) for
  any MPRIS client: `playerctl`, media keys, desktop applets.
- Pure asyncio + dbus-fast: single event loop, no threads, no GLib.
- Local or remote MPD, with automatic reconnect and capability probing.
- A 7-step cover-art pipeline that resolves artwork for tagged files,
  CD (CUE/cdda) tracks and web-radio streams (see [Cover art](#cover-art)).
- Optional remote cover sources: MusicBrainz/CAA, iTunes, Deezer,
  Radio Browser, myMPD WebradioDB.
- systemd user unit with D-Bus activation: starts on the first MPRIS call.
- Light footprint: only `python-mpd2` and `dbus-fast` at runtime.

# Install

From the Odio APT repository:

```sh
curl -fsSL https://apt.odio.love/key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/odio.gpg
echo "deb [signed-by=/usr/share/keyrings/odio.gpg] https://apt.odio.love stable main" \
    | sudo tee /etc/apt/sources.list.d/odio.list
sudo apt update
sudo apt install mpdris2
```

The shipped systemd user unit is `Type=dbus` and a matching D-Bus
service file is installed, so mpDris2 auto-starts on the first MPRIS
call (`playerctl`, a media key, a desktop applet, …). Enable it
explicitly only if you want it running before any client asks:

```sh
systemctl --user enable --now mpDris2.service
```

## From PyPI

```sh
pipx install mpdris2     # or: pip install --user mpdris2
```

This installs the `mpDris2` console script only — no systemd or D-Bus
service files, unlike the `.deb`. To auto-start it, drop a user unit at
`~/.config/systemd/user/mpDris2.service` (copy `data/user/mpDris2.service`)
and `systemctl --user enable --now mpDris2.service`. The optional cover
deps are `pipx install 'mpdris2[cover]'`.

## From git

```sh
git clone https://github.com/b0bbywan/mpDris2.git
cd mpDris2
pipx install .          # or: pip install --user .
```

This installs the `mpDris2` console script into your `$PATH`. Start it
via a `systemctl --user` unit.

Tagged releases on GitHub also publish an sdist tarball
(`mpdris2-X.Y.Z.tar.gz`) next to the `.deb`, installable with
`pipx install ./mpdris2-X.Y.Z.tar.gz`.

Runtime dependencies: `python-mpd2` and `dbus-fast`. Python 3.11+.

# Configuration

By default mpDris2 connects to `localhost:6600`. Environment variables
`$MPD_HOST` and `$MPD_PORT` are honoured. To change anything else, copy
the example file shipped at `/usr/share/doc/mpdris2/mpDris2.conf` to
`~/.config/mpDris2/mpDris2.conf` and edit.

Cover-art resolution needs `music_dir` to be set (or auto-detected over
a local Unix socket connection to MPD). See [Cover art](#cover-art)
below for the full pipeline.

Restart mpDris2 (`pkill -HUP mpDris2`, or just restart your session) to
pick up config changes.

> **Note:** the `[Bling] mmkeys` option from the historical mpDris2 is
> no longer supported. Modern desktops (GNOME, KDE, sway with
> `mpris-ctrl`, …) read MPRIS directly for multimedia-key handling, so
> mpDris2 doesn't need to grab the keys itself anymore.

## Sample configuration

```ini
[Connection]
# Override host / port (or set $MPD_HOST / $MPD_PORT in the environment).
host = 192.168.1.5
port = 6600
password =

[Library]
# Required for cover-art resolution when MPD is remote (auto-detected
# over a local Unix socket connection).
music_dir = /media/music/
# Override the default cover-file regex; useful for non-standard names.
#cover_regex = ^(album|cover|\.?folder|front).*\.(gif|jpe?g|png|webp|bmp)$

[Cover]
# Remote cover-art sources (pipeline step 5), as an ordered, comma-separated
# list — the order is the lookup priority, and a source not listed is off.
# Valid: musicbrainz, itunes, deezer. Unset = none. MusicBrainz/CAA needs the
# [cover] extra (see below); iTunes/Deezer don't.
#sources = musicbrainz, itunes, deezer
# Web-radio stream cover sources (steps 6-7), same ordered-list rule. Valid:
# radiobrowser (station favicon), mympd (myMPD WebradioDB). Unset = none.
#stream_sources = mympd, radiobrowser
# Base URL of a myMPD instance — the data the 'mympd' stream source needs.
# Listing 'mympd' above without this is a no-op.
#mympd_uri = http://localhost:8080

[Bling]
# CD-like Previous: if elapsed >= 3 s, restart the current track instead
# of jumping to the previous one.
cdprev = False
```

mpDris2 does not raise its own desktop notifications: modern desktops
(GNOME, KDE, sway with `playerctld`, …) surface track changes straight
from the MPRIS metadata mpDris2 exports.

# Architecture

mpDris2 is an asyncio + dbus-fast rewrite of the original PyGObject /
dbus-python implementation: a single asyncio event loop replaces the
GLib MainLoop + thread pool, `dbus-fast` replaces `dbus-python`, and
`mpd.asyncio` from `python-mpd2` replaces the blocking client.

# Development

A top-level `Makefile` wraps the day-to-day commands so local dev and
CI stay in sync (the GitHub workflow calls the same targets):

```sh
make lint           # ruff + mypy
make test           # pytest
make build          # python -m build (sdist + wheel)
make deb            # dpkg-buildpackage -b -us -uc (Debian toolchain)
make clean          # drop build/, dist/, *.egg-info
make version        # print the Python version (from __init__.py)
make sync-deb       # bump debian/changelog to match __init__.py
```

`mpdris2/__init__.py` is the single source of truth for the version;
`make sync-deb` and `make check-tag TAG=…` keep `debian/changelog`
and the git tag aligned with it.

# Build a .deb

Build-deps (per `debian/control`): `debhelper-compat (= 13)`,
`dh-python`, `python3`, `python3-setuptools`. Then `make deb` on
Debian trixie or a derivative produces the `.deb`. The runtime deps
(`python3-mpd`, `python3-dbus-fast`) are resolved by APT at install
time, not at build time.

# Cover art

mpDris2 resolves `mpris:artUrl` through a fixed pipeline. The first
step that yields a usable image wins; later steps are skipped.

| # | Step | Source | Exposed `mpris:artUrl` | Wins when… |
|---|------|--------|------------------------|-----------|
| 1 | MPD `readpicture` | Embedded picture in the audio file (FLAC `PICTURE`, ID3 `APIC`, …) | `file:///tmp/cover-*.{jpg,png,…}` | The track carries embedded art |
| 2 | FS regex scan | `cover_regex` match in the song's directory (default matches `cover.*`, `folder.*`, `album.*`, `front.*`) | `file://` URI of the matched file (RFC-3986 percent-encoded) | A non-standardly-named cover sits next to the audio file (local FS only) |
| 3 | MPD `albumart` | `cover.{png,jpg,jxl,webp}` in the song's directory (resolved server-side by MPD) | `file:///tmp/cover-*.{jpg,png,…}` | Remote MPD, or step 2 missed (standard name only) |
| 4 | CUE/cdda fallback | `cover_regex` match next to the loaded `.cue` playlist (FS scan), falling back to MPD `albumart` (which server-side resolves `cover.{png,jpg,jxl,webp}`) when music_dir isn't locally accessible | `file://` URI of the matched file (local FS) or `file:///tmp/cover-*` (remote MPD) | The song is a CUE virtual track (cdda://, http://, …) and the CUE's own directory holds a cover |
| 5 | Remote cover URL | MusicBrainz/CAA, iTunes, Deezer — whichever are listed in `[Cover] sources`, in that priority order. For web radio (title only) each source resolves the album within its own catalogue | Remote image **URL** (image not downloaded) | Earlier steps failed, a source is enabled and has cover art for the `(artist, album)` |
| 6 | Station favicon | Community Radio Browser lookup of the stream URL (`radiobrowser` in `[Cover] stream_sources`) | Station favicon **URL** (image not downloaded) | An `http(s)://` web-radio stream whose station has a favicon |
| 7 | myMPD WebradioDB | `MYMPD_API_WEBRADIODB_RADIO_GET_BY_URI` against the myMPD at `[Cover] mympd_uri` (`mympd` in `[Cover] stream_sources`) | WebradioDB cover **URL** (image not downloaded) | A web-radio stream that the configured myMPD's WebradioDB knows |

Step 5's MusicBrainz/CAA lookup needs the optional `[cover]` extra
(`pip install '.[cover]'`, or the `python3-musicbrainzngs` package);
artist/title validation is stdlib (`difflib`). The iTunes, Deezer and
myMPD fallbacks are stdlib-only. Steps 5–7 return a remote URL used as `mpris:artUrl` — the
MPRIS client fetches it, nothing is downloaded or cached to disk.

# Used in

- [odio](https://odio.love/)
  ([odios](https://github.com/b0bbywan/odios)): an open-source,
  self-hosted multi-protocol audio streamer that turns a Raspberry Pi or
  Debian box into a hi-fi network receiver. It bundles Bluetooth A2DP,
  AirPlay, Snapcast multi-room, UPnP/DLNA, Spotify Connect, automatic CD
  playback and web radio on top of MPD. Odio runs mpDris2 to expose its
  MPD over MPRIS2, including the cover pipeline that resolves artwork for
  CD and web-radio playback.

# Contributing

Issues and pull requests are welcome on
[GitHub](https://github.com/b0bbywan/mpDris2/issues).

```sh
git clone https://github.com/b0bbywan/mpDris2.git
cd mpDris2
pip install -e '.[dev,cover]'   # dev tooling + optional cover deps
make lint                       # ruff + mypy
make test                       # pytest
```

Run `make lint` and `make test` before opening a PR, and keep commits
focused (one logical change each). Module layout and responsibilities
are documented in `CLAUDE.md`.

Filing a bug? Run the daemon with `mpDris2 -v` and paste the verbose log
into the issue.

# Credits

This is an asyncio + dbus-fast rewrite of the original
[mpDris2](https://github.com/eonpatapon/mpDris2), whose authors are Erik
Karlsson, Jean-Philippe Braun, Christoph Reiter and Mantas Mikulėnas.
The Debian packaging traces back to Simon McVittie.

# License

mpDris2 is licensed under the GNU General Public License v3.0 or later
(GPL-3.0-or-later). See [COPYING](COPYING) for the full text.
