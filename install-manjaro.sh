#!/bin/bash
# 
echo "DeskPi V1 Driver Installing..."
if [ -d /tmp/deskpi_v1 ]; then
	sudo rm -rf /tmp/deskpi_v1 2&>/dev/null
fi
echo "Download the latest DeskPi V1 Driver from GitHub..."
cd /tmp && git clone https://github.com/DeskPi-Team/deskpi_v1.git 

echo "DeskPi V1 Driver Installation Start."
deskpiv1=/lib/systemd/system/systemd-deskpiv1-safecutoffpower.service
driverfolder=/tmp/deskpi_v1

# delete deskpi_v1-safecutoffpower.service file.
if [ -e $deskpiv1 ]; then
	sudo sh -c "rm -f $deskpiv1"
fi

# adding dtoverlay to enable dwc2 on host mode.
echo "Configure /boot/config.txt file and enable front USB2.0"
sudo sed -i '/dtoverlay=dwc2*/d' /boot/config.txt
sudo sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/config.txt 
sudo sh -c "echo dwc2 > /etc/modules-load.d/raspberry.conf" 

sudo cp -rf $driverfolder/drivers/c/safecutoffpower64 /usr/bin/safecutoffpower64
sudo cp -rf $driverfolder/drivers/python/safecutoffpower.py /usr/bin/safecutoffpower.py
sudo chmod 644 /usr/bin/safecutoffpower64
sudo chmod 644 /usr/bin/safecutoffpower.py

# send cut off power signal to MCU before system shuting down.
sudo echo "[Unit]" > $deskpiv1
sudo echo "Description=DeskPi V1 Safe Cut-off Power Service" >> $deskpiv1
sudo echo "Conflicts=reboot.target" >> $deskpiv1
sudo echo "DefaultDependencies=no" >> $deskpiv1
sudo echo "" >> $deskpiv1
sudo echo "[Service]" >> $deskpiv1
sudo echo "Type=oneshot" >> $deskpiv1
sudo echo "ExecStart=/usr/bin/sudo /usr/bin/safecutoffpower64" >> $deskpiv1
sudo echo "# ExecStart=/usr/bin/sudo python3 /usr/bin/safecutoffpower.py" >> $deskpiv1
sudo echo "RemainAfterExit=yes" >> $deskpiv1
sudo echo "TimeoutStartSec=15" >> $deskpiv1
sudo echo "" >> $deskpiv1
sudo echo "[Install]" >> $deskpiv1
sudo echo "WantedBy=halt.target shutdown.target poweroff.target final.target" >> $deskpiv1

sudo chown root:root $deskpiv1
sudo chmod 644 $deskpiv1

sudo systemctl daemon-reload
sudo systemctl enable systemd-deskpiv1-safecutoffpower.service
# install rpi.gpio for fan control
yes |sudo pacman -S python-pip
sudo pip3 install pyserial
# sudo pacman -S python python-pip base-devel
# env CFLAGS="-fcommon" pip install rpi.gpio

sync
sudo rm -rf /tmp/deskpi_v1
echo "DeskPi V1 Driver installation successful, system will reboot in 5 seconds to take effect!"
sleep 5 && sudo reboot
