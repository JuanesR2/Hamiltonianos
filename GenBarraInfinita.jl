using LinearAlgebra
using DifferentialEquations
using Plots

# Define the system dynamics function `f`
function f(du, u, p, t)
    wbase = 2 * pi * 60
    M = 30
    Pm = 5
    Pmax = 10
    
    # Define the Jacobian matrix J and resistance matrix R
    J = [0 -1; 1 0]
    R = Diagonal([0.3, 0])
    
    # Compute dH(x) using the current state `u`
    dH_x = [wbase * u[1] / M, Pmax * sin(u[2])]
    
    # Compute f(x) using the system dynamics
    du .= (J - R) * dH_x + [0, Pm]
end

# Initial conditions
x_ini = [0.9, 0.8]  # Initial values of x

# Parameters
dt = 1/60/1  # Time step (4 samples per cycle)
nt = 100     # Number of time points

# Define ODEProblem with the modified `f` function
prob = ODEProblem(f, x_ini, (0.0, nt*dt))

# Solve the ODE problem
sol = solve(prob, Tsit5())

# Extract the solution data
t_values = sol.t
x_values = hcat(sol.u...)  # Transpose sol.u to get x_values as a matrix

# Plot the solution
plot(t_values, x_values', title="ODE Solution", xlabel="Time", label=["x₁", "x₂"])
