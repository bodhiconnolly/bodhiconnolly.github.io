---
layout: page
title: Python UDP LED Code
permalink: /assets/code/udp_led_python/
published: true
#image: /assets/article_images/about/hiking_tasmania_large3.jpg
---
<br>
<a href="{{site.baseurl}}/arduino/iphone/led/2014/08/30/iphone-rgb-leds.html">Related project.</a>
{% highlight python %}
import socket
from time import sleep
import threading
import datetime
import contextlib

#### CONSTANTS ####

waitTime=datetime.timedelta(milliseconds=50)
L_UDP_IP = "10.1.1.177"
UDP_PORT1 = 6400
UDP_PORT2 = 6401
RED=5
GREEN=6
BLUE=3


#### UDP FUNCTIONS ####

def sendMessage(message):
    with contextlib.closing(socket.socket(socket.AF_INET, socket.SOCK_DGRAM)) as sock1:
        sock1.sendto(message, (L_UDP_IP, UDP_PORT1))
    print message + " to " +L_UDP_IP

def checkMessage():
    print "checkMessage"
    with contextlib.closing(socket.socket(socket.AF_INET, socket.SOCK_DGRAM)) as sock2:
        sock2.bind(("",UDP_PORT2))
        data, addr = sock2.recvfrom(1024)
    return data

#### THREAD FUNCTIONS ####

class StoppableThread(threading.Thread):
    def __init__(self):
        super(StoppableThread, self).__init__()
        self._stop = threading.Event()
        #print "Thread Started"

    def stop(self):
        self._stop.set()

class FadeThread(StoppableThread):
    def __init__(self,fadeSpeed):
        super(FadeThread, self).__init__()
        self.fadeSpeed=fadeSpeed
        
    def run(self):
         sendMessage("0;p{0};{1};".format(BLUE,255))
         sleep(0.05)
         sendMessage("0;p{0};{1};".format(RED,0))
         sleep(0.05)
         sendMessage("0;p{0};{1};".format(GREEN,0))
         while not self._stop.isSet():
             self.fade(self.fadeSpeed)

    def fade(self,fadespeed):
        lastTime=datetime.datetime.now()
        for i in range(0,256,1):
            if not self._stop.isSet():
                if datetime.datetime.now()-lastTime>waitTime:
                    sendMessage("0;p{0};{1};".format(RED,i))
                    lastTime=datetime.datetime.now()
                sleep(fadespeed)
            else:
                break
        for i in range(255,-1,-1):
            if not self._stop.isSet():
                if datetime.datetime.now()-lastTime>waitTime:
                    sendMessage("0;p{0};{1};".format(BLUE,i))
                    lastTime=datetime.datetime.now()
                sleep(fadespeed)
            else:
                break
        for i in range(0,256,1):
            if not self._stop.isSet():
                if datetime.datetime.now()-lastTime>waitTime:
                    sendMessage("0;p{0};{1};".format(GREEN,i))
                    lastTime=datetime.datetime.now()
                sleep(fadespeed)
            else:
                break
        for i in range(255,-1,-1):
            if not self._stop.isSet():
                if datetime.datetime.now()-lastTime>waitTime:
                    sendMessage("0;p{0};{1};".format(RED,i))
                    lastTime=datetime.datetime.now()
                sleep(fadespeed)
            else:
                break
        for i in range(0,256,1):
            if not self._stop.isSet():
                if datetime.datetime.now()-lastTime>waitTime:
                    sendMessage("0;p{0};{1};".format(BLUE,i))
                    lastTime=datetime.datetime.now()
                sleep(fadespeed)
            else:
                break
        for i in range(255,-1,-1):
            if not self._stop.isSet():
                if datetime.datetime.now()-lastTime>waitTime:
                    sendMessage("0;p{0};{1};".format(GREEN,i))
                    lastTime=datetime.datetime.now()
                sleep(fadespeed)
            else:
                break
            
    def setSpeed(fadeSpeed):
        self.fadeSpeed=fadeSpeed

             

class SleepThread(StoppableThread):
    def __init__(self,sleepTime):
        super(SleepThread, self).__init__()
        self.sleepTime=sleepTime
        
    def run(self):
        self.ledSleep(self.sleepTime)
             
    def ledSleep(self,sleepTime):
        sleepDelay=(sleepTime*60)/255
        for i in range(255,100,-1):
            if not self._stop.isSet():
                sendMessage("0;p{0};{1};".format(RED,i))
                sendMessage("0;p{0};{1};".format(GREEN,i))
                sendMessage("0;p{0};{1};".format(BLUE,i))
                sleep(sleepDelay*0.2)
            else:
                break
        for i in range(100,50,-1):
            if not self._stop.isSet():
                sendMessage("0;p{0};{1};".format(RED,i))
                sendMessage("0;p{0};{1};".format(GREEN,i))
                sendMessage("0;p{0};{1};".format(BLUE,i))
                sleep(sleepDelay*1)
            else:
                break
        for i in range(50,10,-1):
            if not self._stop.isSet():
                sendMessage("0;p{0};{1};".format(RED,i))
                sendMessage("0;p{0};{1};".format(GREEN,i))
                sendMessage("0;p{0};{1};".format(BLUE,i))
                sleep(sleepDelay*2)
            else:
                break
        for i in range(10,-1,-1):
            if not self._stop.isSet():
                sendMessage("0;p{0};{1};".format(RED,i))
                sendMessage("0;p{0};{1};".format(GREEN,i))
                sendMessage("0;p{0};{1};".format(BLUE,i))
                sleep(sleepDelay*10)
            else:
                break
            
#### CONTROLLING OBJECT ####
            
class ledFunctions(object):
    def __init__(self):
        self.fadeThread=FadeThread(1)
        self.sleepThread=SleepThread(1)

    def stopThreads(self):
        self.fadeThread.stop()
        self.sleepThread.stop()

    def udpLoop(self):
        keepGoing=True
        while keepGoing:
            datagram=checkMessage()
            components=datagram.split(';')
            print components
            if components[0]=='4':
                self.stopThreads()
                if components[1]=='sleep':
                    self.sleepThread=SleepThread(float(components[2]))
                    self.sleepThread.start()
                elif components[1]=='fade':
                    self.fadeThread=FadeThread(float(components[2]))
                    self.fadeThread.start()
                elif components[1]=='pause':
                    pass
                elif components[1]=='exit':
                    exit()
            

#### RUNTIME ####
                    
if __name__ == "__main__":
    l=ledFunctions()
    l.udpLoop()

{% endhighlight %}

[jekyll]:      http://jekyllrb.com
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-help]: https://github.com/jekyll/jekyll-help
