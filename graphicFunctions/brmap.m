% 
nc=5; 
coler=zeros(nc,3); 
coler(1,1:3)=[1. 0. 0.]; 
coler(2,1:3)=[.7 0. 0.];
coler(3,1:3)=[1  1. 1.];
coler(4,1:3)=[0  0. .7];
coler(5,1:3)=[0. 0. 1.]; 

npl = ceil(64/(nc-1));
nseg=nc-1; 
cc=zeros(64,3); 
cc(1,1:3)=coler(1,1:3); 
for ns=1:nseg
    n1=(ns-1)*npl+1; 
    n2=n1+npl-1; 
for l=n1:n2 
    brc(l,1:3)=coler(ns,1:3)+((l-n1)*(coler(ns+1,1:3)-coler(ns,1:3))/(npl)); 
end 
end 
