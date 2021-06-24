#!/bin/bash
# uninstall deskpi v1 script 

deskpiv1=/lib/systemd/system/systemd-deskpiv1-safecutoffpower.service
echo "DeskPi V1 Driver Uninstalling..."
echo "Configure /boot/config.txt"
sudo sed -i '/dtoverlay=dwc2,dr_mode=host/d' /boot/config.txt
echo "Stop and disable DeskPi V1 services"
sudo rm -f $deskpiv1 2&>/dev/null 
sudo rm -f /usr/bin/safecutoffpower* 2&>/dev/null
sudo rm -rf /etc/modules-load.d/raspberry.conf 2&>/dev/null
echo "Uninstall DeskPi V1 Driver Successfully." 

