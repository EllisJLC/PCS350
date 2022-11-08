clc
clear

%% Question 1

decay_constant = -log(1/2)/2.7; %Calculate decay constant
C_0 = 800000; %800,000 starting particles
t_step = 128e-3; %Time steps
p = decay_constant * t_step; %Probability of decay
C_exp = C_0; %First value of C in the experimental dataset
t_exp = 0; %First value of t in the experimental dataset
C = C_0; %Starting number of particles to use in creating remaining particles array
t = 0; %Starting time, to use in creating time array
while C > 0
    C_decaying = rand(C,1); %Create array of random numbers to compare to probability of decay to determine which particles decay
    C_decaying(C_decaying>p) = 1; %Number of particles surviving
    C_decaying(C_decaying<p) = 0; %Particles decayed
    decayed = 1 - C_decaying; %Invert array
    C = C - sum(decayed,'all'); %Find new C
    t = t + t_step; %Find new t
    C_exp= [C_exp;C]; %Add new C to C_exp array
    t_exp = [t_exp;t]; %Add new t to t_exp array
end

t_exp = t_exp./24;

t_end = (-log(1/C_0)/decay_constant); %Finding the estimated time taken to reach C(t) = 1
t_theory = (0:t_step:(length(t_exp)-1)*t_step)./24; %Finding theoretical time in days
C_theory = C_0 .* exp(-(decay_constant*24).*t_theory); %Calculating theoretical remaining sample

plot(t_exp,C_exp,'k')
hold on
plot(t_theory,C_theory,'g')
xlabel('Elapsed time (d)')
ylabel('Remaining Particles in Sample')
title('Experimental vs. Theoretical Decay of Zanamivir')
set(gca,'YScale','log')
legend('Experimental','Theoretical')
hold off

t57_the = (-log(0.5734)/decay_constant); %Calculate time to reach 57.34% of original amount
[val,idx]=min(abs(C_exp-0.5734*C_0));
t57_exp = t_exp(idx);
t57_error = abs(t57_exp-t57_the)/t57_the;

fprintf('It theoretically takes approximately %d hours for the Zanamivir to decay to 57.34 percent of its original amount.',t57_the)
fprintf('\nThe error between the experimental and theoretical number of days for Zanamivir to decay to 57.34 percent of its original amount is %d \n',t57_error)

%%Question 2
stones = 10^6;

x_min = 0.7; %Parameters for x
x_max = 0.8;
deltax = x_max - x_min;
x_u = @(u) deltax.*u + x_min; %function to create random x values from random numbers u

y_min = 2.8*sin(0.8*pi) + 5; %Parameters for y
y_max = 2.8*sin(0.7*pi) + 5;
deltay = y_max - y_min;
y_u = @(u) deltay.*u + y_min; %Function to create random y values from random numbers u

stones_x_exp = x_u(rand(stones,1)); %Random x values
stones_y_exp = y_u(rand(stones,1)); %Random y values
stones_y_the = 2.8.*sin(stones_x_exp.*pi) + 5; %Theoretical y values
Iest = [stones_x_exp,stones_y_exp]; %Column array for x and y coordinates of the stones thrown

hits = stones_y_exp; %Finding number of hits
hits(hits < stones_y_the) = 0;
hits(hits > stones_y_the) = 1;
hits = 1 - hits;

error_plot = [];
throws = (1:stones)';
I_the = @(x) 2.8*sin(pi*x)+5;
area_the = integral(I_the,x_min,x_max);
hits_sums = cumsum(hits);
area_est = y_min*deltax + deltax.*deltay.*(hits_sums./throws); %estimated integral
error = abs(area_est-area_the)/area_the;

figure
plot(throws,error)
xlabel('Stone Throws')
ylabel('Error')
title('Stone Throws Vs. Error')
