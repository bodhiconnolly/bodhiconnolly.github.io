---
layout: post
title:  "iPhone Controlled RGB LED Strip"
date:   2014-08-29 14:34:25
categories: arduino iphone led
tags: 
image: /assets/article_images/2014-06-17-iphone-rgb-leds/led_bedroom.jpg
published: true
---
I have a fetish for flashing lights. LEDs in particular take my fancy, and with the constantly dropping price of LED strips I decided it was the perfect time to add some mood lighting to my bedroom. 

But using LED strips for mood lighting is nothing new, and not really that interesting. In order to spice this project up I decided I would make my iPhone wirelessly control the LEDs. Getting started with iOS development has long been on my todo list  so this was the perfect project to give it a go. 

There are three main choices of LEDs: single colour strips, multicolour RGB strips, and digitally addressable RGB strips. I wanted 5 meters for this project which put the digital strips out of the question due to price, and decided a single colour wouldn't be exciting enough, so ended up with some RGB lights.

I  ordered a starter kit which came with a 12V 6A power supply, a controller box, an IR remote, and of course the 5m roll. This cost a little over $30.  I plugged it all in and it worked fine, but of course having a little white box control your LEDs defeats the purpose of the project. SO I took apart the box, had a look inside, and then threw it out. 

To replace it I went straight for the Arduino Uno, my go to prototyping board. Connectivity-wise, my lights happen to be right next to my router so I could run an ethernet wire straight into my ethernet shield. I put a prototyping board on top where I placed my three MOSFETs (<a href="http://www.jaycar.com.au/productView.asp?ID=ZT2464&w=mosfet">Jaycar</a>)  as shown in the diagram below. <a href="https://learn.adafruit.com/rgb-led-strips/">Adafruit has a great tutorial on the wiring</a> so I won't go any more into that here. 

![LED wiring into the Uno courtesy of Adafruit]({{site.baseurl}}/assets/images/led_wiring.gif)

I decided I would use UDP messages to communicate to the Uno just for simplicity. I chose semicolon separated values in the form of [action];[pin];[value]. For example, action zero is set, so if I wanted to set digital pin 13 to HIGH I would send 0;d13;1. To pwm pin 6 in would use 0;p6;128. Probably not the best way to do it but it works. 

<a href="{{site.baseurl}}/assets/code/udp_led_arduino/">I've uploaded my code.</a> It works, but originally I was building a multifunctional UDP control so there are plenty of unnecessary elements in the command parser for this project. I hope to continue work and eventually have an Arduino controlled completely with my phone.

For testing purposes I used a combination of a <a href="http://arduino.cc/en/Tutorial/UDPSendReceiveString">UDP Processing sketch</a> and a free iPhone app. I wanted the light to be controllable not just over the local network but over the internet. This is made difficult by the fact that when I'm living on campus I'm behind very restrictive firewalls. To do this, I installed custom router firmware <a href="">Gargoyle</a> and used its OpenVPN abilities to connect to a server I have access to in Brisbane. I can send messages to the server and have them forwarded to my router, where I can forward them to my Arduino. The whole thing takes under 30ms. Neat.

Once I was sure the Arduino was working fine, I borrowed a friend's iMac and started learning Objective C.

While the wiring and receiving code took me less than a day, writing the controller app took nearly a week. In that time I stepped through many simple tutorials from Apple until I thought I was ready to design a sender app that wasn't built horribly. I used a simple MVC structure with a singleton data class and some sliders that sent out a value between 0 and 255 ready to pwm the lights using AsyncUdpSocket. I'll probably upload the code sometime but it needs a bit of a tidy first. I found Obj-C difficult, but loved coding in Xcode. Really solid IDE. The only other alternative I looked at was Xamarin Studio which offers C# bindings for all of Apple's libraries, and apparently makes it simple to deploy your app across platforms. But I wanted to see what Obj-C was like so I'll have to explore Xamarin another day.

![Yeah... I'm not going to be winning a design award anytime soon.]({{site.baseurl}}/assets/images/led_iphone_app.png)

The final thing I wanted to do before I considered the project finished was create some preset moods. The stock controller had the ability to fade or jump through the colours, and so I decided to emulate those. Rather than try to deal with listening for a message and controlling a preset simultaneously on the Arduino I threw together a Python script which uses multiple threads deal with the problem. 

<a href="{{site.baseurl}}/assets/code/udp_led_python/">This code</a> runs on my always-on local computer, which is currently an old Dell box but will soon be a Raspberry Pi. Putting the presets in here allows me to easily scale them without worrying accessing the Arduino. New presets are simple to add by simply subclassing StoppableThread. I made another that slowly fades from full white to off for a gentle bedtime fade. Tip: sending too many messages too fast crashes the Arduino. I found that once every 50ms is a good compromise between smooth fades and never crashing the Arduino. Also, this just runs on the local network so no need to send everything to the server. 

This was quite an involved project and I learnt a lot about UDP communication, building simple iPhone apps and using multiple threads in Python. The main benefit is the mood lighting, it really makes my room more interesting and enjoyable to be in. 