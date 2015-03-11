---
layout: page
title: Connecting a Raspberry Pi to UQ Eduroam
permalink: /assets/code/raspberry_pi_eduroam/
published: true
#image: /assets/article_images/about/hiking_tasmania_large3.jpg
---
<br>
<a href="http://ceit.uq.edu.au/wiki/index.php/Connecting_to_Eduroam">Connecting to eduroam at the CEIT Wiki page.</a> This page is a backup in case the CEIT page moves in the future. Works with the University of Queensland eduroam implementation as of early 2015.


	Scraped together from various other Universities that provide instructions and Stephen Endicott's thesis. 
	Most importantly, does not require a monitor. 
	Assumes a working Wi-Fi adapter is installed. Current as of Summer 2014/15
	
	First, create/edit the wpa_supplicant.conf file:
		   sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
	
	Adding:
			network={
				  ssid=“eduroam”
				  scan_ssid=1
				  key_mgmt=WPA-EAP
				  eap=TTLS
				  phase2="auth=PAP”
				  identity=“sNumber@uq.edu.au”
				  password=“password"
		   }
	modified with your UQ logon details. 
	
	Ensure the wlan interface is setup correctly to use this file by modifying:
		sudo vi /etc/network/interfaces
	
	to match the following (in this example the interface is wlan0):
		#LOOPBACK INTERFACE
	   auto lo
	   iface lo inet loopback
	   #WIRELESS INTERFACE
	   auto wlan0
	   iface wlan0 inet manual
	   wireless-power off
	   wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
	   iface default inet dhcp
	   
	Restart networking with:
		sudo /etc/init.d/networking restart
		
	and the Pi should now automatically connect to eduroam!


[jekyll]:      http://jekyllrb.com
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-help]: https://github.com/jekyll/jekyll-help
