desktopdir = ${datadir}/applications/
dbusdir = ${datadir}/dbus-1/services/
autostartdir = ${sysconfdir}/xdg/autostart/

dist_bin_SCRIPTS = mpDris2
dist_desktop_DATA = mpDris2.desktop
autostart_DATA = mpDris2.desktop
dist_doc_DATA = mpDris2.conf
nodist_dbus_DATA = org.mpris.MediaPlayer2.mpd.service

EXTRA_DIST = org.mpris.MediaPlayer2.mpd.service.in
CLEANFILES = org.mpris.MediaPlayer2.mpd.service

edit = sed -e 's|@bindir[@]|$(bindir)|g'

org.mpris.MediaPlayer2.mpd.service: Makefile
	rm -f $@ $@.tmp
	$(MKDIR_P) $(@D)
	srcdir=''
	test -f ./$@.in || srcdir=$(srcdir)/
	$(edit) $${srcdir}$@.in >$@.tmp
	mv $@.tmp $@

