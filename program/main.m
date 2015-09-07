function I = main(delta, filepath, visualizeMode)
% p = getParams();
% delta = 10;
% filepath = '../images/img2.png';
% visualizeMode = true;
p = getParams(delta, filepath);


if(p.debugMessage) disp('[extracting] Lines'); end

lines = extractLines(p, visualizeMode);
thetas = ones(p.M, 1)*p.delta;
C = {};
for i  = 1:10
    if(p.debugMessage) 
        disp(' ');
        disp(['=== iteration: ', num2str(i), ' ===' ]);
    end
    
    [V, C] = fix_thetas_sol_V(p, C, lines, thetas);
    Vx = V(2*p.k-1);
    Vy = V(2*p.k);
%     plot(Vx, Vy, 'ro');
    if(p.debugMessage) disp('[generating] thetas'); end
    thetas = fix_V_sol_theta(p, C, lines, thetas, V);

    if(p.debugMessage) 
        caculateTotalEnergy(p, V, thetas, lines);
        disp(['[V distance] ', num2str( sum((p.V-V).^2) ) ]);
    end
    
%     figure;
%     plot(thetas);
%     
%     figure;
%     I = warpMesh(p,Vx,Vy);
%     imshow(I);
end

% figure;
% plot(thetas);


I = warpMesh(p,Vx,Vy);
imwrite(I, [p.filepath, '.result.jpg']);
if(visualizeMode)
    figure;
    imshow(I);
end
%%
hold on;
gx = reshape(Vx, p.cy+1, p.cx+1);
gy = reshape(Vy, p.cy+1, p.cx+1);
plot(gx, gy, 'y-', gx', gy', 'y-');
hold off;
