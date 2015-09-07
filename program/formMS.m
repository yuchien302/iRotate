function MS = formMS(p)
%     p=getParams();
    MS = zeros(p.NV*2, p.NV*2);
%     ErrorS = 0;
%     ErrorS1 = 0;
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

%             Vq = Aq(:,1);
%             S = (Aq*pinv(Aq'*Aq)*Aq'-eye(8))*Vq;
%             ErrorS=ErrorS+S'*S;
%             S1 = (Aq*pinv(Aq'*Aq)*Aq'-eye(8))*Q*p.V;
%             ErrorS1 = ErrorS1+S1'*S1;

            tempMS = (Aq*pinv(Aq'*Aq)*Aq'-eye(8))*Q;
            MS = MS + tempMS'*tempMS;
        end
    end
end