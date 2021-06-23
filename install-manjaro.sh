#!/bin/bash
# 
echo "DeskPi V4 Driver Installing..."
if [ -d /tmp/deskpi_v4 ]; then
	sudo rm -rf /tmp/deskpi_v4 2&>/dev/null
fi
echo "Download the latest DeskPi V4 Driver from GitHub..."
cd /tmp && git clone https://github.com/DeskPi-Team/deskpi_v4.git 

echo "DeskPi V4 Driver Installation Start."
deskpiv4=/lib/systemd/system/systemd-deskpiv4-safecutoffpower.service
driverfolder=/tmp/deskpi_v4

# delete deskpi_v4-safecutoffpower.service file.
if [ -e $deskpiv4 ]; then
	sudo sh -c "rm -f $deskpiv4"
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
sudo echo "[Unit]" > $deskpiv4
sudo echo "Description=DeskPi V4 Safe Cut-off Power Service" >> $deskpiv4
sudo echo "Conflicts=reboot.target" >> $deskpiv4
sudo echo "DefaultDependencies=no" >> $deskpiv4
sudo echo "" >> $deskpiv4
sudo echo "[Service]" >> $deskpiv4
sudo echo "Type=oneshot" >> $deskpiv4
sudo echo "ExecStart=/usr/bin/sudo /usr/bin/safecutoffpower64" >> $deskpiv4
sudo echo "# ExecStart=/usr/bin/sudo python3 /usr/bin/safecutoffpower.py" >> $deskpiv4
sudo echo "RemainAfterExit=yes" >> $deskpiv4
sudo echo "TimeoutStartSec=15" >> $deskpiv4
sudo echo "" >> $deskpiv4
sudo echo "[Install]" >> $deskpiv4
sudo echo "WantedBy=halt.target shutdown.target poweroff.target final.target" >> $deskpiv4

sudo chown root:root $deskpiv4
sudo chmod 644 $deskpiv4

sudo systemctl daemon-reload
sudo systemctl enable systemd-deskpiv4-safecutoffpower.service
# install rpi.gpio for fan control
yes |sudo pacman -S python-pip
sudo pip3 install pyserial
# sudo pacman -S python python-pip base-devel
# env CFLAGS="-fcommon" pip install rpi.gpio

sync
sudo rm -rf /tmp/deskpi_v4
echo "DeskPi V4 Driver installation successful, system will reboot in 5 seconds to take effect!"
sleep 5 && sudo reboot
