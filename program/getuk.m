function uk = getuk(lines)
    % u: nomalized unit vectors of lines
    % (ux, uy), with uy>=0
    
    uk(:, 1) = lines(:, 3) - lines(:, 1);
    uk(:, 2) = lines(:, 4) - lines(:, 2);
    
    for k = 1:length(lines)
        uk(k, :) = uk(k, :)/norm(uk(k, :));
    end

end