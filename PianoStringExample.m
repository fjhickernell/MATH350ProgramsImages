%% Piano String Example
% A vibrating piano, violin, or guitar string has a displacement,
% \(y(t,x)\), is governed by the partial differential equation
%
% \[ \frac{\partial^2 y}{\partial t^2} - \alpha^2 \frac{\partial^2
% y}{\partial x^2} = 0, \qquad y(t,0) = y(t,1) = 0. \]
%
% The standing wave, \(y(t,x) = a(t) u(x)\), with amplitude \(a(t)\) and
% spatial pattern \(u(x)\) has
%
% \[ \frac{a''(t)}{\alpha^2 a(t)} = \frac{u''(x)}{u(x)} = \lambda. \]
%
% So
%
% \[ u'' = \lambda u, \qquad u(0) = u(1) = 0, \]
% 
% where a solution is only possible for discrete values of \(\lambda\).  We
% will use Chebfun to solve these problems.

%% Set up linear operator
tic
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
xint=[0 1];
Piano_op=chebop(xint); %create a differential operator
Piano_op.op=@(x,y) diff(y,2); 
   %parts involving y and perhaps x, note that diff means derivative
Piano_op.lbc=0; %left boundary condition
Piano_op.rbc=0; %right boundary condition

%% Compute the eigenvalues and eigenfunctions
[eigfun,eigenval]=eigs(Piano_op); %finding eigenfunctions and eigenvalues
eigenval=diag(eigenval);

%% Plot the eigenvalues and eigenfunctions
disp(['The first several eigenvalues are ' num2str(eigenval(end:-1:1)')])
figure
plot(eigfun(:,6:-1:2)) %plot the eigenfunctions
xlabel('\(x\)')
ylabel('\(u(x)\)')
print -depsc 'pianoeigfun.eps'
toc
