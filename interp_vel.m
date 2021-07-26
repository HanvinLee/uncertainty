%% this function linearly interpolates for t (interp_time) given the 
function time = interp_time(vel_input)
    global solx
    global slope
    syms t
    eqn = slope*t + solx == vel_input;
    time = double(solve(eqn,t))
end