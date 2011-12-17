SUBDIRS = src
dist_doc_DATA = README COPYING AUTHORS

EXTRA_DIST = autogen.sh

             
dist-hook:                                                                      
	rm -rf `find $(distdir) -name *~`

sysconfdirwarning:
	@if test "${sysconfdir}" != "/etc"; then \
		echo '###'; \
		echo '### $${sysconfdir} evaluates to '${sysconfdir}': this is probably not what you want !'; \
		echo '### You may want to launch ./configure --sysconfdir=/etc.'; \
		echo '###'; \
	fi

.PHONY = sysconfdirwarning
