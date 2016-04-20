%% LRC Circuits
% Circuits with inductors, resistors, and capacitors can be described by
% constant coefficient systems of ordinary differential equations.  These
% equations then can be solved in terms of the eigenvalues and eigenvectors
% of the matrix.  If \(\mathsf{A} = \mathsf{V} \mathsf{\Lambda}
% \mathsf{V}^{-1}\), where the columns of \(\mathsf{V}\) are the
% eigenvecgtors and the diagonal elements of the diagonal matrix
% \(\mathsf{\Lambda}\) are the eigenvalues, then the differential equation
% eigenvalue problem
%
% \[ 
% \boldsymbol{y}' = \mathsf{A} \boldsymbol{y}, \quad \boldsymbol{y}(0) =
% \boldsymbol{y}_0\]
%
% has the solution
% 
% \[
% \boldsymbol{y}(t) = \mathrm{e}^{\mathsf{A} t} \boldsymbol{y}_0, \qquad
% \mathrm{e}^{\mathsf{A} t} = \mathsf{V} \mathrm{e}^{\mathsf{\Lambda} t}
% \mathsf{V}^{-1}, \qquad \mathrm{e}^{\mathsf{\Lambda} t} =
% \textrm{diag}(\mathrm{e}^{\lambda_1 t}, \ldots, \mathrm{e}^{\lambda_n t}). \]

%% Setting up the Matrix
% We describe a circuit that has an LC unit in series with a resistor.

R = 1e3; %resistance in ohms
C = 1e-6; %capacitance in farads
L = 1; %inductance in henrys
A = [-1/(R*C) -1; 1/(L*C) 0]; %the first row describes the charge on the capacitor, and the second is the current through the inductor

%% Solving the ODE
[eigvec, eigval] = eig(A) %the eigenvectors and eigenvalues 
time = 0:1e-5:1e-2; %times to evaluate the solution
y0 = [0; 1]; 
yval = eigvec\y0; %vector V^-1 times y_0
yval = bsxfun(@times,exp(bsxfun(@times,diag(eigval),time)),yval); %exp(lambda t) * vector
yval = eigvec*yval; %eigenvectors times vector
%yval = real(yval); %remove small imaginary parts due to round-off.
figure
plot(time,yval(1,:))
xlabel('\(t\)')
ylabel('Capacitor Charge')
figure
plot(time,yval(2,:))
xlabel('\(t\)')
ylabel('Inductor Current')
