# FAQ 
## The front panel USB is unavailable.
* Because there is no configuration: /boot/config.txt file, you need to add in this configuration file: dtoverlay=dwc2,dr_mode=host, and restart the Raspberry Pi. and if you installed deskPi driver, it will add to config.txt file automatically. 

## How to install deskpi fan control driver when i've reflashed my TF card? 
* Make sure your OS is on the support OS list.
* Make sure your Raspberry Pi can access internet.
* git clone https://github.com/DeskPi-Team/deskpi_v4.git
* Typing following command in a terminal:
```bash
cd ~/deskpi_v4/
chmod +x install.sh
sudo ./install.sh
```
## Where is the list of supported OS ?
* Please just visit here: https://github.com/DeskPi-Team/deskpi_v4
