%Reading source image
input_image = 'auto.pnm';

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
          Noisy_Image=imnoise(source,'salt & pepper',density);

    case 2
          prompt = 'Enter the desired variance';
          variance = input(prompt);
          %Creating noisy image by adding gaussian noise
          Noisy_Image=imnoise(source,'gaussian',0,variance);

    case 3
          %Creating noisy image by adding poisson noise
          Noisy_Image = imnoise(source,'poisson');
end

%Padding the original array with zeros for more accuracy in corner points
final = uint8(padarray(Noisy_Image,[1 1]));

%Computing the number of rows and columns
[rows,columns]=size(final);

%Median Filtered Image Matrix
Filtered_Matrix=zeros(rows-2,columns-2);

for i = 2:rows-1
    for j=2:columns-1
        %Picking the neighbourhood points
        Neighbourhood_points=[final(i-1,j-1),final(i-1,j),final(i-1,j+1),final(i,j-1),final(i,j),final(i,j+1),final(i+1,j-1),final(i+1,j),final(i+1,j+1)];
        %Sorting the input points
        Neighbourhood_points=sort(Neighbourhood_points);
        %For a 3*3 matrix, 5th element will be the median always
        Filtered_Matrix(i-1,j-1)=Neighbourhood_points(5);
    end
end

%Showing the original,noisy and filtered image for comparision
subplot(1,3,1),imshow(input_image),title('Original');
subplot(1,3,2),imshow(Noisy_Image,[]),title('With Noise');
subplot(1,3,3),imshow(Filtered_Matrix,[]),title('After removing noise');