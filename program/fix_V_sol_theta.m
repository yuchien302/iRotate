function thetas = fix_V_sol_theta(p, C, lines, thetas, V)

K = size(lines,1);
M = p.M;
delta = p.delta;

A = zeros(K,M);
for k=1:K
    bin = lines(k,6);
    A(k,bin)=1;
end

T_1 = [ zeros(M-1, 1), eye(M-1, M-1);
             1       , zeros(1, M-1)];
D = eye(M,M)-T_1;


Pk = getPk(p, lines);

Vx = V(2*p.k-1);
Vy = V(2*p.k);
e_x = Pk*Vx;
e_y = Pk*Vy;
e = [e_x, e_y, acos(e_x./sqrt(e_x.^2+e_y.^2))/pi*180];


beta_0 = 1;
beta_inc = 10;
beta_max = 10^4;
beta = beta_0;

phi_k = zeros(K, 1);
phi =  zeros(K, 100);
while(beta<=beta_max)

    %% Fix theta, solve for phi_k for all k
    for k=1:K

        % current real rotate angle, the goal is to let it equal p.delta
        ek_uk = e(k,3)-lines(k,5);

        % current bin's rotate angle
        bin = lines(k,6);
        thetam_k = thetas(bin);
        
        phi(k,:) = ek_uk:(thetam_k-ek_uk)/99:thetam_k;

        temp = zeros(1, 100);
        for i=1:100            
            Rk = [cos(phi(k,i)/pi*180) -sin(phi(k,i)/pi*180);
                  sin(phi(k,i)/pi*180)  cos(phi(k,i)/pi*180)];
         
            term1 = (Rk*C.U{k}*Rk'-eye(2))*e(k,1:2)';
            
            temp(i) = p.lambdaL/K*sum(term1.^2) + beta*sum((phi(k,i)-thetam_k).^2);
        end
        [~, ind] = min(temp);
        phi_k(k) = phi(k,ind);
        
    end

    
    
    
    %% Fix phi, solve for theta
    H = beta*(A'*A) + p.lambdaR*diag(p.sdelta) + p.lambdaR*(D'*D);
    h = beta*A'*phi_k + p.lambdaR*diag(p.sdelta)*(ones(M,1)*delta);
    
    thetas = H\h;
    
    %% increase while loop
     beta = beta*beta_inc;
    
end

