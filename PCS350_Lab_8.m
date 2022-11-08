clear
clc

xlim = [1,4];
ylim = [0.5,0.1];

step = 0.75;
[x75, y75] = model8(xlim,ylim,step); %Step size = 0.75

step = 0.375;
[x375, y375] = model8(xlim,ylim,step); %Step size = 0.375

step = 0.015;
[x015, y015] = model8(xlim,ylim,step); %Step size = 0.015

plot(x75,y75);
hold on
plot(x375,y375);
plot(x015,y015);
xlabel('x')
ylabel('y')
title("ODE's with Bondary Conditions Using Relaxation with Different Step Sizes(flipped)")
legend('0.75','0.375','0.015')