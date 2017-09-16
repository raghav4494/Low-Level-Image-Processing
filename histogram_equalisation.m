%Reading source image
input_image = 'auto.pnm';

source = imread(input_image);
image_info = imfinfo(input_image);
category = image_info.ColorType;

%Ensuring every image is in grayscale type
if category == 'truecolor'
source = rgb2gray(source);
end

%Computing number of rows and columns
[rows, columns] = size(source);

%Initialising Histogram flatened output image
histogram_flattened = uint8(zeros(rows,columns));

%Initialising different arrays
Number_of_pixels = rows*columns; % To find total number of pixels
frequency_of_pixels = zeros(256,1); % To find the number of occurance of every pixel
probability_density_function = zeros(256,1);
cummulative_density_function = zeros(256,1);
out = zeros(256,1);


for i=1:rows
    for j=1:columns
        value = source(i,j);
        %Computing the occurence of every pixel value between 0 and 255
        frequency_of_pixels(value+1) = frequency_of_pixels(value+1)+1;
    end
end

for i=1:rows
    for j=1:columns
        value = source(i,j);
        %Computing the PDF for every pixel value
        probability_density_function(value+1) = frequency_of_pixels(value+1)/Number_of_pixels;
    end
end

cummulative_density_function(1) = probability_density_function(1);
for i=2:size(probability_density_function)
    %Computing the CDF with the framed PDF
    cummulative_density_function(i) = cummulative_density_function(i-1) + probability_density_function(i);
end

Max_Intensity = 255;
for i=1:size(probability_density_function)
    %Rounding off to nearest integer
    out(i) = round(cummulative_density_function(i)*Max_Intensity);
end
for i=1:rows
    for j=2:columns
        histogram_flattened(i,j)=out(source(i,j)+1);
    end
end

subplot(3,2,1), imshow(source), title('Image before Histogram Equalisation');
subplot(3,2,2),imshow(histogram_flattened),title('Image after Histogram Equalisation');
subplot(3,2,3),imhist(source),title('Histogram Before Flatenning');
subplot(3,2,4),imhist(histogram_flattened),title('Histogram After Flatenning');

%Comparision between our function and MATLAB inbuilt function
inbuilt = histeq(source);
%subplot(3,2,5),imshow(inbuilt),title('Histogram using inbuilt function');
subplot(3,2,[5,6]),imhist(inbuilt),title('Histogram flatended using inbuilt function');




