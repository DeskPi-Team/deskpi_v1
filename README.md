# deskpi_v4
DeskPi V4 
## Product Links: https://deskpi.com
## How to install it.
### For Raspbian and RetroPie OS.
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
chmod +x install.sh
sudo ./install.sh
```
### For Ubuntu-mate OS
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
chmod +x install-ubuntu-mate.sh
sudo ./install-ubuntu-mate.sh
```
### For Manjaro OS
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
chmod +x install-manjaro.sh
sudo ./install-manjaro.sh
```
### For Kali-linux-arm OS.
* Image Download URL: https://images.kali.org/arm-images/kali-linux-2020.3a-rpi3-nexmon.img.xz <br>
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
chmod +x install-kali.sh
sudo ./install-kali.sh
```
### For Twister OS v2.0.2
`OS image: TwisterOSv2-0-2.img`
* Image Download URL:https://twisteros.com/twisteros.html <br>
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
chmod +x install.sh
sudo ./install.sh
```
### For 64 bit Raspberry Pi OS (aarm64)
* Image Download URL: http://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2021-05-28/
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
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
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/
./install.sh
```
### For Volumio OS Version: 2021-04-24-Pi
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
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd deskpi_v4/
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
* 1. Install DeskPi v4 driver.
* 2. Add following parameter to /boot/config.txt file manually.
```
dtoverlay=dwc2,dr_mode=host
```
<pre>DO REMEMBER `reboot` Raspberry Pi to take effect.</pre>
