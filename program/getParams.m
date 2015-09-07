function p = getParams(delta, filepath)
    if nargin < 2
        p.delta = -4;
        p.filepath = ['.' filesep 'images' filesep 'fig1.png'];
        
    else
        p.delta = delta;
        p.filepath = filepath;
        
    end


    
    %% debug
    p.debugMessage = true;
    
    p.lambdaB = 10^8;
    p.lambdaL = 100;
    p.lambdaR = 100;
    
    %% read Image
    
    p.I = imread(p.filepath);
    
    p.X = size(p.I, 2);
    p.Y = size(p.I, 1);    

    %% meshgrid setting
    % column number of meshgrid
    p.cx = floor(size(p.I,2)/30);
    p.cy = floor(size(p.I,1)/30);
    p.NV = (p.cx+1)*(p.cy+1);
    p.NQ = (p.cx)*(p.cy);
    
    % size per grid
    p.dx = (p.X-1)/p.cx;            
    p.dy = (p.Y-1)/p.cy;
    

    
    % vertex position
    p.vertexX = 1:p.dx:p.X;     
    p.vertexY = 1:p.dy:p.Y;
    [p.gridX, p.gridY] = meshgrid(p.vertexX, p.vertexY);
    p.Vx = reshape(p.gridX, p.NV, 1);
    p.Vy = reshape(p.gridY, p.NV, 1);
    
    p.k = 1:p.NV;
    p.V(2*p.k-1, 1) = p.Vx;
    p.V(2*p.k, 1) = p.Vy;

    %% line setting
    % processing line min length^2
    p.lineThreshold = 16;
%     p.lineThreshold = 6400;

    % final line segment min length^2
%     p.lineSegThreshold = (p.dx^2+p.dy^2)/4;
%     p.lineSegThreshold = (p.dx^2+p.dy^2)/64;
    p.lineSegThreshold = (p.dx^2+p.dy^2)/64;
    
    %%

    p.M=90;
    maxsdelta = 10^3;
    p.sdelta = zeros(p.M, 1);
    p.sdelta(1) = maxsdelta;
    p.sdelta(p.M) = maxsdelta;
    p.sdelta(p.M/2) = maxsdelta;
    p.sdelta(p.M/2+1) = maxsdelta;
    

end