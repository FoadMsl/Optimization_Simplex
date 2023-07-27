function y = ObjFunc(X)
global numFunc;

y = X(1) - X(2) + 2*X(1)^2 + 2 * X(1) * X(2) + X(2)^2;

numFunc = numFunc+1;
end