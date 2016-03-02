function yeval=barycentric(xnodes,ynodes,xeval)
% yeval=BARYCENTRIC(xnodes,ynodes,xeval) uses the barycentric 
% formula for polnomial interpolation given the function 
% values ynodes at the data sites xnodes.  The polynomial is 
% evaluated at xeval and the values yeval are returned
shape=size(xeval); %dimensions of xeval
xnodes=xnodes(:); %make sure that they are column vectors
ynodes=ynodes(:);
xeval=xeval(:); 
n=numel(xnodes); %number of nodes
xnminusxnmat=bsxfun(@minus,xnodes,xnodes'); %difference of node positions
xnminusxnmat(1:n+1:n^2)=ones(n,1); %make diagonal elements equal 1
scalewts=exp(-mean(mean(log(abs(xnminusxnmat)))));
xnminusxnmat=xnminusxnmat*scalewts;
weights=prod(sign(xnminusxnmat),2).*exp(-sum(log(abs(xnminusxnmat)),2)); 
   %take product over rows and then inverse, use logarithms
xdminusxnmat=bsxfun(@minus,xeval,xnodes'); %difference of node and evaluation point positions
[whdati,whdatj]=find(xdminusxnmat==0); %where an evaluation point coincides with a node
invxdminusxnmat=1./xdminusxnmat; 
yeval=(invxdminusxnmat*(ynodes.*weights))./(invxdminusxnmat*weights);
yeval(whdati)=ynodes(whdatj); %correct for where evaluation point coincides with node
yeval=reshape(yeval,shape); %correct the shape