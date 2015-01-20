---
layout: post
title:  "Writing a Dropbox Powered Day One Python Client"
date:   2014-05-23 14:34:25
categories: coding python
tags: 
image: /assets/article_images/2014-05-23-day-one-python-client/python_code.jpg
published: true
---

One of my subjects this semester is CSSE1001: Introduction to Software Engineering. While for the most part it is a simple Python course, it offers an optional project to extend students and let them work on some code they are passionate about. 

I document my life extensively through the wonderful journalling app <a href="http://dayoneapp.com">Day One</a> however its desktop counterpart is OSX only. While I use OSX frequently, Windows 8 is currently my daily driver and I would really love if my journal entries were available to view, edit and add to there.

Luckily, Day One syncs to the OSX app via Dropbox, so I can easily download my entries on the PC. Upon inspection, the .doentry files are simply plist documents. With this information in hand, I decided to use my CSSE1001 project to develop a Python client for syncing with the app. 

The features of the app that I intended to emulate were:

- Create a useable GUI
- Sync entries with the Dropbox API
- View, edit and add entries
- View metadata attached to entries such as date, time, location, weather, and favourites
- Add location metadata via reverse geocoding and download local weather information
- Attach photos to the entries from file or from the webcam
- Include some user-changeable settings
- Work across all major platforms

#GUI

Python has a reputation for GUIs, and it isn't a good one. I've used the stock library, TKinter, enough to know that it was too simple for this application. The two suitable options I found were wxPython and PyQt. wxPython is a Python wrapper for the wx C++ widgets and provides native-looking interfaces across all platforms. PyQt is a Python wrapper for the C++ Qt framework, which too works on all major platforms. These two libraries seem pretty equivalent, with Qt edging ahead in the use of form builders but wx has the advantage of a more native-looking application. I tried a wx form builder and found that it was good enough so went ahead and chose wx.


While it started well, the documentation wasn't very good - often when you dug deep you'd end up looking at C++ calls and you'd almost have guess how to implement them in Python. But I don't think Qt would be any better in this regard. Once I got the hang of things working with the GUI was the least of my troubles and I was happy with how it turned out given my limited experience. Having native widgets turned out to be a big bonus when I demoed my code on OSX and Linux and it looked perfect. Well, as perfect as it looked on Windows. The OSX version looked the least like it was from the 90s. 

![The wx window on Windows]({{site.baseurl}}/assets/images/day_one_main.jpg)

#Dropbox Sync

Dropbox supplies a Python API, which works well and has good documentation. Thank god. They provide a nice way of managing what is and isn't locally downloaded. Each time you sync you get a 'cursor' which you can then use the next time you sync to tell Dropbox when you last synced. Dropbox then gives you a list of files that need downloading, which you can iterate over and use get_file(path) to download each file individually. When downloading multiple entries this was too slow, so I used the threading library to download multiple files at once. If more than eight files were downloading simultaneously I would sporadically get dropouts so I limited this to five at a time. 

The data objects were quite similar to a todo list app I had created previously so this saved time. I simply had to add more attributes for all the metadata and worry about the UUID filenames. The standard plistlib worked wonderfully at interpreting the .doentry files into Python dictionaries. 

#Controller

Getting the data objects to work with wx was surprisingly easy. I guess that's the benefit of having logically laid out data and view models. 

Now is probably a good time to note that I used the PyScripter IDE rather than IDLE and absolutely wouldn't go back. IDLE is ok for banging out a quick script but nothing more.

#Location and Weather

It was the extra features that really took time in this project, the non-core functions that I was integrating at the last minute. Location consists of a pop-up box where the user can type their location. This information is reverse geocoded using the Google Maps API (conveniently wrapped as pygeocoder). If the location is found the application downloads a static map of the location with a centered pin. Downloading and subsequently converting the image for display was difficult. 

Once a location is entered the application sends the coordinates to OpenWeatherMap which returns the weather data in JSON. Information such as the temperature and a text summary is displayed. 

![The location popup]({{site.baseurl}}/assets/images/day_one_location.jpg)

#Webcam

This was frustrating. I spent hours playing around with the popular OpenCV tools, an while I could get them to work in TKinter they would not play nice with wx. I experienced low frame rates and weird bugs where only a 10 by 10px section of the feed would update. In the end I decided to cut my losses and use the Win32 plugin VideoCapture. It worked perfectly on Windows, but not at all on anything else. And it looks horrible. If I have more time this will be the first omission I go back and rectify. 

![At least OSX and Linux users won't have to see this...]({{site.baseurl}}/assets/images/day_one_photo.jpg)

#Settings

While I did manage to migrate all the settings to a text file that is read at startup, there is no GUI for changing these. Simply no time, however would be dead simple to implement.

#Summary

This was the largest software project I have undertaken, coming in around 1200 lines of code. I wrote that in six days, and that was all I did for those six days other than eating and sleeping. It was an invaluable learning experience, and I am already seeing places where I could now go back and code them more efficiently. For those interested, the <a href="https://github.com/bodhiconnolly/python-day-one-client">code is on GitHub.</a>

![In the last thirty minutes I even made a splash screen]({{site.baseurl}}/assets/images/day_one_splash.png)

