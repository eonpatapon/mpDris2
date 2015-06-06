SUBDIRS = src po
dist_doc_DATA = README COPYING AUTHORS

EXTRA_DIST = autogen.sh

dist-hook:
	find $(distdir) -name "*~" -exec rm -vf {} +

sysconfdirwarning:
	@if test "${sysconfdir}" != "/etc"; then \
		echo '###'; \
		echo '### $${sysconfdir} evaluates to '${sysconfdir}': this is probably not what you want !'; \
		echo '### You may want to launch ./configure --sysconfdir=/etc.'; \
		echo '###'; \
	fi

.PHONY = sysconfdirwarning
