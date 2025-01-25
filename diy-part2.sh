# 设置默认IP地址
sed -i 's/192.168.1.1/10.0.0.3/g' package/base-files/luci2/bin/config_generate

# 清除登陆密码
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/lean/default-settings/files/zzz-default-settings

# 安装新的argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b master https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon


# 修改文本
# sed -i 's/"带宽监控"/"宽带"/g' `grep "带宽监控" -rl ./`
# sed -i 's/"Turbo ACC 网络加速"/"Turbo ACC"/g' package/feeds/luci/luci-app-turboacc/po/*/turboacc.po       # `grep "Turbo ACC 网络加速" -rl ./`

# 调整 Docker 到 服务 菜单
sed -i 's/"admin"/"admin", "services"/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
sed -i 's/"admin"/"admin", "services"/g; s/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
sed -i 's/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
sed -i 's|admin\\|admin\\/services\\|g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/container.htm

./scripts/feeds update -a
./scripts/feeds install -a
