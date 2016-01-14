%% Round-Off and Truncation Error in Computing \(\sin(x)\)

%% The Sine Function
% You may not think that you need a numerical method to compute \(\sin(x)\),
% but you do.  This is not a calculation that one can do exactly with
% pencil and paper.  The basic numerical idea for computing the sine
% function is the Taylor polynomial, which takes the form
%
% \begin{equation}
% \sin(y) = \underbrace{y - \frac{y^3}{6} + \frac{y^5}{120} + \cdots -
% \frac{y^{2n-1}}{(2n-1)!} }_{\text{Taylor polynomial approximation}} +
% \underbrace{\frac{\cos(\xi) y^{2n+1}}{(2n+1)!}}_{\text{truncation
% error}}, \qquad \lvert \xi \rvert \le \lvert y \rvert. 
% \tag{Taylor} 
% \end{equation}
%
% By choosing \(n\) large enough, one may ensure that the truncation error
% is smaller than round-off error.  However, for large \(y\) the value of
% \(n\) would need to be quite large.  Thus, the first step in computing
% \(\sin(x)\) is to find a small value of \(y\) for which \(\sin(y) =
% \sin(x)\).  This is true for
%
% \begin{equation}
% y=x - 2\pi \left\lfloor \frac{x+\pi}{2\pi} \right \rfloor \in
% [-\pi,\pi). \tag{Reduce}
% \end{equation}
%
% The combination of these two equations, (Reduce) and (Taylor), is roughly
% how \(\sin(x)\) is computed numerically.

%% Round-Off Error
% Even though this numerical method for computing \(\sin(x)\) may look
% good, it is susceptible to round-off error when \(\lvert x\rvert\) is large.  This
% can be demonstrated as follows:

n=1000; %number of points to evaluate sin(x) at
fac=ceil(10*rand(1,n)); %random integers from 1 to 10
pow=floor(65*rand(1,n)); %random integers from 0 to 64
x=(2.^pow).*fac.*pi; %random integer multiples of pi
sinxexact=zeros(1,n); %true answer for sin(x)
sinxapprox=sin(x); %numerically computed answer using MATLAB's sin function
err=abs(sinxexact-sinxapprox); %error
figure %plot the error
h=loglog(x,err,'b.',[1 1e20],[eps,eps],'k--');
axis([1 1e20 1e-17 10]) %set the axes
set(gca,'xtick',10.^(0:4:20),'ytick',10.^(-16:4:1)) %label the axes
xlabel('\(N \pi\)')
ylabel('{\tt sin(N*pi)}')
legend(h,{'Actual','Ideal'},'location','northwest')
print -depsc SineRoundoff.eps

%%
% The reason for the severe round-off for large \(\lvert x\rvert\) is that
% in (Reduce) the two numbers \(x\) and \(\displaystyle 2\pi \left\lfloor
% \frac{x+\pi}{2\pi} \right \rfloor\) are quite close to each other,
% relatively speaking. Subtracting them causes a loss of accuracy, called
% cancellation error because digits cancel.

%% Truncation Error
% Now we turn ourselves to the possible error in (Taylor).  Since (Reduce)
% provides a value of \(y\) that with \(\lvert y \rvert \le \pi\), we can
% make the error of the Taylor polynomial small enough by choosing
%
% \[ \left \lvert \frac{\cos(\xi) y^{2n+1}}{(2n+1)!} \right \rvert \le \left
% \lvert \frac{\pi^{2n+1}}{(2n+1)!} \right \rvert \le \epsilon_{\text{machine}} =
% 2^{-53}. \]
% 
% This inequality holds for \(n \ge 14\).  Thus, if we choose \(n = 14\)
% and take some random values of \(x\), the approxmation to \(\sin(x)\) is
% as follows:

x = 20*rand(1,8) - 10 %random values of x
sinx = sin(x);
y = x - 2*pi*floor((x + pi)/(2*pi)); %reduce the argument to lying in [-pi,pi)
y2 = y.*y; %y squared
sinTaylor = y.*(1-(y2/6).*(1-(y2/20).*(1-(y2/42).*(1-(y2/72).*(1-(y2/110).* ...
   (1-(y2/156).*(1-(y2/210).*(1-(y2/272).*(1-(y2/342).*(1-(y2/420).* ...
   (1-(y2/506).* (1-(y2/600).* (1-(y2/702)))))))))))))); 
   %Taylor polynomial up to the term -y^2/(27!)
difference = sinx - sinTaylor %difference between MATLAB's sin and our sin
   
%%
% The difference between MATLAB's built-in |sin| function and our Taylor
% polynomial approximation is on the order of machine epsilon.
%
% However, if we choose a smaller value of \(n\), say, \(n = 8\), then the
% truncation error is larger than the round-off error

sinTaylor = y.*(1-(y2/6).*(1-(y2/20).*(1-(y2/42).*(1-(y2/72).*(1-(y2/110).* ...
    (1-(y2/156).*(1-(y2/210)))))))); 
   %Taylor polynomial up to the term -y^2/(15!)
difference = sinx - sinTaylor %difference between MATLAB's sin and our sin

%%
% _Author: Fred J. Hickernell_