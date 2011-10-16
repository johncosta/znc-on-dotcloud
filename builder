#!/bin/sh
[ "$ZNC_USER" ] || {
    echo "ZNC_USER not set. Aborting."
    exit 1
}
[ "$ZNC_PASS" ] || {
    echo "ZNC_PASS not set. Aborting."
    exit 1
}
mkdir -p ~/.znc/configs
ZNC_SALT="$(dd if=/dev/urandom bs=16c count=1 | md5sum | awk '{print $1}')"
ZNC_HASH="sha256#$(echo -n ${ZNC_PASS}${ZNC_SALT} | sha256sum | awk '{print $1}')#$ZNC_SALT#"
cat >~/.znc/configs/znc.conf <<EOF
Listen     = $PORT_IRC
LoadModule = lastseen

<User $ZNC_USER>
        Pass       = $ZNC_HASH
        Admin      = true
        Nick       = $ZNC_USER
        AltNick    = _$ZNC_USER
        Ident      = $ZNC_USER
        RealName   = $ZNC_USER
        Buffer     = 200
        KeepBuffer = false
        ChanModes  = +stn

        LoadModule = admin
        LoadModule = awaynick
        LoadModule = keepnick
        LoadModule = kickrejoin
        LoadModule = log
        LoadModule = nickserv
        LoadModule = simple_away

        Server     = irc.freenode.net 6667

        <Chan #dotcloud>
        </Chan>
</User>
EOF
