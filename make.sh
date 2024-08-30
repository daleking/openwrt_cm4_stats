#!/bin/bash

if [[ ! -f config ]]; then
  cp -p config.template config
  ${EDITOR:-vi} config
fi

eval "$(cat config)"

if [[ -z $PREFIX || -z $SERVER || -z $PORT || -z $PPPOE_WAN || -z $ROUTER ]]; then
  echo "Unable to configure from config file" >&2
  exit 1
fi

cp -p openwrt_cm4_stats_run.sh_template openwrt_cm4_stats_run.sh
cp -p openwrt_cm4_stats.sh_template openwrt_cm4_stats.sh
cp -p grafana_dashboard.template grafana_dashboard


perl -pi -e "s/__PREFIX__/$PREFIX/g;" \
         -e "s/__CARBON_SERVER__/$SERVER/g;" \
         -e "s/__CARBON_PORT__/$PORT/g;" \
        openwrt_cm4_stats_run.sh

perl -pi -e "s/__PPPOE_WAN__/$PPPOE_WAN/g;" \
        openwrt_cm4_stats.sh

perl -pi -e "s/__PREFIX__/$PREFIX/g;" \
        grafana_dashboard
#
# ssh install
#
[[ "$1" != "install" ]] && echo -e "To install via root ssh, run: $0 install" && exit

chmod 700 openwrt_cm4_stats_run.sh
chmod 755 openwrt_cm4_stats.sh

chmod 750 local_stats

ssh root@$ROUTER "mkdir -p /usr/local/bin/ && chmod 755 /usr/local/bin"
scp -p openwrt_cm4_stats.sh openwrt_cm4_stats_run.sh root@$ROUTER:/usr/local/bin/
scp local_stats root@$ROUTER:/etc/init.d/
ssh root@$ROUTER "/etc/init.d/local_stats enable ; service local_stats stop ; sleep 1 ; service local_stats start ; sleep 1 ; ps w | grep openwrt_cm4_stats_run"
