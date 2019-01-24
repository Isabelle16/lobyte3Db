% 
nc=6; 
coler=zeros(nc,3); 
coler(1,1:3)=[0. .5 0.0]; 
coler(2,1:3)=[0 0.5 0.2];
coler(3,1:3)=[.7 .7 .4]; 
coler(4,1:3)=[.7 .5 .2];
coler(5,1:3)=[0.3 .3 0.]; 
coler(6,1:3)=[.5 .2 0.];
coler(7,1:3)=[.7 .0 .8];
coler(8,1:3)=[.5 0. .3]; 
npl = ceil(64/(nc-1));
nseg=nc-1; 
cc=zeros(64,3); 
cc(1,1:3)=coler(1,1:3); 
for ns=1:nseg
    n1=(ns-1)*npl+1; 
    n2=n1+npl-1; 
for l=n1:n2 
    cc(l,1:3)=coler(ns,1:3)+((l-n1)*(coler(ns+1,1:3)-coler(ns,1:3))/(npl)); 
end 
end 
l1=[1:1:64]; 
l2=l1'*l1; 
figure(3); 
clf; 
imagesc(l2.^0.5); 
colormap(cc); 