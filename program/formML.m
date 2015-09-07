function [ML, C] = formML(p, C, lines, thetas)
%     p=getParams();
    
    ML = zeros(p.NV*2, p.NV*2);


    if(~isfield(C, 'U'))
        uk = getuk(lines);
        [Pk, ~, ~, ~] = getPk(p, lines);
        C.U = cell(1, size(lines, 1));
        tempPk1 = zeros(1, p.NV*2);
        tempPk2 = zeros(1, p.NV*2);
        for k=1:size(lines, 1)
            C.U{k} = uk(k, :)'*pinv(uk(k, :)*uk(k, :)')*uk(k, :);

            tempPk1(p.k*2-1) = Pk(k, :);
            tempPk2(p.k*2) = Pk(k, :);
            C.PK{k} = [tempPk1; tempPk2];
        end
    end
    
    for k=1:size(lines, 1)

        theta = thetas(lines(k, 6))*pi/180;
        Rk = [cos(theta), -sin(theta);
              sin(theta), cos(theta)];

%         Uk = uk(k, :)'*pinv(uk(k, :)*uk(k, :)')*uk(k, :);
%         tempML = (Rk*Uk*Rk'-eye(2))*([tempPk1; tempPk2]); 


        tempML = (Rk*C.U{k}*Rk'-eye(2))*C.PK{k}; 
        
        ML = ML + tempML'*tempML;
    end
    
    
    

end