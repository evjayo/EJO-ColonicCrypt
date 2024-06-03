%% Simulation
function [N0,N1,N2,times] = sim(n0,n1,n2,t,type)
    r = 1/2.5; %S -> S TA rate; from literature
    l = 1/1.25; %TA -> TA TA rate; from lit
    g = 1/3.5; %FD -> {} rate; from lit
    a = 1/30; %S -> {} rate; this is assumed, rest are for balance
    d = 6350/7833;

    if type == "lin"
        K = Inf;
        b = 38/39165;
    else
        K = 25;
        b = (25/7)*(38/39165);
    end


    times = zeros(1000000,1);
    N0 = zeros(1000000,1);
    N1 = zeros(1000000,1);
    N2 = zeros(1000000,1);
    %if more than a million things happen were in some trouble
    N0(1) = n0;
    N1(1) = n1;
    N2(1) = n2;
    times(1) = 0;
    i = 1;
    time = 0;

    while time < t
        %get the new rates
        rate = (r+a)*N0(i) + b*N1(i)*(1-(N0(i)/K)) + (l+d)*N1(i) + g*N2(i);
        if rate == 0
            N0(i+1) = 0;
            N1(i+1) = 0;
            N2(i+1) = 0;
            time = t;
        else
            step = rand(1)*rate;
            time = time + randexp(rate);
       
            %identify next action and record new info
            if step <= r*N0(i)
                N0(i+1) = N0(i);
                N1(i+1) = N1(i) + 1; 
                N2(i+1) = N2(i);
                times(i+1) = time;
            elseif step <= (r+a)*N0(i)
                N0(i+1) = N0(i) - 1;
                N1(i+1) = N1(i); 
                N2(i+1) = N2(i);
                times(i+1) = time;
            elseif step <= (r+a)*N0(i) + b*N1(i)*(1-(N0(i)/K))
                N0(i+1) = N0(i) + 1;
                N1(i+1) = N1(i) - 1; 
                N2(i+1) = N2(i);
                times(i+1) = time;
            elseif step <= (r+a)*N0(i) + b*N1(i)*(1-(N0(i)/K)) + l*N1(i)
                N0(i+1) = N0(i);
                N1(i+1) = N1(i) + 1; 
                N2(i+1) = N2(i);
                times(i+1) = time;
            elseif step <= (r+a)*N0(i) + b*N1(i)*(1-(N0(i)/K)) + (l+d)*N1(i)
                N0(i+1) = N0(i);
                N1(i+1) = N1(i)-1; 
                N2(i+1) = N2(i)+1;
                times(i+1) = time;
            else
                N0(i+1) = N0(i);
                N1(i+1) = N1(i); 
                N2(i+1) = N2(i)-1;
                times(i+1) = time;
            end
        end

    i = i+1;
    end

    %get rid of the stuff that we don't have
    N0 = N0(1:i);
    N1 = N1(1:i);
    N2 = N2(1:i);
    times = times(1:i);
end