%% INCLUDE
addpath DataPreparation/camDataReadFiles;
addpath DataPreparation/kinectDataReadFiles;
addpath DataProcessing;

%% Params
nFreq = 6;
nShift = 8;
wKinect = 640;
hKinect = 480;
wCam = 2048;
hCam = 1536;

%% Data Preparation
[kinectPhaseX,kinectPhaseY,depth] = ReadKinectData(nFreq,nShift,wKinect,hKinect);
[camPhaseX,camPhaseY] = ReadCamImages(nFreq,nShift,wCam,hCam);

%% Data Processing
[Ppc,fcam]=codeFlow(kinectPhaseX,kinectPhaseY,depth,camPhaseX,camPhaseY,'ganeshaLarge.OFF');
