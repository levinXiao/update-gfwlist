#!/bin/bash
# update_gfwlist.sh
# Remember to chmod +x the script.

GFWLIST="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt"
PROXY="127.0.0.1:1080"
USER_RULE_NAME="user-rule.txt"

check_module_installed() {
	pip list | grep gfwlist2pac &> /dev/null

	if [ $? -eq 1 ]; then
		echo "正在安装 gfwlist2pac."
		pip install gfwlist2pac
	fi
}

update_gfwlist() {
	echo "正在下载gfwlist."

	curl -s "$GFWLIST" --fail --socks5-hostname "$PROXY" --output /tmp/gfwlist.txt

	if [[ $? -ne 0 ]]; then
		echo "出现错误,停止更新"
    exit 1
	fi

	cd ~/.ShadowsocksX || exit 1

	if [ -f "gfwlist.js" ]; then
		mv gfwlist.js ~/.Trash
	fi

	if [ ! -f $USER_RULE_NAME ]; then
		touch $USER_RULE_NAME
	fi

	/usr/local/bin/gfwlist2pac \
    --input /tmp/gfwlist.txt \
    --file gfwlist.js \
    --proxy "SOCKS5 $PROXY; SOCKS $PROXY; DIRECT" \
    --user-rule $USER_RULE_NAME \
    --precise

  rm -f /tmp/gfwlist.txt

  echo "更新完成"
}

check_module_installed
update_gfwlist
