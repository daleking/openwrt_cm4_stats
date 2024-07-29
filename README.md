# Simple OpenWRT RPi CM4 PPPoE Router Stats

## Description

Simple lightweight scripts to send OpenWRT RPi CM4 PPPoE router and hardware
stats to a Graphite/Carbon host, for visualising with Grafana.

Consider using a proper solution like collectd, but these scripts are handy
as they scrape things like CPU Frequency, Temperature and Throttling.

## Getting Started

### Dependencies

You will need ssh/scp access to your OpenWRT router as root.

The script itself is readily hackable.  The run script can be modified to
handle other use cases.

No other OpenWRT dependencies are needed.

### Installing

Copy config.sample to config and update the variables.  Review and then run:

```
./make.sh install
```

This will copy the scripts with config embedded to /usr/local/bin on your CM4.

A service called `local_stats` will be created to continuously run the
wrapper script to send the stats in carbon format, on each minute.

### Example:

```
root@gw:~# /usr/local/bin/openwrt_cm4_stats.sh
uptime 698825.19
idletime 2775576.77
carrier 1
rx_bytes 204211377944
rx_dropped 0
rx_errors 0
rx_packets 161866596
tx_bytes 11167323369
tx_dropped 0
tx_errors 0
tx_packets 101790756
rpi.cpu_freq_mhz 800
rpi.cpu_tempc 38.4
rpi.under_voltage_detected 0
rpi.arm_frequency_capped 0
rpi.currently_throttled 0
rpi.soft_temperature_limit_active 0
```

Running service:

```
root@gw:~# service local_stats status
running

root@gw:~# ps w | grep openwrt_cm4_stats
 1444 root      1316 R    grep openwrt_cm4_stats
31127 root      1320 S    {openwrt_cm4_sta} /bin/sh /usr/local/bin/openwrt_cm4_stats_run.sh
```

### Author

Dale King 07-2024
