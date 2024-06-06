function [u,v,d]=SetPoints(u1,v1,d1,sp,s,bb)
%    [u,v]=SetPoints(u1,v1,sp1,s,bb);
%    [u0,v0]=SetPoints(u2,v2,sp2,s,-bb);
%    u=[u;u0]; v=[v;v0];
%    using an array of 2D real points (u1,v1) selects the ones for which 
%    the rounded to integers coordinates x=u1*sp and y=v1*sp are in (-s,s) 
%    and bb(x,y)>0 
nn=length(u1);
ju1=floor(sp*u1);
jv1=floor(sp*v1);

u=zeros(nn,1); v=zeros(nn,1); d=zeros(nn,1);
m=0;
for l=1:nn
            if abs(ju1(l))<s && abs(jv1(l))<s
                ku=ju1(l)+s; kv=jv1(l)+s;
                if bb(ku,kv)>0
                    m=m+1;
                    u(m)=u1(l);
                    v(m)=v1(l);
                    d(m)=d1(l);
                end
            end
end
u=u(1:m);
v=v(1:m);
d=d(1:m);
return