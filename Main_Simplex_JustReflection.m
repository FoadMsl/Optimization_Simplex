% =================================================
%       Main Code_Simplex_ExpansionContraction
%       Foad Moslem (foad.moslem@gmail.com) - Researcher | Aerodynamics
%       Using MATLAB R2022a
% =================================================
clc
clear
close all

% Function Alignment Lines ============================
[X1,Y1] = meshgrid(linspace(-8,8,51),linspace(-8,8,51));
for i = 1:length(X1)
    for j = 1:length(Y1)
        Z(i,j) = ObjFunc([X1(i,j),Y1(i,j)]);
    end
end
contour(X1,Y1,Z,20)
axis([-8 8 -8 8])
hold on

% =================================================
tic
global numFunc;
numFunc = 0;
Iter = 0;

% Main Code - Simplex ================================
% Initial Simplex: X = [x1, x2, x3]   that   x = (X(1),X(2)) in ObjFunc
X = [4.0,       4.0; 
        4.85,     4.0; 
        4.15,     4.85];

n = 2;                      % n-Dimentional Space
alfa = 1;                  % Reflection Coefficient
gamma = 3;           % Expansion Coefficient
beta = 0.5;             % Contraction Coefficient
%TolX = 1e-4;           % TolX:         The termination tolerance for x.
%TolFun = 1e-4;       % TolFun:     The termination tolerance for the function value.
%MaxIter = 300;      % MaxIter:   The maximum number of iterations allowed.
options = optimset('TolX',1e-4, 'TolFun',1e-4, 'MaxIter',300);

PlotSimplex(X)       % Plot X
hold on

for i = 1:n+1           % The function value at each of the vertices of the current simplex
    f(i) = ObjFunc(X(i,:));    
end

[fmax,loc] = max(f);         % Find Max f(i) => f(Xh)
Xh = X(loc,:);                     % Highest X(i)
[fmin,locMin] = min(f);   % Find min f(i) => f(Xl)
Xl = X(locMin,:);                % Lowest X(i)

epsilon_TolX = abs((Xh - Xl)/(1+abs(Xh)));
epsilon_TolFun = abs((fmax - fmin)/(1+abs(fmax)));

while ( (Iter < options.MaxIter) && (epsilon_TolX > options.TolX) && (epsilon_TolFun > options.TolFun) )
    [fmax,loc] = max(f);                          % Find Max f(i) => f(Xh)
    Xh = X(loc,:);                                      % Highest X(i)
    [fmin,locMin] = min(f);                    % Find min f(i) => f(Xl)
    Xl = X(locMin,:);                                 % Lowest X(i)
    OpLoc = find([1:n+1]~=loc);            % Find the points unequal with Xh
    X0 = sum(X(OpLoc,:)) / n;                % The Centroid of All The Points Xi except i = h

    Xr = (1+alfa)*X0 - alfa*Xh;               % The Reflected Point
    fXr = ObjFunc(Xr);                             % f(Xr)
    
    % Just Reflection
    X(loc,:) = Xr;
    f(loc) = ObjFunc(Xr);

    epsilon_TolX = abs((Xh - Xl)/(1+abs(Xh)));
    epsilon_TolFun = abs((fmax - fmin)/(1+abs(fmax)));
    Iter = Iter + 1;

    disp([f(loc),fmin]);
    %disp(sum(f))
    %pause
    PlotSimplex(X);
end

% =================================================
Xloc = X(loc,:);
plot(Xloc(:,1), Xloc(:,2),'kx');
fprintf('Number of CallFunction: %6.f\n',numFunc)
fprintf('CPU time: %6.4f\n',toc)
fprintf('X(1) Value of Optimum Point: %6.4f\n',Xloc(:,1))
fprintf('X(2) Value of Optimum Point: %6.4f\n',Xloc(:,2))
fprintf('TolX: %6.8f\t', options.TolX)
fprintf('epsilon_TolX: %6.8f\n', epsilon_TolX)
fprintf('TolFun: %6.8f\t', options.TolFun)
fprintf('epsilon_TolFun: %6.8f\n', epsilon_TolFun)
fprintf('MaxIter: %2.0f\t', options.MaxIter)
fprintf('Iter: %2.0f\n', Iter)

if epsilon_TolX <= options.TolX
    fprintf('%6s %12s\r\n', 'Exitflag:    1    ', 'The function converged to a solution x; The differences between minimum X(i) and maximum X(i) are equal to or less than TolX.')
elseif epsilon_TolFun <= options.TolFun
    fprintf('%6s %12s\r\n', 'Exitflag:    1    ', 'The function converged to a solution fx; The differences between minimum fX(i) and maximum fX(i) are equal to or less than TolFun.')
elseif Iter >= options.MaxIter
    fprintf('%6s %12s\r\n', 'Exitflag:    0    ', 'The number of iterations reached the maximum iteration (MaxIter).')
end