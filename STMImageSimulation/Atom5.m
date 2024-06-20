res=256;           % size of the image
type = 3;          % same type for both patterns
spread = 20; % can be changed to adjust the resolution
% a1=rand(1,3); a2=rand(1,3);         % coefficients for the patterns. Angles for projection
[u1,v1,d1] = AtomP(a1,type,spread); % first pattern
[u2,v2,d2] = AtomP(a2,type,spread); % second pattern
n=res+4*spread; m=n-1; s=floor(n/2); gap=3; %gap is the gap between the regions
% c=2*rand(10,1)-1;                   % coefficients for the partition
[bb]=sets(c,m,gap); bi=2*spread+[1:res]-1; bbb=bb(bi,bi); %% bb is 0, 1, -1 0 is boundary 1 is one pattern and -1 is the other pattern
figure(10); imagesc(bbb); colorbar
[u,v,d]=SetPoints(u1,v1,d1,spread,s,bb);
[u0,v0,d0]=SetPoints(u2,v2,d2,spread,s,-bb);
figure(2); plot(u*spread,v*spread,'r.',u0*spread,v0*spread,'b.')
u1=[u;u0]; v1=[v;v0]; d1=[d;d0];
[aa]=DataSim(s,u1,v1,d1,spread,type);
