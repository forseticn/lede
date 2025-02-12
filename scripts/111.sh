#!/bin/sh

. /etc/os-release
. /lib/functions/uci-defaults.sh

# 默认wan口防火墙打开
uci set firewall.@zone[1].input='ACCEPT'
uci commit firewall

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci commit

exit 0
