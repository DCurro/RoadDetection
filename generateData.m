function generateData()

% get all of the files
rawImageFileList = FileFinder.findAllFilePathsInDirectoryEndingWithSuffix('data_road/training/image_2/','.png');
groundTruthImageFileList = FileFinder.findAllFilePathsInDirectoryEndingWithSuffix('data_road/training/gt_image_2/','.png');
numberOfFiles = size(rawImageFileList,1);


% for each file, perform slic to make the super pixels
for i=1:numberOfFiles
    roadImageFilePath = strtrim(rawImageFileList(i,:));
    roadImage = imread(roadImageFilePath);
    
    [path,name,ext] = fileparts(roadImageFilePath);
    stringPartCell = strsplit(name,'_');
    groundTruthPath = ['data_road/training/gt_image_2/',stringPartCell{1},'_road_',stringPartCell{2},ext];
    
    
    segments = vl_slic(im2single(roadImage), 32, 10);
    [top,bottom, left, right] = findSegmentBounds(segments, 12);
    
end


% for each bin in the segments
%make an image, store it, save the path name, and decide if it's a
%road using the grount truth

end

function [top, bottom, left, right] = findSegmentBounds(segments, binID)

top = intmax;
bottom = intmin;
left = intmax;
right = intmin;

for y = 1:size(segments, 1)
    for x=1:size(segments, 2)
        bin = segments(y,x);
        if bin == binID 
           if y < top 
              top = y; 
           end
           
           if y > bottom 
               bottom = y; 
           end
           
           if x < left
               left = x ; 
           end 
           
           if x > right 
               right = x ; 
           end 
                       
        end
        
    end
end
end



function [newTop, newBottom, newLeft, newRight] = force32x32(top,bottom, left, right)

    newTop = top ; 
    newBottom = bottom;
    newLeft = left; 
    newRight = right;  
    
if bottom - top == 32 && right - left == 32
    return; 
end

while newBottom - newTop < 32    
    if newTop == 1 
        newBottom = newBottom + 1 ; 
    elseif newBottom == imageHeight
        newTop = newTop - 1; 
    else 
        newTop = newTop - 1; 
    end    
end 

while newRight - newLeft < 32 
    if newLeft == 1 
        newRight = newRight +1 ; 
    elseif newRight == imageWidth
        newLeft = newLeft - 1 ; 
    else 
        newLeft = newLeft - 1; 
    end  
end

end

