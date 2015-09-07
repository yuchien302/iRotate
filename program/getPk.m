function [Pk, PkV, Pk1, Pk2] = getPk(p, lines)
%     p = getParams();
    vertexX = p.vertexX;
    vertexY = p.vertexY;
    dx = p.dx;
    dy = p.dy;
    NV = (p.cx+1)*(p.cy+1);
    Pk = sparse(size(lines, 1), NV);
    PkV = sparse(size(lines, 1), NV);
    Pk1 = sparse(size(lines, 1), NV);
    Pk2 = sparse(size(lines, 1), NV);
    
    for k=1:size(lines, 1)
        x1 = lines(k, 1);
        y1 = lines(k, 2);
        x2 = lines(k, 3);
        y2 = lines(k, 4);
        
        xmin = min(x1, x2);
        ymin = min(y1, y2);
        
        xleft = floor((xmin-1)/dx)+1;
        xright = xleft+1;
        ytop = floor((ymin-1)/dy)+1;
        ybottom = ytop+1;
        
        PkMatrix1 = sparse(p.cy+1, p.cx+1);
        PkMatrix2 = sparse(p.cy+1, p.cx+1);
        PkMatrixV = sparse(p.cy+1, p.cx+1);
        
        PkMatrix1(ytop, xleft) = ((vertexX(xright)-x1)/dx) * ((vertexY(ybottom)-y1)/dy);
        PkMatrix1(ytop, xright) = ((x1-vertexX(xleft))/dx) * ((vertexY(ybottom)-y1)/dy);
        PkMatrix1(ybottom, xleft) = ((vertexX(xright)-x1)/dx) * ((y1-vertexY(ytop))/dy);
        PkMatrix1(ybottom, xright) = ((x1-vertexX(xleft))/dx) * ((y1-vertexY(ytop))/dy);

        PkMatrix2(ytop, xleft) = ((vertexX(xright)-x2)/dx) * ((vertexY(ybottom)-y2)/dy);
        PkMatrix2(ytop, xright) = ((x2-vertexX(xleft))/dx) * ((vertexY(ybottom)-y2)/dy);
        PkMatrix2(ybottom, xleft) = ((vertexX(xright)-x2)/dx) * ((y2-vertexY(ytop))/dy);
        PkMatrix2(ybottom, xright) = ((x2-vertexX(xleft))/dx) * ((y2-vertexY(ytop))/dy);
        
        PkMatrixV(ytop, xleft)=1;
        PkMatrixV(ytop, xright)=1;
        PkMatrixV(ybottom, xleft)=1;
        PkMatrixV(ybottom, xright)=1;
        
        Pk(k, :) = reshape(PkMatrix2-PkMatrix1, 1, NV);
        PkV(k, :) = reshape(PkMatrixV, 1, NV);
        Pk1(k, :) = reshape(PkMatrix1, 1, NV);
        Pk2(k, :) = reshape(PkMatrix2, 1, NV);
    end

