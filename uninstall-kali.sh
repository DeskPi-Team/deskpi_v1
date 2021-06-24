#!/bin/bash
# uninstall deskpi script 
. /lib/lsb/init-functions

daemonname="deskpi_v1-safecutoffpower.service"
safeshutdaemon=/lib/systemd/system/$daemonname

log_action_msg "Uninstalling DeskPi V1 Driver..."
sleep 1
log_action_msg "Remove dtoverlay configure from /boot/config.txt file"
sudo sed -i '/dtoverlay=dwc2,dr_mode=host/d' /boot/config.txt
log_action_msg "Stop and disable DeskPi V1 services"
sudo systemctl stop $daemonname 2&>/dev/null
log_action_msg "Remove DeskPi V1 Driver files..."
sudo rm -f  $safeshutdaemon 2&>/dev/null 
sudo rm -f /usr/bin/safecutoffpower 2&>/dev/null
sudo rm -f /usr/bin/Deskpi-uninstall 2&>/dev/null 
log_success_msg "Uninstall DeskPi V1 Driver Successfully." 
