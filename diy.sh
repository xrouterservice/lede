#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# https://github.com/RealKiro/Actions-OpenWrt/blob/r619ac/diy.sh
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.4.1/g' package/base-files/files/bin/config_generate

# 更改默认主题为Argon
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' package/feeds/luci/luci/Makefile
#git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/mine/luci-theme-argon_new
# sed -i 's/luci-theme-bootstrap/luci-theme-argon_new/g' package/feeds/luci/luci/Makefile

# 复杂的AdGuardHome的openwrt的luci界面
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/mine/luci-app-adguardhome

# DiskMan for LuCI (WIP)
git clone https://github.com/lisaac/luci-app-diskman.git package/mine/luci-app-diskman
mkdir -p package/mine/parted && cp -i package/mine/luci-app-diskman/Parted.Makefile package/mine/parted/Makefile

# KPR plus+
# git clone https://github.com/project-openwrt/luci-app-koolproxyR.git package/mine/luci-app-koolproxyR
git clone https://github.com/jefferymvp/luci-app-koolproxyR.git package/mine/luci-app-koolproxyR

# Server酱
git clone https://github.com/tty228/luci-app-serverchan.git package/mine/luci-app-serverchan

# FileBrowser
git clone https://github.com/project-openwrt/FileBrowser.git package/mine/FileBrowser

# 网易云音乐
git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic.git package/mine/luci-app-unblockneteasemusic

# 网易云音乐GoLang版本
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic-go.git package/mine/luci-app-unblockneteasemusic-go
git clone https://github.com/cnsilvan/luci-app-unblockneteasemusic.git package/mine/luci-app-unblockneteasemusic-go
# 网易云音乐mini
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic-mini.git package/mine/luci-app-unblockneteasemusic-mini

# disable usb3.0
# git clone https://github.com/rufengsuixing/luci-app-usb3disable.git package/mine/luci-app-usb3disable

# 管控上网行为
git clone https://github.com/destan19/OpenAppFilter.git package/mine/OpenAppFilter

# Rclone-OpenWrt
git clone https://github.com/ElonH/Rclone-OpenWrt.git package/mine/Rclone-OpenWrt

# ssr-plus-Jo 被Vssr替代
#git clone https://github.com/project-openwrt/luci-app-ssr-plus-Jo.git package/mine/luci-app-ssr-plus-Jo
#git clone https://github.com/Leo-Jo/luci-app-ssr-plus-jo.git package/mine/luci-app-ssr-plus-leo-Jo

# luci-app-frps
git clone https://github.com/project-openwrt/luci-app-frps.git package/mine/luci-app-frps

# luci-app-koolddns
# wget https://github.com/Ameykyl/openwrt18.06/blob/master/package/diy/luci-app-koolddns.tar.xz 
# xz -d luci-app-koolddns.tar.xz
# tar -xvf  luci-app-koolddns.tar

#luci-app-koolddns
git clone https://github.com/xrouterservice/luci-app-koolddns.git package/mine/luci-app-koolddns

# luci-app-aliddns
git clone https://github.com/honwen/luci-app-aliddns.git package/mine/luci-app-aliddns

# openclash
git clone https://github.com/vernesong/OpenClash.git package/mine/OpenClash

#luci-app-dnspod
# git clone https://github.com/bdhjiajia/luci-app-dnspod.git package/mine/luci-app-dnspod

#luci-app-vssr
git clone https://github.com/Leo-Jo/luci-app-vssr.git package/mine/luci-app-vssr
#vssr的依赖包 需要的依赖有python3-maxminddb libmaxminddb 请自行添加 建议搭配argon theme
git clone https://github.com/Leo-Jo-My/my package/mine/luci-app-vssr-lib 
