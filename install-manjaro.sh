#!/bin/bash
# 
. /lib/lsb/init-functions

daemonname="deskpi_v4-safecutoffpower.service"
safecutoffpowerdaemonfile=/lib/systemd/system/$daemonname
installationfolder=/home/$USER/deskpi_v4

# delete deskpi_v4-safecutoffpower.service file.
if [ -e $safecutoffpowerdaemonfile ]; then
	sudo sh -c "rm -f $safecutoffpowerdaemonfile"
fi

# adding dtoverlay to enable dwc2 on host mode.
sudo sh -c "sed -i '/dtoverlay=dwc2*/d' /boot/config.txt"
sudo sh -c "sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/config.txt" 
sudo sh -c "echo dwc2 > /etc/modules-load.d/raspberry.conf" 

log_action_msg "DeskPi V4 Driver installation Start..."
cd $installationfolder/drivers/c/ 
sudo sh -c "cp -rf $installationfolder/drivers/c/safecutoffpower /usr/bin/safecutoffpower"
sudo sh -c "chmod 755 /usr/bin/safecutoffpower"
sudo cp -rf $installationfolder/Deskpi-uninstall /usr/bin/Deskpi-uninstall
sudo sh -c "chmod 755 /usr/bin/Deskpi-uninstall"

# send cut off power signal to MCU before system shuting down.
echo "[Unit]" > $safecutoffpowerdaemonfile
echo "Description=DeskPi V4  Safe Cut-off Power Service" >> $safecutoffpowerdaemonfile
echo "Conflicts=reboot.target" >> $safecutoffpowerdaemonfile
echo "Before=halt.target shutdown.target poweroff.target" >> $safecutoffpowerdaemonfile
echo "DefaultDependencies=no" >> $safecutoffpowerdaemonfile
echo "[Service]" >> $safecutoffpowerdaemonfile
echo "Type=oneshot" >> $safecutoffpowerdaemonfile
echo "ExecStart=/usr/bin/sudo /usr/bin/safecutoffpower" >> $safecutoffpowerdaemonfile
echo "RemainAfterExit=yes" >> $safecutoffpowerdaemonfile
echo "[Install]" >> $safecutoffpowerdaemonfile
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $safecutoffpowerdaemonfile

log_action_msg "DeskPi V4 Service configuration finished." 
sudo chown root:root $safecutoffpowerdaemonfile
sudo chmod 755 $safecutoffpowerdaemonfile

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
