AC_INIT(mpDris2, 0.1)
AM_INIT_AUTOMAKE(mpDris2, 0.1, [https://github.com/eonpatapon/mpDris2])
AM_PATH_PYTHON([2.5],, [:])
GETTEXT_PACKAGE=mpDris2
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE",
    [The prefix for our gettext translation domains.])
IT_PROG_INTLTOOL(0.26)
AC_OUTPUT([
Makefile
src/Makefile
po/Makefile.in
])
dnl Warn user sysconfdir is not /etc, if necessary.
make sysconfdirwarning
