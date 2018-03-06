#!/bin/bash
## CONFIGURATION CYBERIADE ##

IPT="/sbin/iptables"
INTERFACE_0="enp2s0"


# Remise a 0
${IPT} -F
${IPT} -t nat -F

#gateway rules
iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE

# Les connexions entrantes sont bloquées par défaut
${IPT} -P INPUT DROP
# Les connexions destinées à être routées sont acceptées par défaut
${IPT} -P FORWARD ACCEPT
# Les connexions sortantes sont acceptées par défaut
${IPT} -P OUTPUT ACCEPT


######################
# Règles de filtrage #
######################
# Nous précisons ici des règles spécifiques pour les paquets vérifiant
# certaines conditions.

# Pas de filtrage sur l'interface de "lo"
${IPT} -A INPUT -i lo -j ACCEPT

#on autorise tout le trafic de la carte réseau maitre

#${IPT} -A OUTPUT -i {INTERFACE_0} -j ACCEPT

# Accepter le protocole ICMP (notamment le ping)
${IPT} -A FORWARD -p icmp -j ACCEPT
 
# Accepter les packets entrants relatifs à des connexions déjà
# établies : cela va plus vite que de devoir réexaminer toutes
# les règles pour chaque paquet.
${IPT} -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
${IPT} -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# ftp 
#${IPT} -A FORWARD -p tcp --dport 20 -j ACCEPT 
#${IPT} -A FORWARD -p tcp --dport 21 -j ACCEPT

# SSH
${IPT} -A FORWARD -p tcp --dport 22 -j ACCEPT
# NTP
${IPT} -A FORWARD -p udp --dport 123 -j ACCEPT
# smtp
${IPT} -A FORWARD -p tcp --dport smtp -j ACCEPT
# Pour test bricolage smtp
${IPT} -A FORWARD -p tcp --dport 587 -j ACCEPT
# imap(s)
${IPT} -A FORWARD -p tcp --dport 143 -j ACCEPT
${IPT} -A FORWARD -p tcp --dport 993 -j ACCEPT
# sieve
#${IPT} -A FORWARD -p tcp --dport 4190 -j ACCEPT
# dns
${IPT} -A FORWARD -p tcp --dport domain -j ACCEPT
${IPT} -A FORWARD -p udp --dport domain -j ACCEPT
# http
${IPT} -A FORWARD -p tcp --dport http -j ACCEPT
# https
${IPT} -A FORWARD -p tcp --dport https -j ACCEPT


#################
# Regles de jeu #
#################

# Application Blizzard Battle.net
${IPT} -A FORWARD -p tcp -m multiport --dport 443,1119 -j ACCEPT
${IPT} -A FORWARD -p udp -m multiport --dport 443,1119 -j ACCEPT

# Discution vocale Blizzard
${IPT} -A FORWARD -p udp -m multiport --dport 3478:3479,5060,5062,6250,12000:64000 -j ACCEPT

#Blizzard Downloader
${IPT} -A FORWARD -p tcp -m multiport --dport 1119,1120,3724,4000,6112,6113,6114 -j ACCEPT
${IPT} -A FORWARD -p udp -m multiport --dport 1119,1120,3724,4000,6112,6113,6114 -j ACCEPT

#Hearstone
${IPT} -A FORWARD -p tcp -m multiport --dport 1119,3724 -j ACCEPT
${IPT} -A FORWARD -p udp -m multiport --dport 1119,3724 -j ACCEPT

#Overwatch
${IPT} -A FORWARD -p tcp -m multiport --dport 1119,3724,6113,80 -j ACCEPT
${IPT} -A FORWARD -p udp -m multiport --dport 3478:3479,5060,5062,6250,12000:64000 -j ACCEPT

#Rocket league
${IPT} -A FORWARD -p udp -m multiport --dport 7000:9000 -j ACCEPT

