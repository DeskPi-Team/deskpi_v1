#!/bin/bash
# 
. /lib/lsb/init-functions

daemonname="deskpi_v1"
safecutoffpower=/lib/systemd/system/$daemonname-safecutoffpower.service
# Thanks for muckypaws' help, solve the location problem.
installationfolder=/home/$SUDO_USER/deskpi_v1

# Create service file on system.
if [ -e $safecutoffpower ]; then
	sudo rm -f $safecutoffpower
fi

# adding dtoverlay to enable dwc2 on host mode.
sudo sed -i '/dtoverlay=dwc2*/d' /boot/firmware/config.txt 
sudo sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/firmware/config.txt 

# install PWM fan control daemon.
log_action_msg "DeskPi V1 Driver installation Start..."
cd $installationfolder/drivers/c/ 
sudo cp -rf $installationfolder/drivers/c/safecutoffpower /usr/bin/safecutoffpower
sudo chmod 755 /usr/bin/safecutoffpower
 
# send cut off power signal to MCU before system shuting down.
echo "[Unit]" > $safecutoffpower
echo "Description=DeskPi V1 Safe Cut-off Power Service" >> $safecutoffpower
echo "Conflicts=reboot.target" >> $safecutoffpower
echo "Before=halt.target shutdown.target poweroff.target" >> $safecutoffpower
echo "DefaultDependencies=no" >> $safecutoffpower
echo "[Service]" >> $safecutoffpower
echo "Type=oneshot" >> $safecutoffpower
echo "ExecStart=/usr/bin/sudo /usr/bin/fanStop" >> $safecutoffpower
echo "RemainAfterExit=yes" >> $safecutoffpower
echo "[Install]" >> $safecutoffpower
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $safecutoffpower

log_action_msg "DeskPi V1 Service configuration finished." 
sudo chown root:root $safecutoffpower
sudo chmod 755 $safecutoffpower

log_action_msg "DeskPi V1 Service Load module." 
sudo systemctl daemon-reload
sudo systemctl enable $daemonname-safecutoffpower.service

log_action_msg "System will reboot in 5 seconds to take effect." 
sudo sync
sleep 5 
sudo reboot
