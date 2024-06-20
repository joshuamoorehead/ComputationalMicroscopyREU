function Carbon(p,a,n,m)
% p=rand(2,1); [u,v,w] = Carbon(p,a,n,m);

x=zeros(2*n+1);
y=zeros(2*n+1);
z=zeros(2*n+1);
c=cos((2*p(1)-1)*pi/3);
s=sin((2*p(1)-1)*pi/3);
q=p(2);

x0=[-n:n]'*a;
for j=-n:n
    x(:,j+n+1)=x0+0.5*j*a;
    y(:,j+n+1)=0.5*j*a*sqrt(3);
end
x1=x+0.5*a;
y1=y+0.5*a/sqrt(3);
x2=x;
y2=y+a/sqrt(3);

figure(2); plot(x,y,'.r',MarkerSize=15)%x1,y1,'.b',x2,y2,'.g')
zz=ones(2*n+1);
figure(3); plot3(x,y,0*zz,'.g',x1,y1,0*zz,'.k',x,y,1*zz,'.g',x2,y2,1*zz,'.r',x1,y1,2*zz,'.k',x2,y2,2*zz,'.r',x,y,3*zz,'.g',x1,y1,3*zz,'.k',MarkerSize=15)
hold on
plot3([x(:),x(:)]',[y(:),y(:)]',[0;1]*zz(:)','-c')
plot3([x2(:),x2(:)]',[y2(:),y2(:)]',[1;2]*zz(:)','-m')
plot3([x1(:),x1(:)]',[y1(:),y1(:)]',[2;3]*zz(:)','-b')
plot3([x(:),x(:)+0.5*a]',[y(:),y(:)+0.5*a/sqrt(3)]',[0;0]*zz(:)','-r')
plot3([x(:),x(:)-0.5*a]',[y(:),y(:)+0.5*a/sqrt(3)]',[0;0]*zz(:)','-r')
plot3([x(:),x(:)]',[y(:),y(:)-a/sqrt(3)]',[0;0]*zz(:)','-r')
plot3(x,y,-3*zz,'.g',x1,y1,-3*zz,'.k',x,y,-2*zz,'.g',x2,y2,-2*zz,'.r',x1,y1,-1*zz,'.k',x2,y2,-1*zz,'.r',MarkerSize=15)
plot3([x(:),x(:)]',[y(:),y(:)]',[-3;-2]*zz(:)','-c')
plot3([x2(:),x2(:)]',[y2(:),y2(:)]',[-2;-1]*zz(:)','-m')
plot3([x1(:),x1(:)]',[y1(:),y1(:)]',[-1;0]*zz(:)','-b')
plot3(2*[-n;n],[0;0],[0;0],'k-',[0;0],2*[-n;n],[0;0],'k-',LineWidth=1)
plot3(2*c*[-n;n],2*s*[-n;n],[0;0],'m:',-2*s*[-n;n],2*c*[-n;n],[0;0],'m:',LineWidth=2)
plot3(2*[c*[-n:0.1:n]+s*n;c*[-n:0.1:n]-s*n],2*[s*[-n:0.1:n]-c*n;s*[-n:0.1:n]+c*n],2*q*[-n;n]*ones(1,20*n+1),'m:',LineWidth=2)
plot3([x(2,3);x(2,3)],[y(2,3);y(2,3)],[-m;m],'b-',LineWidth=3)
%plot3(-2*s*[[-n:n];[-n:n]],2*c*[[-n:n];[-n:n]],[1*[-n:n];q*[-n:n]],'k-',LineWidth=2)
%plot3([[-n;n]*a,[0;0]],[[0;0],[-n;n]*a],zeros(2),'k',x(:),y(:),z(:),'og',x(:),0.5*a+y(:),z(:),'.b',0.5*a+x(:),sqrt(1/12)*a+y(:),z(:),'.r')
hold off


        z=q*(c*x+s*y);
        zi=floor(z);


%figure(1); plot3([[-n;n]*a,[0;0]],[[0;0],[-n;n]*a],zeros(2),'k',x(:),y(:),z(:),'og',x(:),0.5*a+y(:),z(:),'.b',0.5*a+x(:),sqrt(1/12)*a+y(:),z(:),'.r')
%figure(1); plot3([[-n;n]*a,[0;0]],[[0;0],[-n;n]*a],zeros(2),'k',[0;c*n],[0;s*n],[0,q*m],'m',x(:),y(:),z(:),'.g',x(:),y(:),zi(:),'or')

return