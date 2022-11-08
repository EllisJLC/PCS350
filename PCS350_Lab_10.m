clear
clc

% Given values
v = 2; %m/s
dx = 0.05; %m, spacial stepsize
dt = 0.001; %s, time stepsize
y10_0 = 0; %initial values for opposite ends of the range -10<=x<=10
x = (-10:0.05:10)'; %range of x

sigma = (v*dt/dx)^2;                                % changed
yx_0 = 2./(1+x.^4); % f, or y0 vector
%y = yx_0(2:end-1);

Alr = -sigma*ones(length(x)-3,1);                    % A defn' change for implicit
Am = (2 + 2*sigma)*ones(length(x)-2,1);               
A = diag(Alr,-1) + diag(Am,0) + diag(Alr,+1);
A = inv(A);
g = 16*x.^3./(1+x.^4).^2;
b = zeros(length(x)-4,1);
b = [g(1); b; g(end)];

y0 = yx_0(2:end-1);
y1 = A * (2*y0 - b*dt*sigma) + dt*g(2:end-1); %y1

%%
for time = 0:0.001:10
        % just need to compute the sol'n
        y2 = 4*A*y1 - y0;
        y0 = y1;                % redefine the variables to reset for next iteration
        y1 = y2;
 
    if rem(time,0.1) == 0 %Check if timestep is a 0.1s step
        plot(x,[0; y2; 0])
        txt = strcat('Wave Function at ',{' '}, string(time), 's');
        title(txt);
        xlabel('Distance (m)')
        ylabel('Height (m)')
        ylim([-2.5, 2.5])
        drawnow
    end
end
