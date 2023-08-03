%excise(X)

%updated 7 Jan 2005 to accomdate either matrices or vectors, MCV.


%function to remove NaN values from matrix X
%where X is two columns: 1) DOY 2)delta13C    
%by mcv 1/3/2002, from MatLab Help file


function ex=excise(X)
if min(size(X))==1
    X = X(~isnan(X));
else
X(any(isnan(X)'),:) = [];
end
ex=X;