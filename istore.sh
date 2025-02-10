# 设置默认IP地址
sed -i 's/192.168.100.1/10.0.0.3/g' package/istoreos-files/Makefile
sed -i 's/192.168.1.1/10.0.0.3/g' package/base-files/files/bin/config_generate


# 清除登陆密码
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/lean/default-settings/files/zzz-default-settings

# 修改 uhttpd 端口，避免与 nginx 冲突
echo "Modifying uhttpd configuration..."
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config

# 禁用 uhttpd 并安装 nginx
echo "Disabling uhttpd and installing nginx..."
mkdir -p package/base-files/files/etc/init.d/
cat <<EOF > package/base-files/files/etc/init.d/custom_init
#!/bin/sh /etc/rc.common
START=99

start() {
    echo "Disabling uhttpd..."
    /etc/init.d/uhttpd disable
    /etc/init.d/uhttpd stop

    echo "Installing nginx..."
    opkg update && opkg install nginx
    /etc/init.d/nginx enable
    /etc/init.d/nginx start
}
EOF

chmod +x package/base-files/files/etc/init.d/custom_init

# 配置 nginx
echo "Configuring nginx..."
mkdir -p package/base-files/files/etc/nginx/
cat <<EOF > package/base-files/files/etc/nginx/nginx.conf
server {
    listen 80;
    server_name localhost;
    location / {
        root /www;
        index index.html;
    }
}
EOF

echo "Nginx configuration completed."


# 调整 Docker 到 服务 菜单
# sed -i 's/"admin"/"admin", "services"/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
# sed -i 's/"admin"/"admin", "services"/g; s/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
# sed -i 's/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
# sed -i 's|admin\\|admin\\/services\\|g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/container.htm

./scripts/feeds update -a
./scripts/feeds install -a
