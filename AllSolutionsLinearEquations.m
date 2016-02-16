%% Finding All Solutions of Linear Equations
% Solving systems of linear equations, i.e., 
%
% \[ \underbrace{\mathsf{A}}_{m \times n} \ \
% \underbrace{\boldsymbol{x}}_{n \times 1} = \underbrace{\boldsymbol{b}}_{m
% \times 1}, \qquad \mathsf{A},\ \boldsymbol{b} \text{ given,} \quad
% \boldsymbol{x} = ? \]
%
% arises in many applications.  Here \(m\) represents the number of
% equations, and \(n\) represents the number of scalar unknowns.  In this
% script we show how to
%
% * determine if a solution exists, and whether there is more than one
% solution,
% * find all solutions that exist
% * find the best approximate solution if no solutions exist.
%
% The answers to these questions depend both on \(\mathsf{A}\) and
% \(\boldsymbol{b}\).

%% Solving via the Singular Value Decomposition
% Any \(m \times n\) matrix \(\mathsf{A}\) can be decomposed as
%
% \[ \mathsf{A} = \mathsf{U} \mathsf{S} \mathsf{V}^T, \]
%
% where 
% 
% * \(\mathsf{U}\) is an \(m \times m\) matrix satisfying \(\mathsf{U}^{-1}
% = \mathsf{U}^T\); this means that the columns of \(\mathsf{U}\) are
% orthonormal.
% * \(\mathsf{V}\) is an \(n \times n\) matrix satisfying \(\mathsf{V}^{-1}
% = \mathsf{V}^T\), and
% * \(\mathsf{S}\) is an \(m \times n\) diagonal matrix with non-negative
% elements, and with the first \(p\) diagonal elements being positive.
%
% Note that \[ p \le \min(m,n). \] Thus,
%
% \begin{equation*} \mathsf{A}\boldsymbol{x} = \boldsymbol{b} \iff
% \mathsf{U} \mathsf{S} \mathsf{V}^T\boldsymbol{x} = \boldsymbol{b}  \iff
% \mathsf{S} \boldsymbol{y} = \boldsymbol{c} = \mathsf{U}^T
% \boldsymbol{b},\quad \boldsymbol{x} = \mathsf{V} \boldsymbol{y}
% \end{equation*}
%
% Since \(\mathsf{S}\) has such a simple form, it is possible to solve
% \(\mathsf{S} \boldsymbol{y} = \boldsymbol{c}\) for the first \(p\)
% elements of \(\boldsymbol{y}\) by simple division:
%
% \[ \underbrace{\begin{pmatrix} \begin{matrix} s_{11} & & \\ & s_{22} \\ &
% & \ddots \\ & & & s_p \end{matrix} & {\Huge \mathsf{0}} \\ \\ {\Huge
% \mathsf{0}} & {\Huge \mathsf{0}} \end{pmatrix}}_{m \times n}
% \begin{pmatrix}y_1 \\ y_2 \\ \vdots \\ y_p \\ y_{p+1} \\ \vdots \\ y_n
% \end{pmatrix} = \begin{pmatrix}c_1 \\ c_2 \\ \vdots \\ c_p \\ c_{p+1} \\
% \vdots \\ c_m \end{pmatrix} , \qquad \boldsymbol{y} =
% \begin{pmatrix}c_1/s_{11} \\ c_2/s_{22} \\ \vdots \\ c_p/s_{pp} \\
% y_{p+1} \\ \vdots \\ y_n\end{pmatrix}\]
%
% As we can see, the bottom \(n-p\) elements of \(\boldsymbol{y}\) cannot
% be determined uniquely.  Thus, we can write the solution as 
%
% \[ \boldsymbol{x} = \mathsf{V} \boldsymbol{y} = \begin{pmatrix}
% \underbrace{\mathsf{V}_{\mathrm{L}}}_{n \times p} &
% \underbrace{\mathsf{V}_{\mathrm{R}}}_{n \times n-p} \end{pmatrix}
% \begin{pmatrix}c_1/s_{11} \\ \vdots \\ c_p/s_{pp} \\ \boldsymbol{a}
% \end{pmatrix} = \mathsf{V}_{\mathrm{L}} \begin{pmatrix}c_1/s_{11} \\
% \vdots \\ c_p/s_{pp} \end{pmatrix} + \mathsf{V}_{\mathrm{R}}
% \boldsymbol{a}\]
%
% where \(\boldsymbol{a}\) is an arbitrary \(n-p \times 1\) vector.
%
% If \(p = n\), then the solution, \(\boldsymbol{x}\), is unique.  If \(p <
% n\), then there are infinitely many solutions corresponding to infinitely
% many choices of \(\boldsymbol{a}\).  Note that
%
% \[ \lVert \boldsymbol{x} \rVert^2 =
% \boldsymbol{x}^T\boldsymbol{x} = \boldsymbol{y}^T \mathsf{V}^T
% \mathsf{V} \boldsymbol{y} = \boldsymbol{y}^T \boldsymbol{y} =
% (c_1/s_{11})^2 +  \cdots + (c_p/s_{pp})^2 + \lVert \boldsymbol{a}
% \rVert^2. \]
%
% Therefore, choosing \(\boldsymbol{a} = \boldsymbol{0}\) yields the
% solution with smallest norm.
%
% If \(p = m\), then all equations are satisfied, and \(\boldsymbol{x}\) is
% an _exact_ solution to \(\mathsf{A} \boldsymbol{x} = \boldsymbol{b}\). If
% \(p < m\), then the solution may not be exact.  Note that
%
% \[ \mathsf{A} \boldsymbol{x} - \boldsymbol{b} =
% \mathsf{U}\bigl(\mathsf{S}\mathsf{V}\boldsymbol{x} - \mathsf{U}^T
% \boldsymbol{b}\bigr) = \mathsf{U}\bigl(\mathsf{S}\boldsymbol{y} -
% \boldsymbol{c}\bigr) = \mathsf{U} \begin{pmatrix} s_{11} y_1 - c_1 \\
% \vdots \\ s_{pp}y_p - c_p \\ c_{p+1} \\ \vdots \\ c_m \end{pmatrix} =
% \mathsf{U} \begin{pmatrix} s_{11} y_1 - c_1 \\ \vdots \\ s_{pp}y_p - c_p
% \\ \boldsymbol{c}_{\textrm{L}} \end{pmatrix} ,\]
%
% where \(\boldsymbol{c}_{\textrm{L}} = (c_{p+1}, \ldots, c_m)^T \).  Then
% the lack of fit is measured as where \(\boldsymbol{c}_{\textrm{L}} =
% \mathsf{U}_{\textrm{R}}^T \boldsymbol{b}\).  Then the lack of fit is
% measured as
%
% \[ \lVert \mathsf{A} \boldsymbol{x} - \boldsymbol{b} \rVert = \lVert
% \mathsf{U} \bigl(\mathsf{S}\boldsymbol{y} - \boldsymbol{c}\bigr) \rVert =
% \sqrt{ \bigl(\mathsf{S}\boldsymbol{y} - \boldsymbol{c}\bigr)^T
% \mathsf{U}^T \mathsf{U} \bigl(\mathsf{S}\boldsymbol{y} -
% \boldsymbol{c}\bigr)} = \sqrt{ \bigl(\mathsf{S}\boldsymbol{y} -
% \boldsymbol{c}\bigr)^T \bigl(\mathsf{S}\boldsymbol{y} -
% \boldsymbol{c}\bigr)} = \sqrt{ (s_{11} y_1 - c_1)^2 + \cdots + 
% (s_{pp}y_p - c_p)^2 + \boldsymbol{c}_{\textrm{L}}^T
% \boldsymbol{c}_{\textrm{L}}}. \]
%
% It is evident from the equation above that the choice of \(y_1 =
% c_1/s_{11}, \ldots, y_p = c_p/s_{pp}\) made above minimizes the lack of
% fit.  Under this choice, the lack of fit becomes
%
% \[ \lVert \mathsf{A} \boldsymbol{x} - \boldsymbol{b} \rVert = \sqrt{
% \boldsymbol{c}_{\textrm{L}}^T \boldsymbol{c}_{\textrm{L}}} = \lVert
% \boldsymbol{\boldsymbol{c}_{\textrm{L}}} \rVert= \lVert
% \mathsf{U}_{\textrm{R}}^T \boldsymbol{b} \rVert,\]
%
% since \(\boldsymbol{c}_{\textrm{L}} = \mathsf{U}_{\textrm{R}}^T
% \boldsymbol{b}\) where \(\mathsf{U}_{\textrm{R}}\) denotes the right
% \(m-p\) columns of \(\mathsf{U}\).  If \(\boldsymbol{c}_{\textrm{L}} =
% \mathsf{U}_{\textrm{R}}^T \boldsymbol{b} = \boldsymbol{0} \), then
% \(\boldsymbol{x}\) is an exact solution. Otherwise, \(\boldsymbol{x}\) is
% an approximate solution.


%% Code for This Procedure
% The mathematical procedure described above has been implemented in the
% following function:
%
% <include>linearEquations.m</include>
%
% We will use this function to compute some solutions of linear equations.

%% Examples
% Now we try some examples.  First is a simple square, nonsingular matrix.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
A = [3 -1 4
   0 2 1
   -6 5 2] %a nonsingular matrix
b = [13
   7
   10] %a right hand vector
[xp,Xh,resid] = linearEquations(A,b) %solution of the system of linear equations

%%
% Since the |Xh = []|, the solution is unique, and since |resid = 0|, the
% solution is exact.
%
% Now let's add one more equation that is the first plus the third:

A(4,:) = A(1,:) + A(3,:)
b(4,:) = b(1,:) + b(3,:)
[xp,Xh,resid] = linearEquations(A,b) %solution of the system of linear equations

%%
% In this case the solution is the same, and it is exact, even though the matrix is not
% square.  Here |resid| is non-zero due to round-off error.
%
% However, if we change |b|, then we will not have an exact solution:

b(3) = 20
[xp,Xh,resid] = linearEquations(A,b) %solution of the system of linear equations

%%
% Now let's turn |A| around so that we have more unknowns than equations:

A = A' %take the transpose
b = b(1:3) %now b can only have three rows
[xp,Xh,resid] = linearEquations(A,b) %solution of the system of linear equations

%%
% Since the number of unknowns is greater than the number of equations, we
% have infinitely many solutions.
%
% Next, let's change the third row of |A| to be the sum of its first two
% rows

A(3,:) = A(1,:) + A(2,:)
[xp,Xh,resid] = linearEquations(A,b) %solution of the system of linear equations

%%
% Since the third row of |b| is also the sum of its first two rows, the
% solution is exact, and now the solution has an even higher dimension
% because |Xh| has two columns.  Note the warning that |A| is not of full
% rank.  It only has _two_ linearly independent rows/columns.
%
% However, if we change the third row of |b|, the solution will become
% approximate, even though it is non-unique.

b(3) = 23
[xp,Xh,resid] = linearEquations(A,b) %solution of the system of linear equations

%%
% _Author: Fred J. Hickernell_