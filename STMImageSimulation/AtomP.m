function [u1,v1,d] = AtomP(a0,type,spread)
% type = 1; spread= 10; a0=rand(1,3); [u1,v1,sp] = AtomP(a0,type,spread);
% type :  1 for Simple Cubic, 2 for BCC, and 3 for FCC

dd=2;         %Gaussian Parameter (Default 2)
res=256;      %End image dimensions (eg: 256x256 -> 256)

n=res+spread*4; 
k=n+2*spread;

co=cos(a0(1)*pi/4); % 0 - pi/4 covered, this shows max angle
si=sin(a0(1)*pi/4);
ta=tan(a0(2)*pi/4);
sq=sqrt(1+ta^2);
rho=[co;si;ta]/sq;

d=zeros((2*k+1)^2,1);
switch type
    case 1
        xx=ones(2*k+1,1)*[-k:k];%x coord within mesh 
        x=xx(:);
        yy=[-k:k]'*ones(1,2*k+1);  %transposed version of xx
        y=yy(:);
        z=ta*(co*x+si*y); 
        zint=floor(z);
        d = (z-zint)/sq;

        projX=rho(1)*x+rho(2)*y+rho(3)*z;   %The projected x  
        projY=-si*x+co*y;                    %The projected y plane
        c3=cos(a0(3)*pi);
        s3=sin(a0(3)*pi);
        u1=c3*projX+s3*projY;
        v1=-s3*projX+c3*projY;
        
    case 2
        xx=ones(2*k+1,1)*[-k/2:0.5:k/2]; 
        x=xx(:);
        yy=[-k/2:0.5:k/2]'*ones(1,2*k+1); 
        y=yy(:);
        z=ta*(co*x+si*y);
        zint=zeros((2*k+1)^2,1);
        for i=1:2*k+1
            for j=1:2*k+1
                ij=(2*k+1)*(i-1)+j;
                if mod(i,2)~=0 && mod(j,2)~=0
                    zint(ij)=floor(z(ij));
                    d(ij)=z(ij)-zint(ij);
                elseif mod(i,2)==0 && mod(j,2)==0 %cubic points
                        if (z(ij)-floor(z(ij)))<0.5
                            zint(ij)=floor(z(ij))-0.5;
                            d(ij)=(z(ij)-zint(ij))/sq;
                        else %middle point
                            zint(ij)=floor(z(ij))+0.5;
                            d(ij)=(z(ij)-zint(ij))/sq;
                        end
                else %not matching
                        d(ij)=dd-0.001; %off point
                end
            end
        end

        projX=rho(1)*x+rho(2)*y+rho(3)*z;   %The projected x  
        projY=-si*x+co*y;                    %The projected y plane
        c3=cos(a0(3)*pi);
        s3=sin(a0(3)*pi);
        u1=c3*projX+s3*projY;
        v1=-s3*projX+c3*projY;

    case 3
        xx=ones(2*k+1,1)*[-k/2:0.5:k/2]; 
        x=xx(:);
        yy=[-k/2:0.5:k/2]'*ones(1,2*k+1); 
        y=yy(:);
        z=ta*(co*x+si*y);
        zint=zeros((2*k+1)^2,1);
        for i=1:2*k+1
            for j=1:2*k+1
                ij=(2*k+1)*(i-1)+j;
                if mod(i,2)~=0 && mod(j,2)~=0 || mod(i,2)==0 && mod(j,2)==0
                    zint(ij)=floor(z(ij));
                        d(ij)=z(ij)-zint(ij);
                else
                        if (z(ij)-floor(z(ij)))<0.5
                             zint(ij)=floor(z(ij))-0.5;
                        else
                            zint(ij)=floor(z(ij))+0.5;
                        end 
                        d(ij)=(z(ij)-zint(ij))/sq;
                end
            end
        end
        projX=rho(1)*x+rho(2)*y+rho(3)*z;   %The projected x  
        projY=-si*x+co*y;                    %The projected y plane
        c3=cos(a0(3)*pi);
        s3=sin(a0(3)*pi);
        u1=c3*projX+s3*projY;
        v1=-s3*projX+c3*projY;

case 4
        co = cos(a0(1) * pi / 3);
        si = sin(a0(1) * pi / 3);
        ta = tan(a0(2) * pi / 6);  
        % Parameters
        a = 0.8;  % Base length of the triangle
        h = a / 2;  % Height of the triangle

        % Define the number of points in each dimension
        num_points = 2 * k + 1;

        % Preallocate arrays for 2D grid points
        x = zeros(num_points^2, 1); 
        y = zeros(num_points^2, 1); 

        % Generate 2D hexagonal grid points
        vertex_index = 1;
        for i = 1:num_points
            for j = 1:num_points
                x_offset = (j - 1 - k) * a;
                y_offset = (i - 1 - k) * h * 3 / 2;

                % Determine the offset based on the row and column parity
                if mod(i, 2) == 0  % Even row
                    x_offset = x_offset + a / 2;
                end
                % Store the vertex coordinates
                x(vertex_index) = x_offset;
                y(vertex_index) = y_offset;
                vertex_index = vertex_index + 1;
            end
        end   

        % Projection of the hexagonal grid
        z = ta * (co * x + si * y);
        %0 = si*x + ta*si*y - z rewritten z plane
        A = si;
        B = ta*si;
        C = -1;
        normal = [A;B;C];
        % loop through every y value
        % find distance at each 
      %vert = zeros(num_points^2, 1); 
      for mm=num_points
            for pp=num_points
                mp=(num_points)*(mm-1)+pp;

                PQ = [0;0;0] - [x(mp);y(mp);floor(z(mp))];
                proj = (dot(PQ,normal) / dot(normal,normal)) * normal;
                d(mp) = norm(proj);

            end
      end  
      projX=rho(1)*x+rho(2)*y+rho(3)*z;   %The projected x  
      projY=-si*x+co*y;                    %The projected y plane
      c3=cos(a0(3)*pi);
      s3=sin(a0(3)*pi);
      u1=c3*projX+s3*projY;
      v1=-s3*projX+c3*projY;
end
return