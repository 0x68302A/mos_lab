#!/bin/bash

## Export interface IDs
export default_gw=$(echo $(ip route | grep default) | cut -d " " -f 3)
export default_iface=$(/sbin/route | grep '^default' | grep -o '[^ ]*$')

export iface_pub_nic="mos_lab-pub"

####################
## GENERAL RULLES ##
####################

sudo nft "flush ruleset"

## Create table, and accept established,related packets
sudo nft "add table mos_lab-filter"
sudo nft "add chain mos_lab-filter input { type filter hook input priority 0; policy accept; } "
sudo nft "add rule mos_lab-filter input ct state established,related accept;"

## Drop all traffic from the private ( Potetianly malicious ) interfaces
sudo nft "add rule mos_lab-filter input iifname mos_lab-priv-01 drop;"
sudo nft "add rule mos_lab-filter input iifname mos_lab-priv-02 drop;"
sudo nft "add rule mos_lab-filter input iif " $default_iface " accept;"

## Enable IPV4 forwarding
sudo sysctl -q net.ipv4.ip_forward=1
sudo sysctl -q net.ipv6.conf.default.forwarding=0
sudo sysctl -q net.ipv6.conf.all.forwarding=0


######################
## PUBLIC INTERFACE ##
######################

## Create table, and accept established,related packets
sudo nft "add table mos_lab-pub-nat"
sudo nft "add chain mos_lab-pub-nat mos_prerouting { type nat hook prerouting priority -100; policy drop; }"

## Configure NAT options, for our host- connected bridge interface
sudo nft "add chain mos_lab-pub-nat mos_postrouting { type nat hook postrouting priority 100 ; }"
sudo nft "add rule mos_lab-pub-nat mos_postrouting masquerade;"

## Configure vm to host relationship
sudo nft "add rule mos_lab-pub-nat mos_prerouting iif" $iface_pub_nic "accept;"
sudo nft "add rule mos_lab-pub-nat mos_prerouting iif" $iface_pub_nic "tcp dport { 80, 443 } dnat " $default_gw ";"


########################
## PRIVATE INTERFACEs ##
########################

## Create table, and accept established,related packets
sudo nft "add table mos_lab-priv"
sudo nft "add chain mos_lab-priv mos_input { type filter hook input priority 50; policy drop; } "
sudo nft "add rule mos_lab-priv mos_input ct state established,related accept;"

## Accept inter-vm connections on priv-01 bridge, drop all else
sudo nft "add rule mos_lab-priv mos_input iifname mos_lab-priv-02 drop;"
sudo nft "add rule mos_lab-priv mos_input iifname mos_lab-priv-02 ip daddr 10.0.4.0/24 accept;"
sudo nft "add rule mos_lab-priv mos_input iifname mos_lab-priv-02 ip daddr 10.0.4.1 drop;"

## Accept inter-vm connections on priv-02 bridge, drop all else
sudo nft "add rule mos_lab-priv mos_input iifname mos_lab-priv-01 drop;"
sudo nft "add rule mos_lab-priv mos_input iifname mos_lab-priv-01 ip daddr 10.0.2.0/24 accept;"
sudo nft "add rule mos_lab-priv mos_input iifname mos_lab-priv-01 ip daddr 10.0.2.1 drop;"
