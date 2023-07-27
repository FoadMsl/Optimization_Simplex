function PlotSimplex(X)

Xnew = [X;X(1,:)];
plot(Xnew(:,1), Xnew(:,2),'r-o');

end