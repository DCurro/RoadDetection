function app_determineSuperPixel()

rawImageFileList = FileFinder.findAllFilePathsInDirectoryEndingWithSuffix('data_road/training/image_2/','.png');
groundTruthImageFileList = FileFinder.findAllFilePathsInDirectoryEndingWithSuffix('data_road/training/gt_image_2/','.png');
numberOfImages = size(rawImageFileList,1);

randomImage = 0;
randomGroundTruth = 0;

regionSize = 32;
regularizer = 10;

sliderValue  = 25;
regularizerSliderValue = 10;

fig = figure;
hold on;

changeImage();

    function userDidClickButton(source,callbackdata)
        randomImageIndex = randi(numberOfImages);
        randomImage = imread(strtrim(rawImageFileList(randomImageIndex,:)));

        changeImage();
    end

    function userDidSlideSlider(source,callbackdata)
       regionSize = source.Value;
       sliderValue = source.Value
       
       updateSlicing();
    end

    function userDidSlideRegularizerSlider(source,callbackdata)
       regularizer = source.Value;
       regularizerSliderValue = source.Value
       
       updateSlicing();
    end

    function changeImage()
        randomImageIndex = randi(numberOfImages);
        randomImage = imread(strtrim(rawImageFileList(randomImageIndex,:)));
        randomGroundTruth = imread(strtrim(groundTruthImageFileList(randomImageIndex,:)));
                    
        updateSlicing();
    end

    function updateSlicing()
        segments = vl_slic(im2single(randomImage), regionSize, regularizer, 'verbose');
        contouredImage = draw_contours(segments, randomImage);
        contouredGroundTruth = draw_contours(segments, randomGroundTruth);
        
        imshow(vertcat(contouredImage,contouredGroundTruth));
%         imshow(segments, [1,max(max(segments))])
        uicontrol(fig,'String', 'Change Image', ...
                        'Position', [100 100 100 50],...
                        'Callback', @userDidClickButton);
        
        uicontrol(fig,'Style','slider',...
                        'Min',1,'Max',10,'Value',regularizerSliderValue,...
                        'SliderStep',[0.01 0.2],...
                        'Position',[30 40 150 30],...
                        'Callback', @userDidSlideRegularizerSlider);
                    
        uicontrol(fig,'Style','slider',...
                        'Min',1,'Max',100,'Value',sliderValue,...
                        'SliderStep',[0.01 0.2],...
                        'Position',[30 20 150 30],...
                        'Callback', @userDidSlideSlider);
    end

end

