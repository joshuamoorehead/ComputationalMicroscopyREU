res=256;           % size of the image (default 256 x 256)
type = 5;         % types - 1: simple cubic , 2: body centered cubic , 3: face centered cubic  , 4: hexagonal 
%spread = 9+type^2; % need a new formula
spread = 14;
a1=rand(1,3); a2=rand(1,3);         % coefficients for the patterns. Angles for projection
%a1 = [.0617 , .6401 , .9943];
%a2 = [.0617 , .6401 , .9943];

%aquire coordinates for where both patterns are placed
[XcoordsPattern1,YcoordsPattern1,d1] = AtomP(a1,type,spread); % first pattern
[XcoordsPattern2,YcoordsPattern2,d2] = AtomP(a2,type,spread); % second pattern

%create partition
n=res+4*spread; m=n-1; s=floor(n/2); boundrywidth=3; % 3 for type 1-3 , lower for case 4 
c=2*rand(10,1)-1;% coefficients for the partition
n=res+4*spread; m=n-1; s=floor(n/2); boundrywidth=3; 
% c=2*rand(10,1)-1;% coefficients for the partition

%pattern map (1 for pattern 1, 0 for boundry line, -1 for pattern 2)
[patternMap]=sets(c,m,boundrywidth); bi=2*spread+[1:res]-1; reducedPatternMap=patternMap(bi,bi); 
figure(10); imagesc(reducedPatternMap); colorbar
[u,v,d]=SetPoints(XcoordsPattern1,YcoordsPattern1,d1,spread,s,patternMap);
[u0,v0,d0]=SetPoints(XcoordsPattern2,YcoordsPattern2,d2,spread,s,-patternMap);
figure(2); plot(u*spread,v*spread,'r.',u0*spread,v0*spread,'b.')
XcoordsPattern1=[u;u0]; YcoordsPattern1=[v;v0]; d1=[d;d0];
[aa]=DataSim(s,XcoordsPattern1,YcoordsPattern1,d1,spread,type);
