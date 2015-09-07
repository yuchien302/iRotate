function [V, C] = fix_thetas_sol_V(p, C, lines, thetas)
%     p = getParams();
    if(~isfield(C, 'MS'))
        if(p.debugMessage) disp('[forming] MS'); end
        C.MS = formMS(p);
    end
    
    if(~isfield(C, 'MBP'))
        if(p.debugMessage) disp('[forming] MBP and b'); end
        [C.MBP, C.b] = formMBPandb(p);
    end
    
    if(p.debugMessage) disp('[forming] ML'); end
    [ML, C] = formML(p, C, lines, thetas);
    
    N = p.cx*p.cy;
    K = size(lines, 1);
    if(p.debugMessage) 
        disp(['[generating] V with lambdaB = ', num2str(p.lambdaB), ', lambdaL = ', num2str(p.lambdaL)]);
    end
    
    V = (C.MS/N + p.lambdaB*(C.MBP'*C.MBP) + p.lambdaL/K*ML)\(-p.lambdaB*C.MBP'*C.b);
    

    
end