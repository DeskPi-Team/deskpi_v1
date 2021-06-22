#!/bin/bash
# 
. /lib/lsb/init-functions

daemonname="deskpi_v4-safecutoffpower.service"
filelocation=/lib/systemd/system/$daemonname
installationfolder=/home/kali/deskpi_v4

if [ -e $filelocation ]; then
	sudo rm -f $filelocation
fi

# adding dtoverlay to enable dwc2 on host mode, enable front usb port.
sudo sed -i '/dtoverlay=dwc2*/d' /boot/config.txt 
sudo sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/config.txt 

log_action_msg "DeskPi v4 main control service loaded."
cd $installationfolder/drivers/c/ 
sudo cp -rf $installationfolder/drivers/c/safecutoffpower /usr/bin/safecutoffpower
sudo cp -rf $installationfolder/Deskpi-uninstall /usr/bin/Deskpi-uninstall
sudo chmod 755 /usr/bin/safecutoffpower
sudo chmod 755 /usr/bin/Deskpi-uninstall

# send cut off power  signal to MCU before system shuting down
echo "[Unit]" > $filelocation
echo "Description=DeskPi Safeshutdown Service" >> $filelocation
echo "Conflicts=reboot.target" >> $filelocation
echo "Before=halt.target shutdown.target poweroff.target" >> $filelocation
echo "DefaultDependencies=no" >> $filelocation
echo "[Service]" >> $filelocation
echo "Type=oneshot" >> $filelocation
echo "ExecStart=/usr/bin/sudo /usr/bin/safecutoffpower" >> $filelocation
echo "RemainAfterExit=yes" >> $filelocation
echo "[Install]" >> $filelocation
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $filelocation

log_action_msg "DeskPi V4 Service configuration finished." 
sudo chown root:root $filelocation
sudo chmod 755 $filelocation

log_action_msg "DeskPi V4 Service Load module." 
sudo systemctl daemon-reload
sudo systemctl enable $daemonname

# Finished 
log_success_msg "DeskPi V4 Driver installed successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sudo sync
sleep 5 
sudo reboot
