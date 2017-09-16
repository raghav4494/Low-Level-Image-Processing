%Reading source image
input_image = 'tire.pnm';

source = imread(input_image);
image_info = imfinfo(input_image);
category = image_info.ColorType;

%Ensuring every image is in grayscale type
if category == 'truecolor'
source = rgb2gray(source);
end

prompt = 'Enter the type of noise you want 1. salt and pepper noise 2. Gaussian 3. Poisson?';
reply = input(prompt);

switch reply
    case 1
          prompt = 'Enter the desired noise density';
          density = input(prompt);
          %Creating noisy image by adding salt and peper noise
          A=imnoise(source,'salt & pepper',density);

    case 2
          prompt = 'Enter the desired variance';
          variance = input(prompt);
          %Creating noisy image by adding gaussian noise
          A=imnoise(source,'gaussian',0,variance);

    case 3
          %Creating noisy image by adding poisson noise
          A = imnoise(source,'poisson');
end

I = double(A);

%Getting standard deviation value from the user
prompt = 'Enter the standard deviation for the filter';
reply = input(prompt);
sigma = reply;
variance = sigma * sigma;

%Mask size
mask = round(3*sigma);
[x,y]=meshgrid(-mask:mask,-mask:mask);

%Mathematical calcuations
power_values = -(x.^2+y.^2)/(2*variance);
exponent_values= exp(power_values)/(2*pi*variance);

%Initialize Output array of zeros
Filtered_Image=zeros(size(I));

%Padding the original array with zeros for more accuracy in corner points
final = (zeros(size(I,1)+(2*mask),size(I,2)+(2*mask)));

%Computing the number of rows and columns
[rows,columns]=size(final);

for i = mask+1 : rows-mask
    for j=mask+1 : columns-mask
        final(i,j) = I(i-mask,j-mask);
    end
end

x_window = size(x,1)-1;
y_window = size(y,1)-1;

%Convolution on Output Matrix
for i = 1:rows-x_window
    for j =1:columns-y_window
        Intermediate = final(i:i+x_window,j:j+x_window).*exponent_values;
        Filtered_Image(i,j)=sum(Intermediate(:));
    end
end
%Image without Noise after Gaussian blur
Filtered_Image = uint8(Filtered_Image);

%Showing the original,noisy and filtered image for comparision
subplot(1,3,1),imshow(source),title('Original');
subplot(1,3,2),imshow(A),title('Noisy');
subplot(1,3,3),imshow(Filtered_Image),title('Removing noise');