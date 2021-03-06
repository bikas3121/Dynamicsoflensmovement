m = 0.5;    % mass of the lens
A = [0 1; 0 0]; % state of the dynaimcs (4).
B = [0; 1/m]; % input matrix
W = [0; -1]; % the weight matrix W in (4);.
g = 9.8;

%% Define reference points
x_0 = [0;0];  % initial point
x_1 = [1;0];    % final point.

%In order to generate the reverse motion (i.e., to go from point B to point
%A) uncomment the following. 
% x_0 = [1;0];  % initial point
% x_1 = [0;0];    % final point
% Also, the matrix W should be taken as -W during downwards motion because
% the both input force and the weight are acting in the same direction.

%% Time constants
T = 0.2;
t_0 = 0;


%% Time steps for 
delta_T = 0.0001;
tspan = [0:delta_T:T];

% From time 0 to 0.2 at A
u1 = m*g;
[t1,x1] = ode45(@(t,x)  A*x +B*u1 + W*g, tspan, x_0);


% From point A to B
t_i = 0;
[t2, x2, u2] = odecalculator(A,B,T,t_0,t_i, W, g, x_0, x_1, delta_T);
% t2 = (t2 +0.2)';

% Stationary at point B
u3 = m*g;
[t3, x3] = ode45(@(t,x)  A*x +B*u3 + W*g, tspan, x_1);
% t2 = (t2 +0.2)';


% From point B to A;
t_i = 0;
[t4, x4, u4] = odecalculator(A,B,T,t_0,t_i, -W, g, x_1, x_0, delta_T);

%% The code in the following is the repetition of the period
% From time 0 to 0.2 at A
u5 = m*g;
[t5,x5] = ode45(@(t,x)  A*x +B*u5 + W*g, tspan, x_0);
% figure 
% plot(t1,x1(:,1));

% From point A to B
t_i = 0;
[t6, x6, u6] = odecalculator(A,B,T,t_0,t_i, W, g, x_0, x_1, delta_T);
% t2 = (t2 +0.2)';

% Stationary at point B
u7 = m*g;
[t7, x7] = ode45(@(t,x)  A*x +B*u7 + W*g, tspan, x_1);
t2 = (t2 +0.2)';


% From point B to A;
t_i = 0;
[t8, x8, u8] = odecalculator(A,B,T,t_0,t_i, -W, g, x_1, x_0, delta_T);


%% Plots : Position Vs Time
% t = [t1; t1+1];
% x = [x1; x2];

t = [t1; t1+0.2; t1+0.4; t1+0.6; t1+0.8; t1+1 ;t1+1.2; t1+1.4];
x = [x1; x2; x3; x4; x5; x6;x7; x8];
figure
plot(t, x(:,1));
xlabel('Time (s)')
ylabel('Position (m)')
grid minor


%% Plots: Control and Velocity vs Time 
u1_t = [];
u3_t = [];
u5_t= [];
u7_t= [];
for i = 1:length(t2)
    u1_ti= u1;
    u3_ti = u3;
    u5_ti= u5;
    u7_ti = u7;
    u1_t = [u1_t; u1_ti];
    u3_t = [u3_t; u3_ti];
    u5_t = [u5_t; u5_ti];
    u7_t = [u7_t; u7_ti];
end
% u = [u1_t; u2];
u = [u1_t; u2; u3_t; u4; u5_t; u6; u7_t; u8];

figure

subplot(2,1,1); 
plot(t, x(:,2));
xlabel('Time (s)')
ylabel('Velocity ')
grid minor
subplot(2,1,2);
plot(t, u);
xlabel('Time (s)')
ylabel('Control')
grid minor

%% Plots -Instantaneous Cost
J_inst = [];
for i = 1:length(u)
    J_inst_i = 0.5*u(i)^2;
    J_inst = [J_inst; J_inst_i];
end

figure
plot(t, J_inst)
xlabel('Time(s)')
ylabel('Instantaneous Cost')
grid minor

%% Plot-Power 
% Power = force*velocity
P_av = ones(length(u),1)*3680;
P = [];
for i = 1:length(u)
    P_i  = abs(u(i)*x(i,2));
    P = [P, P_i];
end
figure
plot(t, P)
% hold on
% plot(t, P_av)
xlabel('Time (s)')
ylabel('Power')
grid minor


