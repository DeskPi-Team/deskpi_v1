#!/bin/bash
# 
. /lib/lsb/init-functions
sudo apt-get update && sudo apt-get -y install git 

TEMP=/tmp

cd $TEMP/ && git clone https://github.com/DeskPi-Team/deskpi_v1 
if [[ $? -ne 0 ]]; then
	echo "Error: Can not download deskpi_v1 repository, please try again!"
fi

deskpi_daemon=deskpilite
deskpi_lite_svc=/lib/systemd/system/$deskpi_daemon.service

# remove old service file
if [ -e $deskpi_lite_svc ]; then
	sudo rm -f $deskpi_lite_svc
fi

# adding dtoverlay to enable dwc2 on host mode.
log_action_msg "Enable dwc2 on Host Mode"
sudo sed -i '/dtoverlay=dwc2*/d' /boot/firmware/config.txt 
sudo sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/firmware/config.txt 
if [ $? -eq 0 ]; then
   log_action_msg "dwc2 has been setting up successfully"
fi

# install safe cut off power daemon.
log_action_msg "DeskPi lite safe shutdown service"

# copy python script to /usr/bin/
cp -f $TEMP/deskpi_v1/drivers/python/safe_shutdown.py /usr/bin/
cp -f $TEMP/deskpi_v1/drivers/python/fan_control.py /usr/bin/
cp -f $TEMP/deskpi_v1/drivers/python/safecutoffpower.py /usr/bin/

# send signal to MCU before system shuting down.
echo "[Unit]" > $deskpi_lite_svc
echo "Description=DeskPi Lite Service" >> $deskpi_lite_svc
echo "Conflicts=reboot.target" >> $deskpi_lite_svc
echo "Before=halt.target shutdown.target poweroff.target" >> $deskpi_lite_svc
echo "DefaultDependencies=no" >> $deskpi_lite_svc
echo "StartLimitIntervalSec=60" >> $deskpi_lite_svc
echo "StartLimitBurst=5" >> $deskpi_lite_svc


echo "[Service]" >> $deskpi_lite_svc
echo "RootDirectory=/" >> $deskpi_lite_svc
echo "User=root" >> $deskpi_lite_svc
echo "Type=simple" >> $deskpi_lite_svc
echo "ExecStart=sudo /usr/bin/python3 /usr/bin/safe_shutdown.py &" >> $deskpi_lite_svc
echo "RemainAfterExit=yes" >> $deskpi_lite_svc
echo "Restart=on-failure" >> $deskpi_lite_svc
echo "RestartSec=30" >> $deskpi_lite_svc

echo "[Install]" >> $deskpi_lite_svc
echo "WantedBy=multi-user.target" >> $deskpi_lite_svc

log_action_msg "DeskPi Lite Safe Shutdown Service configuration finished." 
sudo chown root:root $deskpi_lite_svc
sudo chmod 644 $deskpi_lite_svc

log_action_msg "DeskPi Lite Service Load module." 
sudo systemctl daemon-reload
sudo systemctl enable $deskpi_daemon.service
sudo systemctl restartt $deskpi_daemon.service

# Finished 
log_success_msg "DeskPi Lite Driver installation finished successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sudo sync
sleep 5 
sudo reboot
