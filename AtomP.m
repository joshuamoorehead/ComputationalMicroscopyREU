function [u1,v1,d] = AtomP(a0,type,spread)
% type = 1; spread= 10; a0=rand(1,3); [u1,v1,sp] = AtomP(a0,type,spread);
% type :  1 for Simple Cubic, 2 for BCC, and 3 for FCC

dd=2;         %Gaussian Parameter (Default 2)
res=256;      %End image dimensions (eg: 256x256 -> 256)

n=res+spread*4; 
k=n+2*spread;

c=cos(a0(1)*pi/4);
s=sin(a0(1)*pi/4);
q=tan(a0(2)*pi/4);
sq=sqrt(1+q^2);
rho=[c;s;q]/sq;

d=zeros((2*k+1)^2,1);
switch type
    case 1
        xx=ones(2*k+1,1)*[-k:k];%x coord within mesh 
        x=xx(:);%
        yy=[-k:k]'*ones(1,2*k+1); 
        y=yy(:);
        z=q*(c*x+s*y);
        zi=floor(z);

    case 2
        xx=ones(2*k+1,1)*[-k/2:0.5:k/2]; 
        x=xx(:);
        yy=[-k/2:0.5:k/2]'*ones(1,2*k+1); 
        y=yy(:);
        z=q*(c*x+s*y);
        zi=zeros((2*k+1)^2,1);
        for i=1:2*k+1
            for j=1:2*k+1
                ij=(2*k+1)*(i-1)+j;
                if mod(i,2)~=0 && mod(j,2)~=0
                    zi(ij)=floor(z(ij));
                    d(ij)=z(ij)-zi(ij);
                elseif mod(i,2)==0 && mod(j,2)==0 %cubic points
                        if (z(ij)-floor(z(ij)))<0.5
                            zi(ij)=floor(z(ij))-0.5;
                            d(ij)=(z(ij)-zi(ij))/sq;
                        else %middle point
                            zi(ij)=floor(z(ij))+0.5;
                            d(ij)=(z(ij)-zi(ij))/sq;
                        end
                else %not matching
                        d(ij)=dd-0.001; %off point
                end
            end
        end

    case 3
        xx=ones(2*k+1,1)*[-k/2:0.5:k/2]; 
        x=xx(:);
        yy=[-k/2:0.5:k/2]'*ones(1,2*k+1); 
        y=yy(:);
        z=q*(c*x+s*y);
        zi=zeros((2*k+1)^2,1);
        for i=1:2*k+1
            for j=1:2*k+1
                ij=(2*k+1)*(i-1)+j;
                if mod(i,2)~=0 && mod(j,2)~=0 ||mod(i,2)==0 && mod(j,2)==0
                    zi(ij)=floor(z(ij));
                    d(ij)=z(ij)-zi(ij);
                else
                        if (z(ij)-floor(z(ij)))<0.5
                             zi(ij)=floor(z(ij))-0.5;
                        else
                            zi(ij)=floor(z(ij))+0.5;
                        end 
                        d(ij)=(z(ij)-zi(ij))/sq;
                end
            end
        end
end

uu=rho(1)*x+rho(2)*y+rho(3)*zi; %The projected x  
vv=-s*x+c*y;                    %The projected y
c3=cos(a0(3)*pi);
s3=sin(a0(3)*pi);
u1=c3*uu+s3*vv;
v1=-s3*uu+c3*vv;

return