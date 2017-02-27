#!/bin/bash

INSTALLDIR=$1
REPODIR=$2
SUBSCRIBE=$3

if [ -z "$INSTALLDIR" ]; then
    echo "Usage: $(basename $0) <installation dir> [repo dir] [subscribe]"
    exit 1
fi

if [ -z "$REPODIR" ]; then
    REPODIR="$INSTALLDIR/repos"
fi

mkdir -p $INSTALLDIR/{bin,etc/{dtmrepo.conf.d,dtmrepo.repos.d},var/{log,cache/dtmrepo}} $REPODIR
if [ "$?" -ne 0 ]; then
    echo "Error creating installation directory tree."
    exit 1
fi

echo -e "#!/bin/bash\n\nINSTALLDIR=$INSTALLDIR" > $INSTALLDIR/bin/dtmrepo
tail -n +4 dtmrepo >> $INSTALLDIR/bin/dtmrepo
\cp readconf dtmrepo-repoconf $INSTALLDIR/bin && chmod +x $INSTALLDIR/bin/*

cat <<EOF > $INSTALLDIR/etc/dtmrepo.conf
[global]
rootdir = $REPODIR
confdir = $INSTALLDIR/etc/dtmrepo.conf.d
yumconf = $INSTALLDIR/etc/dtmrepo-yum.conf
keep = 3
arch = x86_64
subscribed = 0
EOF

cat <<EOF > $INSTALLDIR/etc/dtmrepo-yum.conf
[main]
cachedir = $INSTALLDIR/var/cache/dtmrepo
logfile = $INSTALLDIR/var/log/dtmrepo.log
obsoletes = 1
plugins = 1
reposdir = $INSTALLDIR/etc/dtmrepo.repos.d
EOF

rpm -q --quiet httpd || yum -y install httpd
if [ "$?" -ne 0 ]; then
    echo "Error installing httpd."
    exit 1
fi

\cp httpd-dtmrepo.conf /etc/httpd/conf.d/dtmrepo.conf
ln -sf $REPODIR /var/www/dtmrepo
chkconfig httpd on
service httpd start

if [ "$SUBSCRIBE" == "subscribe" ]; then
    sed -i 's/^subscribed.\+/subscribed = 1/' $INSTALLDIR/etc/dtmrepo.conf
    $INSTALLDIR/bin/dtmrepo -i
fi

