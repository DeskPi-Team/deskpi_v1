# deskpi_v1
## Description 
The DeskPin V1 Case is a case made of ABS, and an adapter board is provided inside to transfer the HDMI interface, 3.5mm audio interface, and USB-C power interface of the Raspberry Pi to the back of the panel.
and offer `microHDMI` to `Full-sized HDMI` interface, makes it convenient for users to use standard HDMI cables to connect external display devices. 
In addition, it provides an ultra-thin aluminum alloy heat sink and supports an adjustable-speed ultra-thin silent fan, which can be safely cut off Power supply for Raspberry Pi  by sending a "power_off" signal to the adapter board.
## Features
* Convert the `microHDMI` to a `Full-sized HDMI` interface and place it on the back of the panel with the power interface
* Transfer `3.5mm audio` interface to the back of the panel
* Support Raspberry Pi official `fan temperature control function` via `raspi-config` tool.
* Support system shutdown to `safe cut off power` on Raspberry Pi 
* Support adjustable fan speed via `PWM` programming.
* Easy to install 
* Light weight heat-sink inside.
* Adjustable speed Fan
## Product Links: https://deskpi.com
## How to install it.
### For Raspbian and RetroPie OS.
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
chmod +x install.sh
sudo ./install.sh
```
### For Ubuntu-mate OS
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
chmod +x install-ubuntu-mate.sh
sudo ./install-ubuntu-mate.sh
```
### For Manjaro OS
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
chmod +x install-manjaro.sh
sudo ./install-manjaro.sh
```
### For Kali-linux-arm OS.
* Image Download URL: https://images.kali.org/arm-images/kali-linux-2020.3a-rpi3-nexmon.img.xz <br>
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
chmod +x install-kali.sh
sudo ./install-kali.sh
```
### For Twister OS v2.0.2
`OS image: TwisterOSv2-0-2.img`
* Image Download URL:https://twisteros.com/twisteros.html <br>
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
chmod +x install.sh
sudo ./install.sh
```
### For 64 bit Raspberry Pi OS (aarm64)
* Image Download URL: http://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2021-05-28/
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
chmod +x install.sh
sudo ./install.sh
```
### For DietPi OS 64bit 
* Make sure your OS can access internet and please install `git` first.
* Execute this command in terminal:
```
apt-get update && apt-get -y install git 
```
* Image Download URL:  https://dietpi.com/downloads/images/DietPi_RPi-ARMv8-Buster.7z
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd ~/deskpi_v1/
./install.sh
```
### For Volumio OS Version: 2021-04-24-Pi
<pre>NOTE: Due to OS did not support gpio control so can not control fan via PWM signal, so the fan will be at 100% speed spinning.</pre> 
* Image Download URL: https://updates.volumio.org/pi/volumio/2.882/volumio-2.882-2021-04-24-pi.img.zip
* Getting Start:　https://volumio.github.io/docs/User_Manual/Quick_Start_Guide.html
* Make sure your Volumio can access internet. 
* There are some steps need to do.
```
sudo nano /etc/network/interface
```
make sure following parameters in file `/etc/network/interface` 
```
auto wlan0 
allow-hotplug wlan0 
iface wlan0 inet dhcp
wpa-ssid "YOUR WIFI SSID"
wpa-psk "YOUR WIFI PASSWORD"
```
and enable the internet access by typing this command in terminal:
```
volumio internet on
```
and then reboot your DeskPi.
```
sudo reboot
```
* Download DeskPi driver from github:
```
git clone https://github.com/DeskPi-Team/deskpi_v1.git
cd deskpi_v1/
sudo ./install.sh
```
## How to Uninstall deskpi
```bash
DeskPi-uninstall 
```
And then select the number against to your OS Type. if your OS does `not` in the list, just select `raspberry pi os`instead. 
### For Windows IoT OS
* Unsupported due to lacking of driver.
* Testing version: Midnight falcon
## How to enable fan temperature control? 
<pre> NOTE: Raspberry Pi OS (Latest) will support this function.</pre>
* Open a terminal and typing following command:
```
sudo raspi-config 
```
Navigate to `Performance Options` -> `P4 Fan` -> `Yes` -> `14` -> `60` -> `yes` -> `finish` -> reboot Raspberry Pi.
The fan is support `PWM` signal control via `GPIO14` which is `physical pin 12`(TXD), it will spinning when the CPU temperature is above `60` degree.
and also you can write your code to control the fan via `GPIO14`, sending `PWM` signal will trigger the fan spinning.
## How to enable the USB2.0 in front of panel?
* 1. Install DeskPi v1 driver.
* 2. Add following parameter to /boot/config.txt file manually.
```
dtoverlay=dwc2,dr_mode=host
```
<pre>DO REMEMBER `reboot` Raspberry Pi to take effect.</pre>
## How to send `power_off` signal to adapter board to cut off power?
* Make sure you have already add `dtoverlay=dwc2,dr_mode=host` to `/boot/config.txt` file and `reboot` Raspberry Pi.
* Check if there is a device called `/dev/ttyUSB0`
* Execute the python demo script in `deskpi_v1/drivers/python/safecutoffpower.py` 
* you may need to install `pyserial` library.
* Recommend: adding this function after `shutdown` service, so that it can safely cut off the power of Raspberry Pi.  
