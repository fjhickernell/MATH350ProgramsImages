%% Round-Off Error and Machine Precision
% This script demonstrates some of the limitations of machine precision and
% the potentially serious effects of round-off error.

%% Format of the display
% MATLAB formats its display of numbers in several ways.  The default upon
% booting up is 

format short

%%
% Let's do a simple calculation in MATLAB:

1/3

%%
% Although we only see four significant digits, MATLAB is really doing the
% calculation to about 15 significant digits. To see more digits we type
% the command

format long

%% 
% Again we do the calculation, but this time we see more digits.

1/3

%% Machine Epsilon
% The number \(\epsilon_{\textrm{mach}}\) is defined as the smallest number
% that, when added to one, gives an answer greater than one.  In MATLAB,
% this is denoted |eps|.

eps

%%
% If we add |eps| to one we get a number larger than one

x = 1 + eps %adding eps to 1
difference = x - 1 %to show that x is not 1

%%
% But if we add a smaller number to 1, then we just get 1

x = 1 + eps/2 %adding eps/2 to 1
difference = x - 1 %to show that x is now 1

%%
% What about if we add larger numbers to 1 than just eps/2?

x = 1 + eps*[1 9/10 3/4 2/3 1/2] %adding multiples of eps to 1
difference = x - 1 %to show that x may or may not be 1

%% Quadratic Equation
% The quadratic equation takes the form
%
% \[ a x^2 + bx + c = 0.\]
%
% The solution of the quadratic equation is 
%
% \[ x_{\pm} = \frac{ - b \pm \sqrt{b^2 - 4ac}}{2a}.\]
%
% Let's try an example in MATLAB.

a = 1, b = -3, c = 2
x = (-b + [1 -1]*sqrt(b^2 - 4*a*c))/(2*a)

%% 
% This works as expected.  Now let's try an example with a large \(b\).

format short e
a = 1, b = -1e8, c = 1
x = (-b + [1 -1]*sqrt(b^2 - 4*a*c))/(2*a)

%%
% This is a *cancellation error* problem because two numbers that are
% nearly the same are subtracted from each other.  To solve this problem we
% re-write the formula for the quadratic equation

a = 1, b = -1e8, c = 1
x = [(-b - sign(b)*sqrt(b^2 - 4*a*c))/(2*a) ...
   2*c/(-b - sign(b)*sqrt(b^2 - 4*a*c))]

%%
% Now the answer should be correct to nearly 15 digits.


%%
% _Author: Fred J. Hickernell_