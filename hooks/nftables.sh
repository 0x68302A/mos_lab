#!/bin/bash

export default_gw=$(echo $(ip route | grep default) | cut -d " " -f 3)
export iface_nic="mos_sec-pub"

## Create Base for our firewall
nft "flush ruleset"
nft "add table FILTER"
nft "add chain FILTER INPUT { type filter hook input priority 0; policy accept; }"
nft "add rule FILTER INPUT ct state established,related accept;"

## Enable IPV4 forwarding
sysctl -q net.ipv4.ip_forward=0
sysctl -q net.ipv6.conf.default.forwarding=0
sysctl -q net.ipv6.conf.all.forwarding=0
