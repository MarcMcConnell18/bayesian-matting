function [Fground, Bground, Unknown] =  FBsplit (image, trimap)
%get the dataset of image and trimap
img_data = Imread(image);
trimap_data = Imread(trimap);

%get the size of image and trimap
sizeimg = size(img_data);
sizeimg_2_dims = size(img_data(:, :, 1));
sizetrimap = size(trimap_data);

%check the alignment of image and trimap
if sizeimg_2_dims == sizetrimap
    disp("sizechecking: Successful alignment of image and trimap");
else
    disp("sizechecking: size not match, asking for new trimap");
    [File,Path,Index]=  uigetfile({'*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.tiff','Image Files (.jpg, .png, .gif, .bmp, .tiff'},'Select an new trimap ');
    trimap = imread([Path File]);
end

%check trimap rgbgrey
if size(trimap, 3) ~= 1
    trimap = rgb2gray(trimap);
end

% set the capture for B F and Unknown
Fground = double(img_data);
Bground = double(img_data);
Unknown = double(img_data);
width = size(img_data,1);
height = size(img_data,2);

% set the threshold to detect F and B
Fthreshold = 255;
Bthreshold = 0;

% split image
for h = 1 : height
    for w = 1 : width
        for i = 1 : 3

            if triMap(h, w) >= Fthreshold
                Bground(h, w, i) = 0;
                Unknown(h, w, i) = 0;
            end
            if triMap(h, w) <= Bthreshold
                Fground(h, w, i) = 0;
                Unknown(h, w, i) = 0;
            end
            if triMap(h, w) < Fthreshold && triMap(a,b) > Bthreshold
                Bground(h, w, i) = 0;
                Fground(h, w, i) = 0;
            end
        end
    end
end
   figure,
   imshow([uint8(Fground) uint8(Bground) uint8(Unknown)]);
   drawnow;
end