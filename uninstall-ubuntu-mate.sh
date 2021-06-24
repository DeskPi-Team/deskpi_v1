#!/bin/bash
# uninstall deskpi v4 script in ubuntu mate
. /lib/lsb/init-functions

daemonname="deskpi_v1"
safecutoffpower=/lib/systemd/system/$daemonname-safecutoffpower.service

log_action_msg "Remove dtoverlay configure from /boot/firmware/config.txt file"
sudo sed -i '/dtoverlay=dwc2,dr_mode=host/d' /boot/firmware/config.txt
log_action_msg "Stop and disable DeskPi V1 services"
sudo systemctl disable $safecutoffpower 2&>/dev/null
sudo systemctl stop $safecutoffpower 2&>/dev/null
log_action_msg "Remove DeskPi V1 Driver."
sudo rm -f  $safecutoffpower 2&>/dev/null 
sudo rm -f /usr/bin/safecutoffpower* 2&>/dev/null
log_success_msg "Uninstall DeskPi V1 Driver Successfully." 
log_success_msg "Remove DeskPi V1 Driver Repository Successfully." 
