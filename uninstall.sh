#!/bin/bash
# uninstall deskpi script 
. /lib/lsb/init-functions

daemonname="deskpilite.service"
filelocation=/lib/systemd/system/$daemonname

log_action_msg "Uninstalling DeskPi V1 Driver..."
sleep 1
log_action_msg "Remove dtoverlay configure from /boot/config.txt file"
sudo sed -i '/dtoverlay=dwc2,dr_mode=host/d' /boot/config.txt
log_action_msg "Stop and disable $daemonname"
sudo systemctl disable $daemonname 2&>/dev/null  
sudo systemctl stop $daemonname  2&>/dev/null
log_action_msg "Remove DeskPi Lite Driver..."
sudo rm -f  $filelocation  2&>/dev/null 
sudo rm -f /usr/bin/safecutofpower.py 2&>/dev/null 
log_success_msg "Uninstall DeskPi Lite Driver Successfully." 

