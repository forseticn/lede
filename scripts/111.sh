#!/bin/sh

. /etc/os-release
. /lib/functions/uci-defaults.sh

uci set firewall.@zone[1].input='ACCEPT'  # 允许 WAN 口的输入流量
uci commit firewall
/etc/init.d/firewall restart

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci commit

exit 0
