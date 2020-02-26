clc;clear;
% calculator for dispersion coefficients sig_y and sig_z
% First, select the classification A,B,C,D,E,F
prompt='Enter classification ("A, A-B, B, B-C, C, C-D, D, E, F")\n';
class=input(prompt,'s');
% Second, input the parameters
prompt='Enter distance (in km): x=';
x=input(prompt);                            %x
while(x==1)
    fprintf('x cannot be 1. Try again.\n');
    x=input(prompt);
end
                                            %mdot
prompt='Enter the emission rate (g/s): mdot=';
mdot=input(prompt);
                                            %U
prompt='Enter wind speed (m/s): U=';
U=input(prompt);
                                            %y
prompt='Enter y (m): y=';
y=input(prompt);
                                            %z
prompt='Enter z (m): z=';
z=input(prompt);

prompt='Enter H (effective stack height) (m): H=';
H=input(prompt);
%Input conditions for ground and inversion
prompt='Is the ground absorbing or reflecting? (Enter "A" or "R")\n';
ground=input(prompt,'s');
while((ground~='A' && ground~='a') && (ground~='R' && ground~='r'))
    fprintf('Input must be either "A" for absorbing ground or "R" for reflecting ground. Try again.\n');
    ground=input(prompt,'s');
end

prompt='Is there inversion? (Enter "Y" for yes or "N" for no)\n';
inversion=input(prompt,'s');
while((inversion~='Y' && inversion~='y') && (inversion~='N' && inversion~='n'))
    fprintf('Input must be either "Y" for inversion or "N" for no inversion. Try again.\n');
    inversion=input(prompt,'s');
end

% Third, find the variables a,b,c,d,f
if(class=='A')
    a=213;
    b=0.894;
    if(x<1)
        c=440.8;
        d=1.941;
        f=9.27;
    elseif(x>1)
        c=459.7;
        d=2.094;
        f=-9.6;
    end
elseif(class=='A-B')
    a=0.5*(213+156);
    b=0.894;
    if(x<1)
        c=0.5*(440.8+106.60);
        d=0.5*(1.941+1.149);
        f=0.5*(9.27+3.3);
    elseif(x>1)
        c=0.5*(459.7+108.2);
        d=0.5*(2.094+1.098);
        f=0.5*(-9.6+2.0);
    end
elseif(class=='B')
    a=156;
    b=0.894;
    if(x<1)
        c=106.6;
        d=1.149;
        f=3.3;
    elseif(x>1)
        c=108.2;
        d=1.098;
        f=2.0;
    end
elseif(class=='B-C')
    a=0.5*(156+104);
    b=0.894;
    if(x<1)
        c=0.5*(106.6+61.0);
        d=0.5*(1.149+0.911);
        f=3.3;
    elseif(x>1)
        c=0.5*(108.2+61.0);
        d=0.5*(1.098+0.911);
        f=2.0;
    end
elseif(class=='C')
    a=104;
    b=0.894;
    c=61.0;
    d=0.911;
    f=0;
elseif(class=='C-D')
    a=0.5*(104+68.0);
    b=0.894;
    if(x<1)
        c=0.5*(61.0+33.2);
        d=0.5*(0.911+0.725);
        f=-1.7;
    elseif(x>1)
        c=0.5*(61.0+44.5);
        d=0.5*(0.911+0.516);
        f=-13.0;
    end
elseif(class=='D')
    a=68.0;
    b=0.894;
    if(x<1)
        c=33.2;
        d=0.725;
        f=-1.7;
    elseif(x>1)
        c=44.5;
        d=0.516;
        f=-13.0;
    end
elseif(class=='E')
    a=50.5;
    b=0.894;
    if(x<1)
        c=22.8;
        d=0.678;
        f=-1.3;
    elseif(x>1)
        c=55.4;
        d=0.305;
        f=-34.0;
    end
elseif(class=='F')
    a=34.0;
    b=0.894;
    if(x<1)
        c=14.35;
        d=0.740;
        f=-0.35;
    elseif(x>1)
        c=62.6;
        d=0.180;
        f=-48.6;
    end
else
    fprintf('Input was not A, B, C, D, E, or F');
end
% Find sigma_y and sigma_z
sig_y=a*(x^b);
sig_z=c*(x^d)+f;
% % calculator for absorbing ground mass concentration (with and without inversion)
if(ground=='A'||ground=='a')
    if(inversion=='N'||inversion=='n')
        c_j = mdot/(2*pi*U*sig_y*sig_z)*exp(-0.5*((y/sig_y)^2 +((z-H)/sig_z)^2));
    elseif(inversion=='Y'||inversion=='y')
        prompt='Enter the elevation of the reflecting part of the inversion.\n';
        H_T=input(prompt);
        c_j = mdot/(2*pi*U*sig_y*sig_z)*exp(-0.5*(y/sig_y)^2)*(exp(-0.5*((z-H)/sig_z)^2)+exp(-0.5*((z-(2*H_T-H))/sig_z)^2));
    end
end
% % calculator for reflecting ground mass concentration
if(ground=='R'||ground=='r')
    c_j = mdot/(2*pi*U*sig_y*sig_z)*(exp(-0.5*((y/sig_y)^2 +((z-H)/sig_z)^2))+exp(-0.5*((y/sig_y)^2 +((z+H)/sig_z)^2)));
end