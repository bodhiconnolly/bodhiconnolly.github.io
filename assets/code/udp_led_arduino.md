---
layout: page
title: Arduino UDP LED Code
permalink: /assets/code/udp_led_arduino/
published: true
#image: /assets/article_images/about/hiking_tasmania_large3.jpg
---
<br>
<a href="{{site.baseurl}}/arduino/iphone/led/2014/08/30/iphone-rgb-leds.html">Related project.</a>
{% highlight c++ %}
#include <SPI.h>         
#include <Ethernet.h>
#include <EthernetUdp.h>        

#define SET 0
#define READ 1
#define IO 2
#define MSG 3
#define FUNC 4

#define RED 5
#define GREEN 6
#define BLUE 3

int ledSwitch = HIGH;
int pwmPins[] = { 3, 5, 6, 9, 10, 11 };
int digInPins[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

String reply="";

int r = 0;
int g = 0;
int b = 0;


//network information
byte mac[] = {0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA };
IPAddress ip(10, 1, 1, 177);
unsigned int localPort = 6400;      // local port to listen on

// buffers for receiving and sending data
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet,
char  ReplyBuffer[] = "acknowledged";       // a string to send back to sender

// An EthernetUDP instance to let us send and receive packets over UDP
EthernetUDP Udp;

void setup() {
	// start the Ethernet and UDP:
	Ethernet.begin(mac, ip);
	Udp.begin(localPort);
	//all digital pins output
	for (int i = 0; i < 14; i++){
		pinMode(i, OUTPUT);
	}
	Serial.begin(9600);
}

void loop() {
	// if there's data available, read a packet
	int packetSize = Udp.parsePacket();
	if (packetSize)
	{
		Serial.print(", port ");
		Serial.println(Udp.remotePort());

		// read the packet into packetBufffer
		Udp.read(packetBuffer, UDP_TX_PACKET_MAX_SIZE);

		//parsing
		String datagram = String(packetBuffer);
		int prev_index = 0;
		int curr_index = 0;
		String tempCommands[10];
		int i = 0;
		//splitting on ';'
		while (prev_index < (datagram.length()-1))
		{
			curr_index = datagram.indexOf(';',prev_index+1)+1;
			tempCommands[i] = datagram.substring(prev_index, curr_index);
			prev_index = curr_index;
			i += 1;
		}
		String commands[i - 1];
		for (int n = 0; n < i; n++)
		{
			commands[n] = tempCommands[n];
		}
		switch ((commands[0]).toInt()){
		case SET:
			//DIGITAL COMMAND
			if (commands[1].charAt(0) == 'd'){
				int dPort = (commands[1].substring(1)).toInt();
				int dSet = constrain((commands[2]).toInt(),0,1);
				if ((dPort >= 0) && (dPort < 14)){
					digitalWrite(dPort, dSet);
					reply = "Digital Port " + String(dPort) + " set to " + String(dSet); 
					Serial.println(reply);
				}
				else {
					reply = "Digital Port " + String(dPort) + " is not a valid digital port";
					Serial.println(reply);
				}
			}
			//PWM COMMAND
			else if (commands[1].charAt(0) == 'p'){
				int pPort = (commands[1].substring(1)).toInt();
				int pSet = constrain((commands[2]).toInt(), 0, 255);
				int isPWM = 0;
				for (int i = 0; i < sizeof(pwmPins); i++)
				{
					if (pPort == pwmPins[i]){
						isPWM = 1;
						break;
					}
				}
				if (isPWM){
					analogWrite(pPort, pSet);
					reply = "Digital Port " + String(pPort) + " PWMed.";
					Serial.print(reply);
				}
				else {
					reply = "Digital Port " + String(pPort) + " is not a valid PWM port.";
					Serial.print(reply);
				}
				if (pPort == RED){
					r = pSet;
				}
				if (pPort == GREEN){
					g = pSet;
				}
				if (pPort == BLUE){
					b = pSet;
				}

			}
			else{
				reply = "Invalid SET command: " + String(commands[1]);
				Serial.println(reply);
			}
			break;
		case READ:
			//DIGITAL READ
			if (commands[1].charAt(0) == 'd'){
				int dPort = (commands[1].substring(1)).toInt();
				if ((dPort >= 0) && (dPort < 14)){
					int dRead = digitalRead(dPort);
					Serial.print("Digital Port ");
					Serial.print(dPort);
					Serial.print(" reads: ");
					Serial.println(dRead);
				}
				else {
					Serial.print("Port ");
					Serial.print(dPort);
					Serial.println(" is not a valid digital port.");
				}
			}
			if (commands[1].charAt(0) == 'a'){
				int aPort = (commands[1].substring(1)).toInt();
				if ((aPort >= 0) && (aPort < 6)){
					int aRead = analogRead(aPort);
					Serial.print("Analog Port ");
					Serial.print(aPort);
					Serial.print(" reads: ");
					Serial.println(aRead);
				}
				else {
					Serial.print("Port ");
					Serial.print(aPort);
					Serial.println(" is not a valid analog port.");
				}

			}
			break;
		case IO:
			break;
		case MSG:
			break;
		case FUNC:
			break;
		default:
			Serial.print("Invalid initial command: ");
			Serial.println(commands[0]);
		}
		//send a reply, to the IP address and port that sent us the packet we received
		char replyArray[200];
		reply.toCharArray(replyArray, 200);
		Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
		Udp.write(replyArray);
		Udp.endPacket();
	}	
}

{% endhighlight %}

[jekyll]:      http://jekyllrb.com
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-help]: https://github.com/jekyll/jekyll-help
