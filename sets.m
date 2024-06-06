function [bb]=sets(c,m,k)
% s=floor(n/2); m=2*s-1; k=4; c=2*rand(10,1)-1; [bb]=sets(c,m,k);
n=m-2*k;
f=zeros(n);
y=1.6*(2*[1:n]-1)/n-1;
x=y';
o1=ones(n,1);
f=o1*(c(1)*o1'/3+c(2)*y+c(3)*y.^2+c(4)*y.^3)+x*(c(5)*o1'+c(6)*y+c(7)*y.^2)+...
    (x.^2)*(c(8)*o1'+c(9)*y)+(x.^3)*c(10)*o1'; %+(x*y).^2;
b=(sign(f)+1)/2; 
kk=2*k+1;
k2=(kk/2)^2;
z=zeros(kk);
for j1=1:kk
    for j2=1:kk 
        if (j1-k-1)^2+(j2-k-1)^2<k2
            z(j1,j2)=1;
        end
    end
end
%figure(21); imagesc(z)
bb1=conv2(b,z)/sum(z(:));
bb2=conv2(1-b,z)/sum(z(:));
bb=round(bb1-bb2);
%figure(22); imagesc(bb); colorbar
%figure(23); imagesc(b); colorbar
return 