CCTV using Raspberry Pi and Any Webcam 

----------------------------------------------------------------------------
 RPI PROJECT : WEBCAM WIRELESS STREAM 
----------------------------------------------------------------------------

// PROJECT DESCRIPTION ////////////////////////////////////////////////////////////////////////////////////////
	
	In this project, we will use a webcam with Raspberry Pi to live stream wirelessly. However, it can also be 
	done with wired connection. The basic requirement is that both the Raspberry Pi and the device on which 
	live stream is to be viewed are connected with same network. Rather than using the Raspberry Pi camera	
	module,	we can use a standard USB webcam to take pictures and video on the Raspberry Pi. This project can 
	be used for monitoring purposes. For eg- CCTV live surveillance camera.

// PRE-REQUISITE //////////////////////////////////////////////////////////////////////////////////////////////
	
	1. Raspberry Pi (Tested with RPi 3)
	2. Power Cable  (5V, 2A)
	3. Access to RPi Using SSH
	4. Webcam (Tested with Quantum QHM495LM)

	
// BACKEND WORKING ////////////////////////////////////////////////////////////////////////////////////////////
	
	We will use fswebcam app to capture images with RPi. fswebcam is a neat and simple webcam app. fswebcam 
	provides loop feature through which we can capture images in loop mode i.e. an image will be captured again
	& again in specified time interval. We can take advantage of loop mode to stream it like a video instead of
	still image. 
	
	For streaming purpose, we will use MJPG Streamer. mjpg-streamer is a command line application that copies 
	JPEG frames from one or more input plugins to multiple output plugins. It can be used to stream JPEG files 
	over an IP-based network from a webcam to various types of viewers such as Chrome, Firefox, VLC, mplayer, 
	and other software capable of receiving MJPG streams. MJPG streamer will take the image captured using 
	fswebcam to display it as a live webcam stream over an ip address which can be accessed by any device such
	as smartphone, laptop, desktop, etc. connected to the same network as Raspberry Pi.

	
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx LIVE STREAMING USING RASPBERRY PI xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


<STEP 1> INSTALL BUILD DEPENDENCIES 
	
	Open a new terminal window.	To install the three libraries that MJPG-Streamer uses, execute the following 
	command:
		$ sudo apt-get install libjpeg8-dev imagemagick libv4l-dev

<STEP 2> ADD MISSING VIDEODEV.H 

	The videodev.h header file that MJPG-Streamer needs has been replaced with a videodev2.h so we need to 
	create a symbolic link.	A symbolic link is where a file in one directory acts as a pointer to a file in 
	another directory. To create symbolic link:
		$ sudo ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h

<STEP 3> DOWNLOAD MJPG STREAMER

	To download the source code of MJPG Streamer from terminal:
		$ wget http://sourceforge.net/code-snapshots/svn/m/mj/mjpg-streamer/code/mjpg-streamer-code-182.zip

-> 	Sometimes, the method provided below to download source code fails. In that case,download it manually
	from this link - http://sourceforge.net/p/mjpg-streamer/code/HEAD/tarball

<STEP 4> UNZIP MJPG STREAMER SOURCE CODE 
	
	The downloaded file is a compressed zip file so we need to extract the files to built it. Put the file in 
	home directory(or a temporary folder, if you prefer) and run the following to extract the files:
		$ unzip mjpg-streamer-code-182.zip

<STEP 5> INSTALL BUILD DEPENDENCIES 
	
	MJPG-Streamer comes with several plugins, but we only need a couple of them to stream video. The command 
	below only builds what's needed:
		$ cd mjpg-streamer-code-182/mjpg-streamer
		$ make mjpg_streamer input_file.so output_http.so

<STEP 6> INSTALL MJPG STREAMER 

	To install the mjpg streamer, execute the following commands which will copy all the necessary into system 
	directories:
		$ sudo cp mjpg_streamer /usr/local/bin
		$ sudo cp output_http.so input_file.so /usr/local/lib/
		$ sudo cp -R www /usr/local/www
		
<STEP 7> INSTALL FSWEBCAM	
	
	To install the fswebcam package:
		$ sudo apt-get install fswebcam
		
<STEP 8> START THE CAMERA
	
	Now, it's time to start the webcam:
		$ cd
		$ mkdir /tmp/stream
		$ fswebcam -l 1 -b --no-banner --save /tmp/stream/pic.jpg 

-> fswebcam also provides several other options. For more info, enter following command: $ fswebcam --help

<STEP 9> START MJPG-STREAMER 

	Almost Done! Now, webcam started capturing images in loop. To start MJPG-Streamer, enter the following 
	command in terminal:
		$ LD_LIBRARY_PATH=/usr/local/lib mjpg_streamer -i "input_file.so -f /home/pi/tmp/stream -n pic.jpg" 
		  -o "output_http.so -w /usr/local/www"

<STEP 10> WATCH THE STREAM 
	
	To watch live stream on same raspberry pi, visit http://localhost:8080 in your web browser. To watch it 
	from any other device i.e. computer or smartphone, visit http://<IP-address>:8080 from your web	browser. 
	You can find the IP address used by Raspberry Pi from your router's homepage. Click on stream on the 
	webpage and your streaming will be live. All Done! Just relax and enjoy the live stream.

<STEP 11> CLEANUP 
	
	After everything is working fine, we can remove the source files:
		$ cd ../../
		$ rm -rf mjpg-streamer-182


< BONUS > STOP THE LIVE STREAM 
	
	To stop the live stream, we need to kill two processes- fswebcam and mjpg_streamer. Run the following
	commands at the terminal, to find the Process ID's(PID) of the two processes:
	
		$ ps -e | grep mjpg_streamer
		$ ps -e | grep fswebcam
		
	Above two commands will list the PID's of both the processes. Output of these commands will look like this: 
		17306 pts/1    00:00:00 mjpg_streamer
		15982 ?        00:00:01 fswebcam
		
	Now to kill both the processes:
		$ sudo kill <PID_of_mjpg-streamer>
		$ sudo kill <PID_of_fswebcam>
		
