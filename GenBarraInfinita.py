import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Define the system dynamics function `f`
def f(t, u):
    wbase = 2 * np.pi * 60
    M = 30
    Pm = 5
    Pmax = 10
    
    # Define the Jacobian matrix J and resistance matrix R
    J = np.array([[0, -1], [1, 0]])
    R = np.diag([0.3, 0])
    
    # Compute dH(x) using the current state `u`
    dH_x = np.array([wbase * u[0] / M, Pmax * np.sin(u[1])])
    
    # Compute f(x) using the system dynamics
    du = (J - R) @ dH_x + np.array([0, Pm])
    return du

# Initial conditions
x_ini = np.array([0.9, 0.8])  # Initial values of x

# Time points
nt = 100    # Number of time points
t_span = (0.0, nt * (1/60/1))  # Time span

# Solve the ODE problem
sol = solve_ivp(f, t_span, x_ini, method='RK45')

# Extract the solution data
t_values = sol.t
x_values = sol.y

# Plot the solution
plt.figure(figsize=(10, 6))
plt.plot(t_values, x_values[0], label='x₁')
plt.plot(t_values, x_values[1], label='x₂')
plt.title('ODE Solution')
plt.xlabel('Time')
plt.ylabel('State Variables')
plt.legend()
plt.grid(True)
plt.show()
