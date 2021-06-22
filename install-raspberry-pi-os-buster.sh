#!/bin/bash
# 
. /lib/lsb/init-functions
sudo apt-get update && sudo apt-get -y install git 
if [ $? -eq 0 ]; then 
	log_action_msg "Download DeskPi V4 Driver from Github"
	cd ~
	sh -c "git clone https://github.com/DeskPi-Team/deskpi_v4.git"
fi

cd $HOME/deskpi_v4/
daemonname="deskpi_v4"
safecutoffpower=/lib/systemd/system/$daemonname-safecutoffpower.service
installationfolder=$HOME/$daemonname

# Create service file on system.
if [ -e $deskpidaemon ]; then
	sudo rm -f $deskpidaemon
fi

# adding dtoverlay to enable dwc2 on host mode.
log_action_msg "Enable dwc2 on Host Mode"
sudo sed -i '/dtoverlay=dwc2*/d' /boot/config.txt 
sudo sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/config.txt 
if [ $? -eq 0 ]; then
   log_action_msg "dwc2 has been setting up successfully"
fi

# install safe cut off power daemon.
log_action_msg "DeskPi v4 safe-cut-off-power after system halt daemon"
cd $installationfolder/drivers/c/ 
sudo cp -rf $installationfolder/drivers/c/safecutoffpower /usr/bin/safecutoffpower
sudo chmod 755 /usr/bin/safecutoffpower
sudo cp -rf $installationfolder/Deskpi-uninstall /usr/bin/Deskpi-uninstall
sudo chmod 755 /usr/bin/Deskpi-uninstall

# send signal to MCU before system shuting down.
echo "[Unit]" > $safecutoffpower
echo "Description=DeskPi v4 Safe Cut-off Power Service" >> $safecutoffpower
echo "Conflicts=reboot.target" >> $safecutoffpower
echo "Before=halt.target shutdown.target poweroff.target" >> $safecutoffpower
echo "DefaultDependencies=no" >> $safecutoffpower
echo "[Service]" >> $safecutoffpower
echo "Type=oneshot" >> $safecutoffpower
echo "ExecStart=/usr/bin/sudo /usr/bin/safecutoffpower" >> $safecutoffpower
echo "RemainAfterExit=yes" >> $safecutoffpower
echo "TimeoutSec=1" >> $safecutoffpower
echo "[Install]" >> $safecutoffpower
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $safecutoffpower

log_action_msg "DeskPi V4 Service configuration finished." 
sudo chown root:root $safecutoffpower
sudo chmod 644 $safecutoffpower

log_action_msg "DeskPi V4 Service Load module." 
sudo systemctl daemon-reload
sudo systemctl enable $daemonname-safecutoffpower.service

# Finished 
log_success_msg "DeskPi V4 Driver installation finished successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sudo sync
sleep 5 
sudo reboot
