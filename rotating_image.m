%Reading source image
input_image = 'child.pnm';
source=imread(input_image); 

%Calculating rows and columns for the given image
[rows,columns,z]= size(source); 

prompt = 'Enter the rotation angle??? Prefix - for Clockwise rotation ';
reply = input(prompt);
angle = reply;

%Computing radian from the given angle
radians=2*pi*angle/360;

%Computing the rows and columns for the final image
rows_final=ceil(rows*abs(cos(radians))+columns*abs(sin(radians))); %abs for getting absolute values                    
columns_final=ceil(rows*abs(sin(radians))+columns*abs(cos(radians)));                     

%Initialising the matrix with zero
Rotated_Image=uint8(zeros([rows_final columns_final 3 ]));

%calculating x and y center for original image
x_original=ceil(rows/2);                                                            
y_original=ceil(columns/2);

%calculating x and y center for final image
x_final=ceil(rows_final/2);
y_final=ceil(columns_final/2);

%Compute the coordiantes for the final rotated image
%Traverse for every pixel in the image
for i=1:rows_final
    for j=1:columns_final                                                   
         
        %Computing the rotation matirx of the final image
         x= (i-x_final)*cos(radians)+(j-y_final)*sin(radians);                                       
         y= -(i-x_final)*sin(radians)+(j-y_final)*cos(radians); 
         
         %Adjusting with regard to the center of the original image 
         x=round(x)+x_original;
         y=round(y)+y_original;

         %Checking whether the image lies in the black area or not
         if (x>=1 && y>=1 && x<=size(source,1) &&  y<=size(source,2) ) 
              Rotated_Image(i,j,:)=source(x,y,:);  
         end

    end
end
%Comparision between our function and MATLAB inbuilt function
inbuilt = imrotate(source,angle);
%Showing the original and final image for comparision
subplot(1,3,1), imshow(source), title('Original');
subplot(1,3,2),imshow(Rotated_Image),title('After Rotation');
subplot(1,3,3),imshow(inbuilt),title('Using imrotate');

