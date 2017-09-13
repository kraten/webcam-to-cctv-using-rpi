fswebcam -l 1 -b --no-banner --save pic.jpg 
sleep 5
sudo LD_LIBRARY_PATH=/usr/local/lib mjpg_streamer -i "input_file.so -f /home/pi/ -n pic.jpg" -o "output_http.so -w /usr/local/www" &
