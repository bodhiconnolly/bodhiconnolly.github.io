---
layout: post
title:  "iPhone Controlled RGB LED Strip"
date:   2014-08-29 14:34:25
categories: arduino iphone led
tags: 
image: /assets/article_images/2014-08-29-welcome-to-jekyll/desktop.jpg
published: true
---
I have a fetish for flashing lights. LEDs in particular take my fancy, and with the constantly dropping price of LED strips I decided it was the perfect time to add some mood lighting to my bedroom. 

But using LED strips for mood lighting is nothing new, and not really that interesting. In order to spice this project up I decided I would make my iPhone wirelessly control the LEDs. Getting started with iOS development has long been on my todo list  so this was the perfect project to give it a go. 

There are three main choices of LEDs: single colour strips, multicolour RGB strips, and digitally addressable RGB strips. I wanted 5 meters for this project which put the digital strips out of the question due to price, and decided a single colour wouldn't be exciting enough, so ended up with some RGB lights.

I  ordered a starter kit which came with a 12V 6A power supply, a controller box, an IR remote, and of course the 5m roll. This cost a little over $30.  I plugged it all in and it worked fine, but of course having a little white box control your LEDs defeats the purpose of the project. SO I took apart the box, had a look inside, and then threw it out. 

To replace it I went straight for the Arduino Uno, my go to prototyping board. Connectivity-wise, my lights happen to be right next to my router so I could run an ethernet wire straight into my ethernet shield. I put a prototyping board on top where I placed my three MOSFETs (<a href="http://www.jaycar.com.au/productView.asp?ID=ZT2464&w=mosfet">Jaycar</a>)  as shown in the diagram below. <a href="https://learn.adafruit.com/rgb-led-strips/">Adafruit has a great tutorial on the wiring</a> so I won't go any more into that here. 

![LED wiring into the Uno courtesy of Adafruit]({{site.baseurl}}/assets/images/led_wiring.gif)

I decided I would use UDP messages to communicate to the Uno just for simplicity. I chose semicolon separated values in the form of [action];[pin];[value]. For example, action zero is set, so if I wanted to set digital pin 13 to HIGH I would send 0;d13;1. To pwm pin 6 in would use 0;p6;128. It works. 

<a href="{{site.baseurl}}/assets/code/udp_led_arduino">I've uploaded my code.</a> It works, but originally I was building a multifunctional UDP control so there are plenty of unnecessary elements in there for this project. I hope to continue work and eventually have an Arduino controlled completely with my phone.

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll’s dedicated Help repository][jekyll-help].

{% highlight js %}

<footer class="site-footer">
 <a class="subscribe" href="{{ "/feed.xml" | prepend: site.baseurl }}"> <span class="tooltip"> <i class="fa fa-rss"></i> Subscribe!</span></a>
  <div class="inner">a
   <section class="copyright">All content copyright <a href="mailto:{{ site.email}}">{{ site.name }}</a> &copy; 2014 &bull; All rights reserved.</section>
   <section class="poweredby">Made with <a href="http://jekyllrb.com"> Jekyll</a></section>
  </div>
</footer>
{% endhighlight %}


[jekyll]:      http://jekyllrb.com
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-help]: https://github.com/jekyll/jekyll-help
