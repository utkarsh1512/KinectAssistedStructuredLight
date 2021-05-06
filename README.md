# KinectAssistedStructuredLight
High Resolution Structured Light Scanning with low calibration effort. This is the MATLAB code for the project I worked on for my M.Tech degree. The main aim was to bypass the checkerboard based calibration of the structured light 3D scanning setup as it is cumbersome and time consuming and has to be done every time the setup is moved. This purpose was achieved using an additional off the shelf 3D scanner (Kinect here). The coarse depth map from the Kinect was used to calibrate the structured light 3D scanning setup consisting of a projector and a high resolution 3D camera.

# Motivation
The project is kept here for maintainance and updates as the results achieved were very close to the actual objects being scanned but on the front of accuracy, it needs some work. Also, as of now, there are many hard coded values scattered throughout the scripts that I will try to move to a single script or a yml file where the user can change it easily.

# Screenshots

![setup](https://user-images.githubusercontent.com/30749734/117258710-e2d04b00-ae6a-11eb-8049-68837ccdadb2.PNG)

![scanned1](https://user-images.githubusercontent.com/30749734/117258778-f4195780-ae6a-11eb-9558-30033b5de3cc.PNG)
![scanned2](https://user-images.githubusercontent.com/30749734/117258792-f8457500-ae6a-11eb-8c5c-37f5f7167e4f.PNG)

