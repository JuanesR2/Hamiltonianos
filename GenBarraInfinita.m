clc
clear

% Initial conditions
x_ini = [0.9; 0.8];  % Initial values of x

% Parameters
dt = 1/60/1;  % Time step (4 samples per cycle)
nt = 100;     % Number of time points
nx = 2;       % Number of variables (states)
nu = 1;       % Number of control inputs

wbase = 2 * pi * 60;
M = 30;
Pm = 5;
Pmax = 10;
J = [0 -1; 1 0];
%R = zeros(2, 2);
R = diag([0.3;0]);
% Define Hamiltonian H and its derivative dH
H = @(x) wbase * x(1)^2 / (2 * M) - Pmax * cos(x(2));
dH = @(x) [wbase * x(1) / M; Pmax * sin(x(2))];

% Define system dynamics function f
f = @(x) (J - R) * dH(x) + [0; Pm];

%% Explicit Euler Method %%

tode = (0:nt-1) * dt;   % Time vector
xode_explicit = zeros(nx, nt);  % State trajectory for explicit method
Hode_explicit = zeros(nt,1);
x_explicit = x_ini;     % Initial state
xode_explicit(:, 1) = x_explicit;  % Store initial state
Hode_explicit(1) = H(xode_explicit);
for k = 2:nt
    x_explicit = x_explicit + dt * f(x_explicit);
    xode_explicit(:, k) = x_explicit;
    Hode_explicit(k) = H(x_explicit);
end

figure(1)
plot(tode, xode_explicit')
title('Explicit Euler Method')
xlabel('Time')
ylabel('State Variables')
legend('x_1', 'x_2')


%% Implicit Euler Method %%
tode = (0:nt-1) * dt;   % Time vector
xode_implicit = zeros(nx, nt);  % State trajectory for implicit method
Hode_implicit = zeros(nt,1);
x_implicit = x_ini;     % Initial state
xode_implicit(:, 1) = x_implicit;  % Store initial state
Hode_implicit(1) = H(xode_implicit);

for k = 2:nt
    x_implicit = T(f, x_implicit, dt);
    xode_implicit(:, k) = x_implicit;
    Hode_implicit(k) = H(x_implicit);
end

figure(2)
plot(tode, xode_implicit')
title('Implicit Euler Method')
xlabel('Time')
ylabel('State Variables')
legend('x_1', 'x_2')



%% Runge-Kutta explicito %%

tode      = (1:nt)*dt;
xode      = zeros(nx,nt);
hode3 = zeros(nt,1);
x         = x_ini;
xode(:,1) = x_ini;
hode3(1) = H(x);

for k = 2:nt
    x = x + dt*Fr(f,x,dt);
    xode(:,k) = x;
    hode3(k) = H(x);
end

figure(3)
plot(tode,xode)
title("Explicit Rugen-Kutta Method")
xlabel('Time')
ylabel('State Variables')
legend('x_1', 'x_2')
grid on

%% Runge-Kutta implicito %% 

tode      = (1:nt)*dt;
xode      = zeros(nx,nt);
hode4     = zeros(nt,1);
x         = x_ini;
xode(:,1) = x_ini;
hode4(1) = H(x);

for k = 2:nt
    x = T(@(x) Fr(f,x,dt),x,dt); 
    xode(:,k) = x;
    hode4(k) = H(x);
end

figure(4)
plot(tode,xode)
title("Implicit Rugen-Kutta Method")
xlabel('Time')
ylabel('State Variables')
legend('x_1', 'x_2')
grid on

figure(5)
plot(tode, [Hode_explicit Hode_implicit hode3 hode4]')
title('Hamiltonian')
xlabel('Time')
ylabel('Hamiltonians')
legend('EulerEx_1', 'EulerImp_2', 'RkktExp_1', 'RkktImp_1')


[t,x] = ode45(@(t,x) f(x),tode,x_ini);

figure(6)
plot(t,x);
title('ODE45 Method')
xlabel('Time')
legend('x_1', 'x_2')
grid on



[t,x] = ode15s(@(t,x) f(x),tode,x_ini);

figure(7)
plot(t,x);
title('ODE15s Method')
xlabel('Time')
legend('x_1', 'x_2')
grid on




function xn = Fr(f,x,dt)
    f1 = f(x);
    f2 = f(x + dt*f1/2);
    f3 = f(x + dt*f2/2);
    f4 = f(x + dt*f3);

    xn = (f1 + 2*f2 + 2*f3 + f4)/6;
end



function xn = T(f, x, dt)
    tol = 1e-6;
    m = 0;
    err = tol + 1;
    xn = x;
    
    while err > tol && m < 50
        xa = xn;
        xn = x + dt * f(xa);
        err = norm(xa - xn);
        m = m + 1;
    end
    
    if m >= 50
        disp('Inconsistency: Maximum iterations reached.');
    end
end



