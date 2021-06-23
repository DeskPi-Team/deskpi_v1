#!/bin/bash
# uninstall deskpi v4 script 

deskpiv4=/lib/systemd/system/systemd-deskpiv4-safecutoffpower.service
echo "DeskPi V4 Driver Uninstalling..."
echo "Configure /boot/config.txt"
sudo sed -i '/dtoverlay=dwc2,dr_mode=host/d' /boot/config.txt
echo "Stop and disable DeskPi V4 services"
sudo rm -f $deskpiv4 2&>/dev/null 
sudo rm -f /usr/bin/safecutoffpower* 2&>/dev/null
sudo rm -rf /etc/modules-load.d/raspberry.conf 2&>/dev/null
echo "Uninstall DeskPi V4 Driver Successfully." 

