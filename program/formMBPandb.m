function [MBP, b] = formMBPandb(p)

% p=getParams();
EBVx = zeros(p.NV, 1);
EBVy = zeros(p.NV, 1);
EBV = zeros(p.NV*2,1);
bx = zeros(p.NV, 1);
by = zeros(p.NV, 1);
b = zeros(p.NV*2, 1);


idx = (p.gridX==1);
EBVx(idx)=1;
bx(idx)=-1;

idx = (p.gridX==p.X);
EBVx(idx)=1;
bx(idx)=-p.X;

idx = (p.gridY==1);
EBVy(idx)=1;
by(idx)=-1;

idx = (p.gridY==p.Y);
EBVy(idx)=1;
by(idx)=-p.Y;

EBV(p.k*2-1)=EBVx;
EBV(p.k*2)=EBVy;
MBP = diag(EBV);
b(p.k*2-1)=bx;
b(p.k*2)=by;


