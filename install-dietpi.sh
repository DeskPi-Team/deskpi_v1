#!/bin/bash
# installation script for deskpi v1 on dietpi OS.

. /lib/lsb/init-functions

log_action_msg "Install dependency packages"
sudo apt-get update && sudo apt-get -y install git python3-pip python3-rpi.gpio 
pip3 install pyserial


daemonname="deskpi_v1"
safecutoffpower=/lib/systemd/system/$daemonname-safecutoffpower.service
installationfolder=/root/$daemonname

# Create service file on system.
if [ -e $safecutoffpower ]; then
	rm -f $safecutoffpower
fi

# adding dtoverlay to enable dwc2 on host mode.
log_action_msg "Enable dwc2 on Host Mode"
sed -i '/dtoverlay=dwc2*/d' /boot/config.txt 
sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/config.txt 
if [ $? -eq 0 ]; then
   log_action_msg "dwc2 has been setting up successfully"
fi

# install safe cut off power daemon.
log_action_msg "DeskPi v1 safe-cut-off-power after system halt daemon"
cd $installationfolder/drivers/c/ 
cp -rf $installationfolder/drivers/c/safecutoffpower64 /usr/bin/safecutoffpower64
chmod 755 /usr/bin/safecutoffpower64

# send signal to MCU before system shuting down.
echo "[Unit]" > $safecutoffpower
echo "Description=DeskPi v1 Safe Cut-off Power Service" >> $safecutoffpower
echo "Conflicts=reboot.target" >> $safecutoffpower
echo "Before=halt.target shutdown.target poweroff.target" >> $safecutoffpower
echo "DefaultDependencies=no" >> $safecutoffpower
echo "[Service]" >> $safecutoffpower
echo "Type=oneshot" >> $safecutoffpower
echo "ExecStart=/usr/bin/safecutoffpower64" >> $safecutoffpower
echo "RemainAfterExit=yes" >> $safecutoffpower
echo "TimeoutSec=1" >> $safecutoffpower
echo "[Install]" >> $safecutoffpower
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $safecutoffpower

log_action_msg "DeskPi V1 Service configuration finished." 
chown root:root $safecutoffpower
chmod 644 $safecutoffpower

log_action_msg "DeskPi V1 Service Load module." 
systemctl daemon-reload
systemctl enable $daemonname-safecutoffpower.service

# Finished 
log_success_msg "DeskPi V1 Driver installation finished successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sync
sleep 5 
reboot
