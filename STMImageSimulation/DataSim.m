function [aa]=DataSim(s,u1,v1,d,sp,type)

res=256;
n=res+sp*4; 
k=n+2*sp;
dd=2;
cc=0.37;      %Gaussian Parameter (Default 0.15)
sz=sp^2/64/type;
brt1b=0.7;    %threshhold value of curent background for including an atom

% colormap for the noise images
% cmg=ones(256,3); cmg(1:128,1)=[0:127]/128; cmg(1:128,2)=[0:127]/128;
% cmg(129:256,2)=[127:-1:0]/128; cmg(129:256,3)=[127:-1:0]/128;

% NOISE PARAMETERS
atom_vary=0.2/15; %Perturbation amount to atom position (0-1); 0 to turn off
brt_vary=.9/20;   %Perturbation amount to atom brightness (0-1); 0 to turn off
PNI=3.5;       %Poisson Noise Strength (default 3)
GNI=.3;        %Guassian Noise Strength (default 1)
StriS=.3;      %Strength of Striations (default 1)

nn=length(u1);
        ju1=floor(sp*u1);
        jv1=floor(sp*v1);

u=u1+atom_vary*randn(nn,1); %adding small variation in x
v=v1+atom_vary*randn(nn,1); %adding small variation in y 


delta=brt_vary*(randn(1)); %small delta to vary brightness of each atom
if type==2
   delta = abs(brt_vary*(randn(1))/20);
end
    
        P=zeros(k);       %noisy image  
        P1=zeros(k);      %image without noise
        for l=1:nn  
            ku=ju1(l)+s; kv=jv1(l)+s;
            zx=([-sp:sp-1]+sp*u1(l)-ju1(l))'*ones(1,sp*2);
            zy=ones(sp*2,1)*([-sp:sp-1]+sp*v1(l)-jv1(l));
            R1=4*((dd-d(l))/2)^1.5*exp(-cc*(zx.^2+zy.^2)/((dd-d(l))^0.5)/sz);
            if ku > 0 && kv > 0 && ku + sp*2 - 1 <= k && kv + sp*2 - 1 <= k
             PP1 = P1(ku+[0:sp*2-1], kv+[0:sp*2-1]);
          % Proceed with other operations
                else
           warning('Calculated indices are out of bounds for P1. ku=%d, kv=%d, k=%d', ku, kv, k);
             end
           % PP1=P1(ku+[0:sp*2-1],kv+[0:sp*2-1]);

            %brightness/position variations
            zx=([-sp:sp-1]+sp*u(l)-ju1(l))'*ones(1,sp*2);
            zy=ones(sp*2,1)*([-sp:sp-1]+sp*v(l)-jv1(l));
            R=4*((dd-d(l))/2)^1.5*exp(-cc*(zx.^2+zy.^2)/((dd-d(l))^0.5+delta)/sz);
            PP=P(ku+[0:sp*2-1],kv+[0:sp*2-1]);



                if PP1(sp,sp)<brt1b
                     P(ku+[0:sp*2-1],kv+[0:sp*2-1])=R+PP;
                     P1(ku+[0:sp*2-1],kv+[0:sp*2-1])=R1+PP1;
                end
        end


       
    
        P0F=P1([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);    %image without noise, small variations to position or brightness, non-adjusted grayscale
        aamin=min(P0F(:)); aamax=max(P0F(:)); 
        aa=(P0F-aamin)/(aamax-aamin);
%        nam=[fname,num2str(num),'clear.png'];
%        imwrite(aa,nam)
    
        %figure(11); imagesc(P0F); colormap(gray); axis off; colorbar
        % nam=[fname,num2str(num),'clear.png'];
        % saveas(gcf,nam)
     P7=P0F;
    
        P0F=P([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);     %image without noise but with small variations to position or brightness
    %    figure(12); imagesc(P0F); colormap(gray); axis off; 
    %    nam=[fname,num2str(num),'b.png'];
    %    saveas(gcf,nam)
     
     P7=P7-P0F;
     %figure(17); imagesc(P7); colormap(cmg); axis off;  clim([-1 1])  %image showing brightness/position variations 
    
        xx=ones(2*k+1,1)*[-k/2:0.5:k/2]; 
        yy=[-k/2:0.5:k/2]'*ones(1,2*k+1); 
        ys=-sin(rand(1)*pi/sz)*xx+cos(rand(1)*pi/sz)*yy;
%        ys=-sin(rand(1)*pi/sz)*xx+cos(rand(1)*pi/sz)*yy;
    
        GaussN =GNI*(max(max(P))/8*randn(k));                         %Gaussian Noise
        PoissonN = PNI*(P.^.5).*(.025*(randn(k)));                    %Poisson Noise
        striN=(cos(ys([152:152+k-1],[152:152+k-1])*pi/3)+.5)/2*StriS; %creates striations for noise
        
        PF=GaussN; 
        P0F=PF([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);
    %figure(14); imagesc(P0F); colormap(cmg); axis off;  clim([-1 1])  %image showing Gaussian noise component 
        PF=PoissonN; 
        P0F=PF([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);
   % figure(15); imagesc(P0F); colormap(cmg); axis off;  clim([-1 1])  %image showing Poisson noise component 
        PF=striN; 
        P0F=PF([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);
    %figure(16); imagesc(P0F); colormap(cmg); axis off;  clim([-1 1])  %image showing striation noise component 
        PF=GaussN+PoissonN+striN;%                                    % Image of all noises added
        P0F=PF([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);
    %figure(18); imagesc(P0F+P7); colormap(cmg); axis off; colorbar; clim([-1 1]) %clim([-1.1 1.1])  %image showing striation noise component 


        PF=P+GaussN+PoissonN+striN;%                                  % Image with all added noises
        P0F=PF([k/2-res/2:k/2+res/2],[k/2-res/2:k/2+res/2]);
     figure(); imagesc(P0F); colormap(gray); axis off; colorbar; clim([0 aamax])
        aamin=min(P0F(:)); aamax=max(P0F(:)); 
        aa=(P0F-aamin)/(aamax-aamin);
%        nam=[fname,num2str(num),'noise.png'];
%        imwrite(aa,nam)
    %    saveas(gcf,nam); 
