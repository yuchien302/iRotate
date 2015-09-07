function img2pgm(path)
    disp('[img2pgm] Begin.');
    I = imread(path);
    
    if(max(size(I)) > 1080)
        disp('[img2pgm] Image > 1080p, resize to 1080p');
        I = imresize(I, 1080/max(size(I)));
        imwrite(I, path);
    end
    imwrite(I, [path, '.pgm']);
    disp('[img2pgm] Done.');
end