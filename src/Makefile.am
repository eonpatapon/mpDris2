desktopdir = ${datadir}/applications/
dbusdir = ${datadir}/dbus-1/services/
autostartdir = ${sysconfdir}/xdg/autostart/
systemd_userdir = ${prefix}/lib/systemd/user/

bin_SCRIPTS = mpDris2
dist_desktop_DATA = mpdris2.desktop
autostart_DATA = mpdris2.desktop
dist_doc_DATA = mpDris2.conf
nodist_dbus_DATA = org.mpris.MediaPlayer2.mpd.service
nodist_systemd_user_DATA = mpDris2.service

EXTRA_DIST = \
	org.mpris.MediaPlayer2.mpd.service.in \
	mpDris2.service.in \
	mpDris2.in.py

CLEANFILES = \
	org.mpris.MediaPlayer2.mpd.service \
	mpDris2.service \
	mpDris2

edit = sed -e 's|@bindir[@]|$(bindir)|g' \
	   -e 's|@datadir[@]|$(datadir)|g' \
	   -e 's|@gitversion[@]|$(GITVERSION)|g' \
	   -e 's|@version[@]|$(VERSION)|g'

mpDris2: mpDris2.in.py Makefile
	$(AM_V_GEN) $(edit) $< > $@.tmp && mv $@.tmp $@
	$(AM_V_at) chmod a+x $@

org.mpris.MediaPlayer2.mpd.service: org.mpris.MediaPlayer2.mpd.service.in Makefile
	$(AM_V_GEN) $(edit) $< > $@.tmp && mv $@.tmp $@

mpDris2.service: mpDris2.service.in Makefile
	$(AM_V_GEN) $(edit) $< > $@.tmp && mv $@.tmp $@
