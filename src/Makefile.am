desktopdir = ${datadir}/applications/
dbusdir = ${datadir}/dbus-1/services/
autostartdir = ${sysconfdir}/xdg/autostart/

bin_SCRIPTS = mpDris2
dist_desktop_DATA = mpdris2.desktop
autostart_DATA = mpdris2.desktop
dist_doc_DATA = mpDris2.conf
nodist_dbus_DATA = org.mpris.MediaPlayer2.mpd.service

EXTRA_DIST = org.mpris.MediaPlayer2.mpd.service.in mpDris2.in
CLEANFILES = org.mpris.MediaPlayer2.mpd.service mpDris2.py mpDris2

edit = sed -e 's|@bindir[@]|$(bindir)|g' \
	   -e 's|@datadir[@]|$(datadir)|g'

mpDris2: mpDris2.in Makefile
	rm -f $@ $@.tmp
	$(MKDIR_P) $(@D)
	srcdir=''
	test -f ./$@.in || srcdir=$(srcdir)/
	$(edit) $${srcdir}$@.in > $@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@
	ln -sf $@ $@.py

org.mpris.MediaPlayer2.mpd.service: org.mpris.MediaPlayer2.mpd.service.in Makefile
	rm -f $@ $@.tmp
	$(MKDIR_P) $(@D)
	srcdir=''
	test -f ./$@.in || srcdir=$(srcdir)/
	$(edit) $${srcdir}$@.in > $@.tmp
	mv $@.tmp $@
