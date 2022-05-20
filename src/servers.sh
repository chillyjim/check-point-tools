#!/bin/bash

# This is a quick and dirty script to make sure your gateways and management servers
# have conectivity to Check Point's required servers. This does not check that the information
# returned is correct/useful or even if anything is returned. It only checks that the server
# can be reached at all.

# This is for R80+ Gaia, not embeded Gaia/VNF/SMB. See SK83520 for more information.
# This is provided as-is, no copyright implied, and is not supported by Check Point or
# myself, I just got tired of looking it all up and checking by hand.

# Jim Holmes (Chillyjim)
# jholmes+cm@checkpoint.com
# jlh+cm@chillyjim.org

# Version 0.2 -- Corrected some URLs that didn't past correctly
#                and added a description of what is being checked



# OUTPUT-COLORING
red=$( tput setaf 1 )
green=$( tput setaf 2 )
NC=$( tput setaf 7 )

# This does a simple curl (curl_cli) check of the server, using the Check Point CA bundle.
function checkUpdate {
    if curl_cli --cacert "$CPDIR"/conf/ca-bundle.crt "$1" > /dev/null 2>&1;
       then printf "%s\n" "$green$2 $1 is OK$NC"
       else printf "%s\n" "$red$2 Cannot connect to $1$NC"
    fi
}

checkUpdate http://cws.checkpoint.com/APPI/SystemStatus/type/short "Social Widget Categorization"
checkUpdate http://cws.checkpoint.com/URLF/SystemStatus/type/short "URL Categorization"
checkUpdate http://cws.checkpoint.com/AntiVirus/SystemStatus/type/short "Virus Detection"
checkUpdate http://cws.checkpoint.com/Malware/SystemStatus/type/short "Bot Detection"
checkUpdate https://updates.checkpoint.com/WebService/Monitor "IPS and Updateable Objects"
checkUpdate https://crl.godaddy.com/ "Godaddy CRL"
checkUpdate http://crl.globalsign.com/ "Globalsign CRL"
checkUpdate http://dl3.checkpoint.com "Download Services and Updateable objects"
checkUpdate https://usercenter.checkpoint.com/usercenter/services/ProductCoverageService "IPS Entitlement Check"
checkUpdate https://usercenter.checkpoint.com/usercenter/services/BladesManagerService "Software Blades Manager Service"
checkUpdate http://resolver1.chkp.ctmail.com "Suspicious Mail Outbreaks #1"
checkUpdate http://resolver2.chkp.ctmail.com "Suspicious Mail Outbreaks #2"
checkUpdate http://resolver3.chkp.ctmail.com "Suspicious Mail Outbreaks #3"
checkUpdate http://resolver4.chkp.ctmail.com "Suspicious Mail Outbreaks #4"
checkUpdate http://resolver5.chkp.ctmail.com "Suspicious Mail Outbreaks #5"
checkUpdate http://download.ctmail.com "Anti-Spam"
checkUpdate https://te.checkpoint.com/tecloud/Ping "Threat Emulation #1"
checkUpdate http://teadv.checkpoint.com/version.txt "Threat Emulation #2" 
checkUpdate https://threat-emulation.checkpoint.com/tecloud/Ping 
checkUpdate https://ptcs.checkpoint.com "Private Threatcloud Updates #1"
checkUpdate https://ptcd.checkpoint.com  "Private Threat Cloud Updates #2"
checkUpdate http://kav8.zonealarm.com/version.txt "Archive Scanning"
checkUpdate http://secureupdates.checkpoint.com "General Spdates"
checkUpdate https://productcoverage.checkpoint.com/ProductCoverageService "Contract Checks"
checkUpdate https://sc1.checkpoint.com/sc/images/checkmark.gif "Icons"
checkUpdate https://sc1.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png "Icons"
checkUpdate https://sc2.checkpoint.com/sc/images/checkmark.gif "Icons"
checkUpdate https://sc2.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png "Icons"
checkUpdate https://sc3.checkpoint.com/sc/images/checkmark.gif "Icons"
checkUpdate https://sc3.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png "Icons"
checkUpdate https://sc4.checkpoint.com/sc/images/checkmark.gif "Icons"
checkUpdate https://sc4.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png "Icons"
checkUpdate https://sc5.checkpoint.com/sc/images/checkmark.gif "Icons"
checkUpdate https://sc5.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png "Icons"
checkUpdate https://push.checkpoint.com/push/ping "Capsule Workspace Push Notification"
checkUpdate http://downloads.checkpoint.com "Endpoint Compliance Updates"
checkUpdate http://productservices.checkpoint.com "NG License Checks"
