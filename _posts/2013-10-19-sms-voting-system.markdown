---
layout: post
title:  "DIY SMS Voting System"
date:   2013-10-24 14:34:25
categories: diy
tags: 
image: /assets/article_images/2013-10-24-shindig-2013/shindig-2014.jpg
published: true
---

These days SMS voting services are a dime a dozen, and they're generally pretty cheap. The downside of using such a service is lack of flexibility, long voting strings and the fact that they're no fun. 

This is the second year we attempted to roll our own voting system for the Shindig Short Film Festival. Last year the setup involved a jailbroken iPhone that forwarded its incoming text messages via email, a Python script that harvested those emails and entered the votes into a database, and a php/ajax webpage that graphed the voting distribution in realtime. While this worked, it was a rather 'hacky' solution, and on the night the phone ground to a halt when it received over 400 messages within about a minute. 

![Rolling our own service meant the users could vote with the numbers 1 to 13, as opposed to strings such as 100033 you get with cheap commercial services.]({{site.baseurl}}"/assets/images/usb_dongle.jpg")

This year we wanted to create something a little more polished. The main improvement was offloading the processing onto a computer rather than the underpowered phone. I had a spare 3G Telstra USB dongle which had been replaced with an LTE model, which can technically send and receive texts despite not being made for this purpose. Since we only needed to receive texts we didn't even need any credit, so a $2 prepaid sim was the only cost. It had to be Telstra because the dongle was locked.

![The GSM modem at the heart of the operation]({{site.baseurl}}"/assets/images/usb_dongle.jpg")

The project hinged on SMS Server Tools 3 - a piece of software that acted as a gateway from the modem to the computer. It harvests the incoming messages and stores them as text files with metadata such as timestamp and from address. It is designed for unix-based operating systems but can be run on Windows with cygwin. Our dongle wasn't on the list of supported devices but the software uses standard AT commands so works with most devices. Ours worked without issue. 

Once these text files are sitting in the right folder a bash script enters the numbers into the database. Additionally, we added a check to stop the same phone voting twice, and recorded all attempts to do so.  

The php/ajax poll was the same as we used last year, and is only slightly modified from an online example. No need to reinvent the wheel here. 

![The final results]({{site.baseurl}}"/assets/images/votes.jpg")

We did some tests to check for congestion, which just involved getting 20 or so friends to simultaneously text the device. It held up to the tests, and it held up on the night as well. At one point there was about 30 seconds between voting and seeing the poll update, but all the votes came through in about five minutes, which we were really pleased with. The whole thing went about as smoothly as could have been expected. 