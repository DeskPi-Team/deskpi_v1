#!/bin/bash
# uninstall deskpi v4 script in ubuntu mate
. /lib/lsb/init-functions

daemonname="deskpi_v4"
safecutoffpower=/lib/systemd/system/$daemonname-safecutoffpower.service

log_action_msg "Remove dtoverlay configure from /boot/firmware/config.txt file"
sudo sed -i '/dtoverlay=dwc2,dr_mode=host/d' /boot/firmware/config.txt
log_action_msg "Stop and disable DeskPi V4 services"
sudo systemctl disable $safecutoffpower 2&>/dev/null
sudo systemctl stop $safecutoffpower 2&>/dev/null
log_action_msg "Remove DeskPi V4 Driver."
sudo rm -f  $safecutoffpower 2&>/dev/null 
sudo rm -f /usr/bin/safecutoffpower 2&>/dev/null
sudo rm -f /usr/bin/Deskpi-uninstall 2&>/dev/null 
log_success_msg "Uninstall DeskPi V4 Driver Successfully." 
sudo rm -rf /home/$SUDO_USER/deskpi_v4
log_success_msg "Remove DeskPi V4 Driver Repository Successfully." 
