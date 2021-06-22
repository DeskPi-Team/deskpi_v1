#How to Compile safecutoffpower binary file.
## C Language
* 1. At First, get the demo code from github.
```bash
cd ~
git clone https://github.com/DeskPi-Team/deskpi_v4.git
cd ~/deskpi_v4/drivers/c/
```
* 2. How to compile it.
```bash
make 
```
* 3. How to run it.
```bash
sudo ./safecutoffpower
```
* 4. How to clean the source code directory.
```bash
make clean
```
## How to enable fan temperature control? 
* Open a terminal and typing:
```
sudo raspi-config
```
navigate to `performance options` --> `P4 Fan` --> `14` --> `60` # 14 means GPIO14(TXD), 60 means 60 degree. 
--> `yes` and reboot Raspberry Pi.

# Python
## How to send cut-off-power signal to daughter board via serial port.
```Warnning```
* when you send "power_off" to "/dev/ttyUSB0" device, the power of Raspberry Pi will cut off by daughter board. 
### 1. Install pyserial library.
* Python2.x 
```
pip install pyserial 
```
* Python3.x
```
pip3 install pyserial
```
### 2. Execute it after `shutdown.target` on Raspberry Pi.
* If you want to test if it works properly, just execute it in terminal, it will cut off power immediately, recommend you add this script to `shutdown service`.
```
cd ~
cd ~/deskpi_v4/drivers/python/
sudo python3 safecutoffpower.py
```
### Job Done.

