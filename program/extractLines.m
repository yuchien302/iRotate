function lines = extractLines(p, visualizeMode)

% visualizeMode = p.cmdinterface;
% p = getParams();
%% read Image
% filepath = ['.' filesep 'images' filesep 'fig1.png'];
% I = imread(filepath);
if(visualizeMode)
    imshow(p.I);
    hold on;
end


%% read Line File
linefilepath = [p.filepath '.txt'];
fileID = fopen(linefilepath);
L = textscan(fileID,'%f %f %f %f %f %f %f');
fclose(fileID);


%% meshgrid setting

% size per grid
dx = p.dx;
dy = p.dy;

%%

% initialize lines result
lines = []; linesCount = 0;


for i=1:length(L{1})

    % x1, y1, x2, y2, width, p, -log_nfa
    x1 = L{1}(i)+1; y1 = L{2}(i)+1; 
    x2 = L{3}(i)+1; y2 = L{4}(i)+1;
    if( max(x1, x2) > p.X || max(y1, y2) > p.Y || min([x1, x2, y1, y2]) < 1)
        continue;
    end
    if((x1-x2)^2+(y1-y2)^2 < p.lineThreshold)
        continue;
    end

    if(x1>x2)
        xright = x1;
        xleft = x2;
    else
        xright = x2;
        xleft = x1;
    end
    if(y1>y2)
        ytop = y2;
        ybottom = y1;
    else
        ytop = y1;
        ybottom = y2;
    end
    
    if(visualizeMode)
        line([L{1}(i)+1, L{3}(i)+1], [L{2}(i)+1, L{4}(i)+1], 'color','b','LineWidth',2); 
    end
    
%     plot(L{1}(i), L{2}(i), 'ro');
    
    
    xi = [x1, x2];
    yi = [y1, y2];
    icount = 2;
    for j=ceil((xleft-1)/dx)*dx+1:dx:floor((xright-1)/dx)*dx+1
        icount = icount+1;
        [xi(icount), yi(icount)] = polyxpoly([x1, x2], [y1, y2], [j, j], [0, p.Y]);
        
        if(visualizeMode)
%             plot(xi, yi, 'ro');
        end
    end
    for j=ceil((ytop-1)/dy)*dy+1:dy:floor((ybottom-1)/dy)*dy+1
        icount = icount+1;
        [xi(icount), yi(icount)] = polyxpoly([x1, x2], [y1, y2], [0, p.X], [j, j]);
        if(visualizeMode)
%             plot(xi, yi, 'ro');
        end
    end
    [sortedYi , idx]= sort(yi);
    sortedXi = xi(idx);
    for j=1:length(sortedYi)-1
        if((sortedXi(j)-sortedXi(j+1))^2+(sortedYi(j)-sortedYi(j+1))^2 < p.lineSegThreshold)
            continue;
        end
        linesCount = linesCount+1;
        lines(linesCount, 1) = sortedXi(j); %x1
        lines(linesCount, 2) = sortedYi(j); %y1
        lines(linesCount, 3) = sortedXi(j+1); %x2
        lines(linesCount, 4) = sortedYi(j+1); %y2
        lines(linesCount, 5) = atan2(lines(linesCount, 4) - lines(linesCount, 2), lines(linesCount, 3)-lines(linesCount, 1))*180/pi;
        lines(linesCount, 6) = ceil( (lines(linesCount, 5)+p.delta)/(180/p.M) );
        if lines(linesCount, 6)<=0
            lines(linesCount, 6) = lines(linesCount, 6) + 90;
        end
        if lines(linesCount, 6)>90
            lines(linesCount, 6) = lines(linesCount, 6)-90;
        end
    end
    
    

%     hold off;
    
end
if(visualizeMode)
    plot(p.gridX, p.gridY, 'yx');
    for i=1:linesCount
        line([lines(i, 1), lines(i, 3)], [lines(i, 2), lines(i, 4)], 'Color','y', 'LineWidth', 2) ;
%         plot(lines(i, 1), lines(i, 2), 'ro');
        
    end
    hold off;
end
