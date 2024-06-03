function means = manysims(n0,n1,n2,t,m,type)
means = zeros(3,m);

if type == "lin"
    for j = 1:m
        [N0,N1,N2] = linendtimesim(n0,n1,n2,t);
        means(1,j) = N0;
        means(2,j) = N1;
        means(3,j) = N2;
    end
else
    for j = 1:m
        [N0,N1,N2] = logendtimesim(n0,n1,n2,t);
        means(1,j) = N0;
        means(2,j) = N1;
        means(3,j) = N2;
    end
end

end

function [N0,N1,N2] = linendtimesim(n0,n1,n2,t)
    r = 1/2.5; %S -> S TA rate; from literature
    l = 1/1.25; %TA -> TA TA rate; from lit
    g = 1/3.5; %FD -> {} rate; from lit
    a = 1/30; %S -> {} rate; this is assumed, rest are for balance
    b = 38/39615;
    d = 6350/7833;
    K = Inf; % DO NOT FORGET TO CHANGE B TO MATCH

    N0 = n0;
    N1 = n1;
    N2 = n2;

    time = 0;

    while time < t
        %get the new rates
        rate = (r+a)*N0 + b*(1-(N0/K))*N1 + (l+d)*N1 + g*N2;
        if rate == 0
            N0 = 0;
            N1 = 0;
            N2 = 0;
            time = t;
        else
            step = rand(1)*rate;
            time = time + randexp(rate);
       
            %identify next action and record new info
            if step <= (r)*N0
                N1 = N1 + 1;
            elseif step <= (r+a)*N0
                N0 = N0 - 1;
            elseif step <= (r+a)*N0 + b*(1-(N0/K))*N1
                N0 = N0 + 1;
                N1 = N1 - 1; 
            elseif step <= (r+a)*N0 + b*(1-(N0/K))*N1 + (l)*N1
                N1 = N1 + 1; 
            elseif step <= (r+a)*N0 + b*(1-(N0/K))*N1 + (l+d)*N1
                N1 = N1 - 1; 
                N2 = N2 + 1;
            else
                N2 = N2 - 1;
            end
        end
    end
end

function [N0,N1,N2] = logendtimesim(n0,n1,n2,t)
    r = 1/2.5; %S -> S TA rate; from literature
    l = 1/1.25; %TA -> TA TA rate; from lit
    g = 1/3.5; %FD -> {} rate; from lit
    a = 1/30; %S -> {} rate; this is assumed, rest are for balance
    d = 6350/7833;
    K = 25;
    b = (25/7)*(38/39615);

    N0 = n0;
    N1 = n1;
    N2 = n2;

    time = 0;

    while time < t
        %get the new rates
        rate = (r+a)*N0 + b*(1-(N0/K))*N1 + (l+d)*N1 + g*N2;
        if rate == 0
            N0 = 0;
            N1 = 0;
            N2 = 0;
            time = t;
        else
            step = rand(1)*rate;
            time = time + randexp(rate);
       
            %identify next action and record new info
            if step <= (r)*N0
                N1 = N1 + 1;
            elseif step <= (r+a)*N0
                N0 = N0 - 1;
            elseif step <= (r+a)*N0 + b*(1-(N0/K))*N1
                N0 = N0 + 1;
                N1 = N1 - 1; 
            elseif step <= (r+a)*N0 + b*(1-(N0/K))*N1 + (l)*N1
                N1 = N1 + 1; 
            elseif step <= (r+a)*N0 + b*(1-(N0/K))*N1 + (l+d)*N1
                N1 = N1 - 1; 
                N2 = N2 + 1;
            else
                N2 = N2 - 1;
            end
        end
    end
end