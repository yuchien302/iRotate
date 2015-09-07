function Etotal = caculateTotalEnergy(p, V, thetas, lines)

%     p=getParams();
    
    %% EL
    EL = 0;
    [Pk, ~, ~, ~] = getPk(p, lines);
    tempPk1 = zeros(1, p.NV*2);
    tempPk2 = zeros(1, p.NV*2);
    uk = getuk(lines);
    ek = getuk(lines);
    for k=1:size(lines, 1)

        Uk = uk(k, :)'*pinv(uk(k, :)*uk(k, :)')*uk(k, :);

        theta = thetas(lines(k, 6))*pi/180;
        Rk = [cos(theta), -sin(theta);
              sin(theta), cos(theta)];
          
        tempPk1(p.k*2-1) = Pk(k, :);
        tempPk2(p.k*2) = Pk(k, :);
        


        tempML = (Rk*Uk*Rk'-eye(2))*ek(k, :)'; 
        EL = EL + tempML'*tempML;
    end
    EL = EL/size(lines, 1);

    %% ES
   
    ES = 0;

    for i=1:p.cy
        for j=1:p.cx
            % every quad
            Aq = [p.vertexX(j), -p.vertexY(i), 1, 0;
                  p.vertexY(i),  p.vertexX(j), 0, 1;
                  p.vertexX(j), -p.vertexY(i+1), 1, 0;
                  p.vertexY(i+1),  p.vertexX(j), 0, 1;
                  p.vertexX(j+1), -p.vertexY(i), 1, 0;
                  p.vertexY(i),  p.vertexX(j+1), 0, 1;
                  p.vertexX(j+1), -p.vertexY(i+1), 1, 0;
                  p.vertexY(i+1),  p.vertexX(j+1), 0, 1;
                ];

            Q = zeros(8, p.NV*2);
            Q(1, 2*( (j-1)*(p.cy+1)+i ) -1) = 1;
            Q(2, 2*( (j-1)*(p.cy+1)+i )   ) = 1;
            Q(3, 2*( (j-1)*(p.cy+1)+i ) +1) = 1;
            Q(4, 2*( (j-1)*(p.cy+1)+i ) +2) = 1;
            Q(5, 2*( (j)*(p.cy+1)+i ) -1) = 1;
            Q(6, 2*( (j)*(p.cy+1)+i )   ) = 1;
            Q(7, 2*( (j)*(p.cy+1)+i ) +1) = 1;
            Q(8, 2*( (j)*(p.cy+1)+i ) +2) = 1;

            Vq = Aq(:,1);
            S = (Aq*pinv(Aq'*Aq)*Aq'-eye(8))*Vq;
            ES=ES + S'*S;
        end
    end
    ES = ES/p.NV;
    
    %% EB
    EB = 0;
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

    EB = EB + (MBP*V+b)'*(MBP*V+b);
    
    
    %% ER
    deltam = zeros(1, p.M);
    deltam(1) = 10^3;
    deltam(90) = 10^3;
    deltam(45) = 10^3;
    deltam(46) = 10^3;
    ER = deltam*((thetas-p.delta).^2) + diff(thetas)'*diff(thetas) + (thetas(end)-thetas(1)).^2;
    
    
    Etotal = ES + p.lambdaB*EB + p.lambdaL*EL + p.lambdaR*ER;
    if(p.debugMessage) 
        disp(['[ES] ', num2str(ES) ]);
        disp(['[EB] ', num2str(EB) ]);
        disp(['[EL] ', num2str(EL) ]);
        disp(['[ER] ', num2str(ER) ]);
        disp(['[Total Energy] ', num2str(Etotal) ]);
    end
    
    
    
    
end