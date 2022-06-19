#!/bin/bash
: '
This is a quick script to set up a route-based VPN & BGP with
Azure. It is probably close to working with other clouds.
The P1 and P2 variables are for future use.
'

OUTFILE="bgp.clish"
P1="20.96.43.232" #VPN Peer 
B1="172.18.0.12" #BGP Peer
P1NAME="Azure-instance0" #Interoprobal Device Object Name 
P2="20.85.26.91" #VPN Peer
B2="172.18.0.13" #BGP Peer
P2NAME="Azure-instance1" #Interoprobal Device Object Name 
MYIP="169.254.254.2" #VPN Tunnel interface IP address
BGPIP="169.254.254.1" #My BGP Router-ID, usualy the cluster VIP
MYASN="65500" #My AS Number
AZASN="65515" #Azure's ASN

#New configuration file
echo "set clienv on-failure continue" >${OUTFILE} #If something isn't set, continue

### Clear Out Configuration ###
echo "set bgp external remote-as ${AZASN} peer ${B1} off" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B2} off" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} off" >>${OUTFILE}
echo "set routemap im_azure id 10 off" >>${OUTFILE}
echo "set routemap ex_azure id 10 off" >>${OUTFILE}
echo "delete vpn tunnel 100" >>${OUTFILE}
echo "delete vpn tunnel 101" >>${OUTFILE}
echo "set clienv on-failure stop" >>${OUTFILE} #Errors after this stops the script

#Create the tunnel interfaces
echo "add vpn tunnel 100 type numbered local ${MYIP} remote ${B1} peer ${P1NAME}" >>${OUTFILE}
echo "set interface vpnt100 comments ${P1NAME}"  >>${OUTFILE}
echo "set interface vpnt100 state on"  >>${OUTFILE}
echo "set interface vpnt100 mtu 1500" >>${OUTFILE}

echo "add vpn tunnel 101 type numbered local ${MYIP} remote ${B2} peer ${P2NAME}" >>${OUTFILE}
echo "set interface vpnt101 comments ${P2NAME}" >>${OUTFILE}
echo "set interface vpnt101 state on"  >>${OUTFILE}
echo "set interface vpnt101 mtu 1500" >>${OUTFILE}

#Local BGP
echo "set as ${MYASN}" >>${OUTFILE}
echo "set router-id ${BGPID}" >>${OUTFILE}
echo "set bgp ecmp on" >>${OUTFILE}

#Azure BGP
echo "set bgp external remote-as ${AZASN} on" >>${OUTFILE}

#Azure BGP peer one
echo "set bgp external remote-as ${AZASN} peer ${B1} on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B1} graceful-restart on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B1} ip-reachability-detection on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B1} ip-reachability-detection check-control-plane-failure on" >>${OUTFILE}

#Azure BGP peer two
echo "set bgp external remote-as ${AZASN} peer ${B2} on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B2} graceful-restart on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B2} ip-reachability-detection on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B2} ip-reachability-detection check-control-plane-failure on" >>${OUTFILE}

#Accept routes from Azure

echo "set routemap im_azure id 10 on" >>${OUTFILE}
echo "set routemap im_azure id 10 allow" >>${OUTFILE}
# If you want to limit imported network do so like this
#echo "set routemap im_azure id 10 match network 172.17.0.0/16 all" >>${OUTFILE}

#apply the import route maps
echo "set bgp external remote-as ${AZASN} peer ${B1} import-routemap im_azure preference 1 on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B2} import-routemap im_azure preference 1 on" >>${OUTFILE}

#Send routes to Azure
echo "set routemap ex_azure id 10 on" >>${OUTFILE}
echo "set routemap ex_azure id 10 allow" >>${OUTFILE}
echo "set routemap ex_azure id 10 match protocol direct" >>${OUTFILE}
#I am sending routes from two only two interfaces. 
#If you remove these you will send all directly connected routes
echo "set routemap ex_azure id 10 match interface eth1 on" >>${OUTFILE}
echo "set routemap ex_azure id 10 match interface eth2.2 on" >>${OUTFILE}

#Apply the export
echo "set bgp external remote-as ${AZASN} peer ${B1} export-routemap ex_azure preference 1 on" >>${OUTFILE}
echo "set bgp external remote-as ${AZASN} peer ${B2} export-routemap ex_azure preference 1 on" >>${OUTFILE}
