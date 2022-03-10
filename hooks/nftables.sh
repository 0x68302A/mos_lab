#!/bin/bash

## Create Base for our firewall
sudo nft "flush ruleset"

sudo nft "add table mos_lab"
sudo nft "add chain mos_lab input { type filter hook input priority 0; policy accept;} "
sudo nft "add rule mos_lab input ct state established,related accept;"
sudo nft "add rule mos_lab input iifname "mos_lab-priv" drop;"

## Accept inter-vm connections
sudo nft "add rule mos_lab input ip daddr 192.168.122.0/24 accept;"
sudo nft "add rule mos_lab input ip daddr 192.168.122.1 drop;"

## Accept SSH related connections
sudo nft "add rule mos_lab input iifname "mos_lab-priv" tcp dport 2022 accept;"


