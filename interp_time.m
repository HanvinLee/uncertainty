
%% this function linearly interpolates for t (interp_time) 
% vel_input is the shock velocity, and it will output the interpolated time
% for that velocity
function time = interp_time(vel_input)
    global solx
    global slope
    syms t
    disp(slope);
   
    eqn = slope*t + solx == vel_input ;
    time = double(solve(eqn,t));
end


