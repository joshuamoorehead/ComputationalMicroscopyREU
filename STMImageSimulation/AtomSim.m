% USER INPUTS
type = 5;  % choose type 1 - 5 , 1 = simple cubic , 2 = body centered cubic , 3 = face centered cubic , 4 = hexagonal , 5 = ???
numberofimages = 1;  
patterns = 1;  % 1 for autoencoder training, 2 for training segmentation routines

% PROGRAM 
res = 256;
switch type
    case 1 
        spread = 10;
    case 2 
        spread = 13;
    case 3 
        spread = 18;
    case 4 
        spread = 14;
    case 5 
        spread = 10;
end
switch patterns
    case 1
        for i = 1:numberofimages
        a1=rand(1,3);
        [Xcoords,Ycoords,d1] = AtomP(a1,type,spread);
        n=res+4*spread; s = floor(n/2); 
        [patternMap] = ones(n-1);
        [u,v,d]=SetPoints(Xcoords,Ycoords,d1,spread,s,patternMap);
        Xcoords = u;
        Ycoords = v;
        d1 = d;
        [aa]=DataSim(s,Xcoords,Ycoords,d1,spread,type); 
        hold on
        end
    case 2 
        for i = 1:numberofimages
        a1=rand(1,3); a2=rand(1,3);
        [Xcoords,Ycoords,d1] = AtomP(a1,type,spread); % first pattern
        [Xcoords2,Ycoords2,d2] = AtomP(a2,type,spread); % second pattern

        n=res+4*spread; m=n-1; s=floor(n/2); boundrywidth=3; % 3 for type 1-3 , lower for case 4 
        c=2*rand(10,1)-1;

        [patternMap]=sets(c,m,boundrywidth); %bi=2*spread+[1:res]-1; reducedPatternMap=patternMap(bi,bi); 
        [u,v,d]=SetPoints(Xcoords,Ycoords,d1,spread,s,patternMap);
        [u0,v0,d0]=SetPoints(Xcoords2,Ycoords2,d2,spread,s,-patternMap);
        Xcoords=[u;u0]; Ycoords=[v;v0]; d1=[d;d0];
        [aa]=DataSim(s,Xcoords,Ycoords,d1,spread,type);
        hold on
        end
end
