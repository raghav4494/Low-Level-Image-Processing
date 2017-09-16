%Reading source image
input_image = 'cameraman.tif';

source = imread(input_image);

subplot(2,1,1),imshow(source),title('Before log transformation');

%Altering the matrix to have double precision values
source = double(source) + 1;

%Applying Log Transformation
log_transform_A = 0.1 * log10(source);

%Converting the transformed matrix to grayscale image
log_transform_A = mat2gray(log_transform_A);

subplot(2,1,2),imshow(log_transform_A),title('After Log Transformation');





