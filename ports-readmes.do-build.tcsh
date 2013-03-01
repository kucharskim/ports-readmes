#!/usr/local/bin/tcsh
# http://ports.su/ generator

alias idate	date "+%Y-%m-%dT%H:%M:%S%z"
alias uptime	'env LC_TIME=fr_FR.UTF-8 uptime | sed "s@^[ 0-9:AaPp]*[Mm]@@"'

echo `idate` "starting ${0}"
uptime
echo

set FILESDIR=files
set WRKBUILD=share
set LOCALBASE=.
set SQLPORTS=sqlports-compact-`date +%Y-%m-%d`.tgz

test ! -e ${FILESDIR}/make-readmes && exit 1

mkdir -p ${WRKBUILD} || exit 2

test ! -e ${SQLPORTS} && \
( mv sqlports-compact-*.tgz ${WRKBUILD}; \
echo `idate` "wget:"; \
time wget -6 "ftp://ftp.nluug.nl/pub/OpenBSD/snapshots/packages/`uname -m`/sqlports-compact-*.tgz" \
-O ${SQLPORTS} ; echo; \
echo `idate` "tar:"; \
time tar -xzf ${SQLPORTS} share ; echo )

echo `idate` "perl make-readmes started..."
time env	TEMPLATESDIR=${FILESDIR} \
	OUTPUTDIR=${WRKBUILD} \
	DATABASE=${LOCALBASE}/share/sqlports-compact \
	    perl ${FILESDIR}/make-readmes >/dev/null
uptime
echo `idate` "perl make-readmes finished."
echo

echo `idate` potentially stale:
time find ${WRKBUILD} -type f -mmin +60
echo

time
uptime
echo `idate` done.