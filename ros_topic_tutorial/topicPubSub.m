clc;
clear all;
close all;

setenv('ROS_MASTER_URI','http://localhost:11311');

% Start ROS master
rosinit;

%% Publisher Setup

% Setup a publisher and message data type
[myPub, pubMsg] = rospublisher('/chatter', 'std_msgs/Int32');

% Initialize publish data
count = 0;

%% Subscriber Setup

% Setup a subscriber, asynchronous execution
mySub = rossubscriber('/chatter', @callbackFcn);


% % Schedule one or more tasks in the background - Matlab timers
% % Multiple callbacks, timers in same Matlab session share a single thread.
% % For more precise timing control, like PID contoller.
% my_timer = timer('TimerFcn', @callbackFcn, ...
%                  'ExecutionMode', 'fixedRate', ...
%                  'Period', 0.5);
% start(my_timer);


%% Publish Data Method 1: Not Recommend

% currentTime = 0;
% tic
% while(currentTime < 10)
%     pubMsg.Data = count;
%     send(myPub, pubMsg);
%     currentTime = toc;
%     display(pubMsg.Data);
%     count = count + 1;
% end


%% Publish Data Method 2: Recommend

% CPU wall clock time, run at 1Hz
% rate = robotics.Rate(1);

% Global ROS node time, run at 2Hz
rate = rosrate(2);   

% Setup timer 10 seconds
timer = 10;

while(rate.TotalElapsedTime < timer)
    
    % Update publish data
    pubMsg.Data = count;
    
    % Publish data to ROS system
    send(myPub, pubMsg);
    
    % Display the published data
    disp_str = ['Publishing data: Hello ', num2str(pubMsg.Data)];
    disp(disp_str);
    
    % Update next publish data
    count = count + 1;
    
    % Wait for 1/r second
    waitfor(rate);
end


% Shutdown ROS 
rosshutdown; 


