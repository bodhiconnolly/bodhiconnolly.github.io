---
layout: post
title: Drone Bait System
date: 2016-07-10
categories: drone
tags: null
image: "/assets/article_images/2016-07-10-drone-bait/bait_header.jpg"
published: true
---

Wild dogs are a massive problem for farmers in Queensland. In the short to medium term future, drones will be employed to tackle this issue. We took a small step towards this solution with an MVP drone baiting system.

<iframe width="560" height="315" src="https://www.youtube.com/embed/jzd53KtTC0g" frameborder="0" allowfullscreen></iframe>
<br>
Currently farmers use a few strategies to mitigate the issue: dropping bait from helicopters, setting bait on the ground, and walking around with a rifle. None of these are very effective. Placing bait from the ground is slow and untargeted, dropping bait from the air is fast but untargeted, and shooting the dogs is very targeted but isn't at all scalable. Indiscriminately baiting is more likely to effect the native goanna populations than the dogs.

The solution to this problem needs to be targeted and scalable. And it needs drones.

# The Promised Land

I envisage the ideal solution as:

* a fleet of infrared camera equipped drones that autonomously survey the property 24x7
* these drones use onboard image processing to scan the infrared images for a heat signature that matches a wild dog (computer vision, neural nets, etc)
* if a dog is found, the drones send a signal back to base which activates a bait drone
* this drone automatically flies to the dog's location and drops the targeted bait


Almost everything already  exists for this solution. Infrared is still very costly and you would need non-existent data to train the computer vision model, but autonomous battery replacements mean that 24x7 operation is feasible. Onboard processing has just hit the point where autonomous flight (including obstacle detection) could run in conjunction with the image recognition algorithms. Disregarding any local regulations, this is something that you would start building today.

However, we're not in the position to commit to all of that quite yet, so instead we used our week-long uni break to test the premise of dropping targeted bait from a drone. 

# The Build

The only bird we had with enough payload to drop the bait was the DJI Phantom 3. A great craft but not built for tinkering, so we really had to hack together the solution. 

![The 'basket']({{site.baseurl}}/assets/images/phantom_basket.jpg)

In order to maximise flexibility we made a basket to carry the payload in. In flight this is not as secure as a snug, specialised carrier, but this can carry just about anything, which is good when you're working fast. It is attached to the phantom by strong wire, with three points of contact to prevent rotation. Two connections are zip-tied at the base to act as a free pivot once the third is released. 

![The release mechanism]({{site.baseurl}}/assets/images/phantom_release.jpg)

One side of the basket is attached to [this release mechanism](http://www.e-fliterc.com/Products/Default.aspx?ProdID=EFLA405). Designed to drop bombs from model aircraft, it has just enough power to drop heavier payloads. 

![The complete basket]({{site.baseurl}}/assets/images/phantom_ball.jpg)

The release simply acts as a servo, and can be controlled with a standard receiver. Our receiver had eight channels so may have been a little overkill, but got the job done.  

![The receiver on the phantom]({{site.baseurl}}/assets/images/phantom_rx.jpg)
![Everything was velcroed for easy removal]({{site.baseurl}}/assets/images/phantom_velcro.jpg)

When everything was put together, it worked flawlessly. We did have to go through a few minor design changes while building though, such as the zip-tie pivots. 

![Flying with it all together]({{site.baseurl}}/assets/images/phantom_bait.jpg)

Stability while flying was another story. Obviously the weight distribution was very off, and the phantom drifted consistently in GPS mode. This would be the advantage of a more open system, where you could probably tune the PID values to fix this. We just had to fly carefully.

<iframe width="560" height="315" src="https://www.youtube.com/embed/WZoIcsTDYS4" frameborder="0" allowfullscreen></iframe>


# The Test

As it isn't the season for dogs right now, finding a wild dog is very difficult. Instead, we simulated the task by putting out a domestic dog in a location unknown to the pilots and letting them find it. We ran fairly hard into the main problem with non infrared imagery - occlusion - however when the dog was put in the open it was able to be found from the air. 

We then successfully dropped the payload (non-poisoned meat) which the dog happily ate. 