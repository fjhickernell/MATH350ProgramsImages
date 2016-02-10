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
% where \(\mathsf{U}\) is an \(m \times m\) matrix satisfying
% \(\mathsf{U}^{-1} = \mathsf{U}^T\).  This means that the columns of
% \(\mathsf{U}\) are orthonormal.  Moreover, \(\mathsf{V}\) is an \(n
% \times n\) matrix satisfying \(\mathsf{V}^{-1} = \mathsf{V}^T\), and
% \(\mathsf{S}\) is an \(m \times n\) diagonal matrix with all non-negative
% elements, and the first \(p\) diagonal elements being non-zero. Note that
% \[ p \le \min(m,n). \] Thus,
%
% \begin{gather*} \mathsf{A}\boldsymbol{x} = \boldsymbol{b} \iff \mathsf{U}
% \mathsf{S} \mathsf{V}^T\boldsymbol{x} = \boldsymbol{b} \\ \iff \mathsf{S}
% \boldsymbol{y} = \boldsymbol{c} = \mathsf{U}^T \boldsymbol{b},\quad
% \boldsymbol{x} = \mathsf{V} \boldsymbol{y} \end{gather*}
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
% If \(p = n\), then the solution, \(\boldsymbol{x}\) is unique.  If \(p <
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
% \boldsymbol{c}\bigr) = \mathsf{U} \begin{pmatrix} 0 \\ \vdots \\ 0 \\
% c_{p+1} \\ \vdots \\ c_m \end{pmatrix} = \begin{pmatrix}
% \underbrace{\mathsf{U}_{\textrm{L}}}_{m \times p} &
% \underbrace{\mathsf{U}_{\textrm{R}}}_{m \times m-p} \end{pmatrix}
% \begin{pmatrix} \boldsymbol{0} \\ \boldsymbol{c}_{\textrm{L}}
% \end{pmatrix} = \mathsf{U}_{\textrm{R}} \boldsymbol{c}_{\textrm{L}},\]
%
% where \(\boldsymbol{c}_{\textrm{L}} = \mathsf{U}_{\textrm{R}}^T
% \boldsymbol{b}\).  Then the lack of fit is measured as 
%
% \[ \lVert \mathsf{A} \boldsymbol{x} - \boldsymbol{b} \rVert = \lVert
% \mathsf{U}_{\textrm{R}} \boldsymbol{c}_{\textrm{L}} \rVert = \sqrt{
% \boldsymbol{c}_{\textrm{L}}^T \mathsf{U}_{\textrm{R}}^T
% \mathsf{U}_{\textrm{R}} \boldsymbol{c}_{\textrm{L}}} = \sqrt{
% \boldsymbol{c}_{\textrm{L}}^T \boldsymbol{c}_{\textrm{L}}} = \lVert
% \boldsymbol{\boldsymbol{c}_{\textrm{L}}} \rVert= \lVert
% \mathsf{U}_{\textrm{R}}^T \boldsymbol{b} \rVert.\]
%
% If \(\boldsymbol{c}_{\textrm{L}} = \mathsf{U}_{\textrm{R}}^T
% \boldsymbol{b} = \boldsymbol{0} \), then \(\boldsymbol{x}\) is an exact
% solution. Otherwise, \(\boldsymbol{x}\) is an approximate solution.


%% Examples

InitializeWorkspaceDisplay %initialize the workspace and the display parameters

%%
% _Author: Fred J. Hickernell_