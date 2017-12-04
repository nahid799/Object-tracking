filepre='imgset5/img_';
filepre2='output/0';
for i = 100:449 
    s=num2str(i); % i is the image number.
    impath=strcat(filepre,s,'.jpeg');
    frame=imread(impath);
    impath=strcat(filepre2,s,'.jpeg');
    imwrite(frame,impath,'jpeg');
end;