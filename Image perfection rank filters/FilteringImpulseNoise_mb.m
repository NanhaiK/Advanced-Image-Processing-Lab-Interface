%% Filtering Impulse Noise
%  Study of Impulse Noise Filtering using pixel neighbourhoods    
%% Experiment Description:
% This experiment compare two Impulse Noise filtering algorithms Median
% filter and median over Qnbh-, or quantile neighborhood.
%% Tasks:
% 11.3 
% 
% * Generate an image with impulse noise (image jerus.img) with probability
% of error Pe=0.05 - 0.5.
% * Test rank filtering algorithm for different probability of error
% (program rfltrimp.m).  
% * Observe restoration of visibility of image details. Test iterative
% application of the filter.  
% * Evaluate performance of the filters in terms of probability of noise
% missing and false alarms (program certfimp.m).  
% * Compare with median filtering (program lc_medn.m). 
%% Instruction:
% 'Set Number of Iterations' - determines number of iteration of the
% algorithm.
%
% 'Set Impulse Noise Probability' - determines the Impulse Noise
% probability.
%
% 'Set Min R level' - For the Median over not in neighborhood pixels,
% defines the low Rank level, from which only pixels with rank higher or
% equal to are considered as is the neighborhood.
%
% 'Set Max R level' - For the Median over not in neighborhood pixels,
% defines the high Rank level, from which only pixels with rank lower or
% equal to are considered as is the neighborhood. Value should be less
% than Window Width*Window Height.
%
% 'Set Window Width'- Defined the neighborhood window width.
%
% 'Set Window Height'- Defined the neighborhood window height.
%% Theoretical Background:
% _*Rank filters for smoothing impulse noise*_
%
% Filtering impulse noise assumes two stages: detection of pixels replaced
% by noise and estimation of values of the detected corrupted pixels. 
%
% $$ \beta = Member \left( neighborhood \left[ \tilde{I}_{x,y}^{t-1}
% \right] , \tilde{I}_{x,y}^{t-1} \right)$$
%
% $$\tilde{I}(x,y)^t = \beta \cdot \tilde{I}_{x,y}^{t-1} + \left( 1 -
% \beta \right) \cdot Smooth \left( neighborhood \left[
% \tilde{I}_{x,y}^{t-1} \right] \right)$$  
%
% where 
% $Member \left( S, a \right)$ is a binary operator which returns 1 if the
% element $a$ is in set $S$, and 0 if $a$ is not in set $S$:
%
% $Member \left( S, a \right) = \left\{ \begin{array}{ll} 1 & a \in S \\ 0 & a \not\in S \end{array} \right.$
%
% $Smooth$ is one of smoothing operations such as $MEAN$, $MED$,
% $ROS$, $MODE$ or $RAND$. 
%
% $neighborhood$ is a neighborhood operation such as $\epsilon V$ neighborhood,
% Qnbh-, or quantile neighborhood, etc.
% For more details on the different neighborhoods types and definitions,
% please check the "Pixel Neighborhoods" experiment.
%
% This experiment will compare on $MEDIAN$ over the whole image after added
% impulse noise and Median over quantile neighborhood (Qnbh).
%
%% Algorithm:
% First, Impulse noise is added to the image. (for more information on
% impulse noise, please check "Image Noise Statistical Models"
% experiment.)
%
% then, two filter operations are performed on the image:
%
% *_1. IterativeFilter_*
%       OutImg=npmg;
%     for x=1:Image_Width
%       for y=1:Image_Height
%       
%       Medn=Median(S(InpImg, x, y));
%       D=abs(InpImg-Medn);
%       FilterMask=D>THR;
%       OutImg(FilterMask) = Medn(FilterMask));
%       end
%     end
%
% Where S(I, x, y) are all the pixels in the rectangle centered at (x,y)
% with window_width and window_height (supplied by the user).
%
% For more information regarding the Median operation, please check "Image
% Statistics" experiment.
%
% *_2. Median over quantile neighborhood (Qnbh)_*
%
%     for x=1:Image_Width
%       for y=1:Image_Height
%             beta = isMember( neighborhood(I,x,y),I(x,y))
%             I(x,y)= beta*I(x,y)+(1-beta)*Median(I,x,y)  
%       end
%     end
%
% Where neighborhood(I, x, y) are all the pixels in the rectangle centered
% at (x,y) with window_width and window_height, which satisfy the quantile
% neighborhood requirements ( $R_{min} \le R\left(I(x,y)\right) \le R_{max}$, where $R_{min},
% R_{max}$ are supplied by the user).
%
% For more information regarding the MEDIAN operation, please check "Image
% Statistics" experiment.
% 
% * *_Filter Comparison_*
%
% the two impulse noise filters are evaluated according to several parameters:
%
% inputs:
%
% * INIIMG - input image, without the noise.
% * NOISIMG - input image, with the noise.
% * FILTIMG - filtered noisy image.
%
% * Pn: Probability of impulse interference in the particular realization of noise;
%
% <html><pre class="codeinput"><p>Code:
%    ARR_T=INIIMG==NOISIMG;
%    ARR_ERR=1-ARR_T;
%    Pn=sum(sum(ARR_ERR))/Sz;
% </p></pre></html>
%
% * STDn: Standard deviation of the residual noise:
%
% <html><pre class="codeinput"><p>Code:
%    RES_NOISE=INIIMG-FILTIMG;
%    STDn=std2(RES_NOISE);
% </p></pre></html>
%
% * Pfd: Probability of false detection of noise interference
%
% <html><pre class="codeinput"><p>Code:
%    ARR_T=INIIMG==NOISIMG;
%    FALS_D=RES_NOISE.*ARR_T;
%    Pfd=sum(sum(1-(FALS_D==0)))/Sz;
% </p></pre></html>
%
% * Pm: Probability of missing noise interference
%
% <html><pre class="codeinput"><p>Code:
%    ARR_T=INIIMG==NOISIMG;
%    RES_NOISE=INIIMG-FILTIMG;
%    ARR_ERR=1-ARR_T;
%    MISS=RES_NOISE.*(NOISIMG==FILTIMG).*(ARR_ERR);
%    Pm=sum(sum(1-(MISS==0)))/Sz;
% </p></pre></html>
%
% * STDfd: Standard deviation of errors due to false noise detection
%
% <html><pre class="codeinput"><p>Code:
%    ARR_T=INIIMG==NOISIMG;
%    RES_NOISE=INIIMG-FILTIMG;
%    ARR_ERR=1-ARR_T;
%    MISS=RES_NOISE.*(NOISIMG==FILTIMG).*(ARR_ERR);
%    Pm=sum(sum(1-(MISS==0)))/Sz;
% </p></pre></html>
%
% * STDm: Standard deviation of errors due to missing noise interference
%
% <html><pre class="codeinput"><p>Code:
%    RES_NOISE=INIIMG-FILTIMG;
%    ARR_T=INIIMG==NOISIMG;
%    ARR_ERR=1-ARR_T;
%    MISS=RES_NOISE.*(NOISIMG==FILTIMG).*(ARR_ERR);
%    STDm=std2(MISS);
% </p></pre></html>
%
% * STDest: Standard deviation of detected corrupted pixel estimation errors 
%
% <html><pre class="codeinput"><p>Code:
%    RES_NOISE=INIIMG-FILTIMG;
%    ARR_T=INIIMG==NOISIMG;
%    ARR_ERR=1-ARR_T;
%    ESTIM=RES_NOISE.*(1-(NOISIMG==FILTIMG)).*(ARR_ERR);
%    STDest=std2(ESTIM);
% </p></pre></html>
%
%% References
% * [1] Yaroslavsky L.P., Kim V., �Rank Algorithms for Picture Processing, Computer Vision�, Graphics and Image Processing, v. 35, 1986, p. 234-258 
% * [2] L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser, Boston,1996
% * [3] <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_4.pdf Lecture Notes: Image restoration and enhencement: non-linear filters>
% * [4] <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/nonlin_filters.pdf non-linear Signal Processing Filters: A Unification Approach>

function FilteringImpulseNoise = FilteringImpulseNoise_mb(handles)
    handles = guidata(handles.figure1);
    axes_hor = 4;
    axes_ver = 2; %1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    FilteringImpulseNoise = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9); 

    % init params
    FilteringImpulseNoise.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
    FilteringImpulseNoise.WdSzX = 3;
    FilteringImpulseNoise.WdSzY = 3;
    FilteringImpulseNoise.erpos =(FilteringImpulseNoise.WdSzX*FilteringImpulseNoise.WdSzY)-1;% 5;
    FilteringImpulseNoise.erneg =1;% 5;
    FilteringImpulseNoise.P = 0.25;%0.05;
    FilteringImpulseNoise.iteration_num =3;%5;
    WindowSize=FilteringImpulseNoise.WdSzX*FilteringImpulseNoise.WdSzY;
    FilteringImpulseNoise.Thr = 10;
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    
     
    k=k+1;
    interface_params =  SetSliderParams('Set the highest rank for noise detection', WindowSize, 1, FilteringImpulseNoise.erpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erpos',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set the lowest rank for noise detection', FilteringImpulseNoise.erpos, 1, FilteringImpulseNoise.erneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erneg',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Iterative filter detection threshold', 50, 10, FilteringImpulseNoise.Thr, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Thr',@update_sliders), interface_params, k);
    
    k=k+1;
    interface_params =  SetSliderParams('Set the number of filtering iterations', 10, 1, FilteringImpulseNoise.iteration_num, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'iteration_num',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Set filter window width',7, 1, FilteringImpulseNoise.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set filter window height', 7, 1, FilteringImpulseNoise.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);
        
   
    k=k+1;
    interface_params =  SetSliderParams('Set Impulse noise probability', 1, 0, FilteringImpulseNoise.P, 0.05, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'P',@update_sliders), interface_params, k);

    FilteringImpulseNoise.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
    imshow(FilteringImpulseNoise.im, [0 255], 'parent', FilteringImpulseNoise.axes_1);
    DisplayAxesTitle( FilteringImpulseNoise.axes_1, 'Test image','TM',10);    
end


function update_sliders(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    
    WdSz = fix(handles.(handles.current_experiment_name).WdSzX*handles.(handles.current_experiment_name).WdSzY);
    % er plus
    val = min(WdSz, handles.(handles.current_experiment_name).erpos);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider2');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', max(1.00001, WdSz));
    set(slider_handle, 'sliderstep', [1, 1]/(max(WdSz-1, 1)));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value2');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText2');
    set(slider_title_handle, 'string',  num2str(WdSz));
    handles.(handles.current_experiment_name).erpos = val;   
    % er neg
    val = min(handles.(handles.current_experiment_name).erpos, handles.(handles.current_experiment_name).erneg);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider3');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', max(1.00001, handles.(handles.current_experiment_name).erpos));
    set(slider_handle, 'sliderstep', [1, 1]/max(1,(handles.(handles.current_experiment_name).erpos -1)));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value3');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText3');
    set(slider_title_handle, 'string',  num2str(handles.(handles.current_experiment_name).erpos));
    handles.(handles.current_experiment_name).erneg = val;   

    if ( strcmpi(handles.interactive, 'on'))
        run_process_image(handles);
    end
    guidata(handles.figure1,handles );
end


function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
       
    FilteringImpulseNoise = handles.(handles.current_experiment_name);

    process_image (FilteringImpulseNoise.im, FilteringImpulseNoise.erpos, ...
        FilteringImpulseNoise.erneg, FilteringImpulseNoise.WdSzX, FilteringImpulseNoise.WdSzY, FilteringImpulseNoise.P, ...
        FilteringImpulseNoise.iteration_num, FilteringImpulseNoise.Thr, FilteringImpulseNoise.axes_1, FilteringImpulseNoise.axes_2, FilteringImpulseNoise.axes_3, ...
        FilteringImpulseNoise.axes_4, FilteringImpulseNoise.axes_5, FilteringImpulseNoise.axes_6, FilteringImpulseNoise.axes_7, FilteringImpulseNoise.axes_8);
    guidata(handles.figure1,handles );
end


function process_image (im,  Rright, Rleft, WdSzX, WdSzY, P, iteration_num, THR, ...
    axes_1, axes_2, axes_3, axes_4, axes_5, axes_6, axes_7, axes_8)
im_without_noise = im;


[SzX, SzY]=size(im);
noisemask=rand(SzX,SzY)<P;
im =(ones(SzX,SzY)-noisemask).*im+256*rand(SzX,SzY).*noisemask;

lc_medn_out = im;
rfltrimp_out = im;
[SzX SzY]=size(im_without_noise);
Sz=SzX*SzY;
% ARR_T == 1 in pixel with no noise.
ARR_T=im_without_noise==im;
ARR_ERR=1-ARR_T;
Pn=sum(sum(ARR_ERR))/Sz;

imshow(im, [0 255], 'parent', axes_5);
DisplayAxesTitle( axes_5, {'Test image with impulse noise', ...
                           ['Calculated error rate = ' num2str(Pn,3)]},'BM',10);
wait_bar_handle = waitbar(0,'please wait') ;
% D=fix(40/(iteration_num-1));
% THR=75:-D:10; % THRESHOLD FOR DETECTION OF IMPULSE NOISE DISTORTED PIXELS
for i =1 : iteration_num,
    rfltrimp_out = rfltrimp_mb(rfltrimp_out,WdSzX,WdSzY, Rleft, Rright);
    lc_md=lc_medn_mb(lc_medn_out,WdSzX,WdSzY);
    lc_medn_outmask =abs(im-lc_md)>THR;
    lc_medn_out(lc_medn_outmask)=lc_md(lc_medn_outmask);
    imshow(lc_medn_out, [0 255], 'parent', axes_2);
    imshow(rfltrimp_out, [0 255], 'parent', axes_6);
    drawnow;
    waitbar(i/iteration_num,wait_bar_handle);
end

delete(wait_bar_handle);


[SzX SzY]=size(im_without_noise);
Sz=SzX*SzY;
% ARR_T == 1 in pixel with no noise.
ARR_T=im_without_noise==im;
ARR_ERR=1-ARR_T;
Pn=sum(sum(ARR_ERR))/Sz;                       
% STDprer - Standard deviation of the prediction error 
% Pn =Probability of impulse interference in the particular realization of noise;
% STDn - Standard deviation of the residual noise
% Pfd=Probability of false detection of noise interference
% Pm =Probability of missing noise interference
% STDfd -Standard deviation of errors due to false noise detection
% STDm - Standard deviation of errors due to missing noise interference
% STDest - Standard deviation of detected corrupted pixel estimation errors


RES_NOISE=im_without_noise-lc_medn_out;
STDn_medn=std2(RES_NOISE);
% changed values where there were no noise (false detection)
FALS_D=RES_NOISE.*ARR_T;
Pfd_medn=sum(sum(1-(FALS_D==0)))/Sz;
STDfd_medn=std2(FALS_D);
MISS=RES_NOISE.*(im==lc_medn_out).*(ARR_ERR);
Pm_medn=sum(sum(1-(MISS==0)))/Sz;
STDm_medn=std2(MISS);
ESTIM=RES_NOISE.*(1-(im==lc_medn_out)).*(ARR_ERR);
STDest_medn=std2(ESTIM);

imshow(lc_medn_out, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, 'Iterative filtering result','TM',9);

imshow(RES_NOISE, [], 'parent', axes_3);
% Remaining noise after filtering
DisplayAxesTitle( axes_3, {'Iterative filtering residual error'}, 'TM', 9);


RES_NOISE=im_without_noise-rfltrimp_out;
STDn_rfltr=std2(RES_NOISE);
FALS_D=RES_NOISE.*ARR_T;
Pfd_rfltr=sum(sum(1-(FALS_D==0)))/Sz;
STDfd_rfltr=std2(FALS_D);
MISS=RES_NOISE.*(im==rfltrimp_out).*(ARR_ERR);
Pm_rfltr=sum(sum(1-(MISS==0)))/Sz;
STDm_rfltr=std2(MISS);
ESTIM=RES_NOISE.*(1-(im==rfltrimp_out)).*(ARR_ERR);
STDest_rfltr=std2(ESTIM);

imshow(rfltrimp_out, [0 255], 'parent', axes_6);
DisplayAxesTitle( axes_6, 'Rank-filtering result','BM',9); 

imshow(RES_NOISE, [], 'parent', axes_7);
DisplayAxesTitle( axes_7, 'Iterative filtering result residual error','BM',9); 

delete(get(axes_4, 'children'));
text(0,0, ['\begin{tabular}{ | l || c | r | }', ...
'\hline', ... 
'\  & Iterative-filtering & Rank-filtering \\',...
'Pn & ', num2str(Pn, '%0.3f'), '& ', num2str(Pn, '%0.3f'), '\\' ...
'STDn & ', num2str(STDn_medn, '%0.3f'), '& ', num2str(STDn_rfltr, '%0.3f'), '\\' ...
'Pfd &' , num2str(Pfd_medn, '%0.3f'), '& ', num2str(Pfd_rfltr, '%0.3f'), '\\' ...
'Pm &' , num2str(Pm_medn, '%0.3f'), '& ', num2str(Pm_rfltr, '%0.3f'), '\\' ...
'STDfd &', num2str(STDfd_medn, '%0.3f'), '& ', num2str(STDfd_rfltr, '%0.3f'), '\\' ....
'STDm & ', num2str(STDm_medn, '%0.3f'), '& ', num2str(STDm_rfltr, '%0.3f'), '\\' ...
'STDest &', num2str(STDest_medn, '%0.3f'), '& ', num2str(STDest_rfltr, '%0.3f'), '\\' ...
'\hline', ...
'\end{tabular}'], ...
'Verticalalignment', 'bottom', ...
'interpreter', 'latex', 'parent', axes_4)

delete(get(axes_8, 'children'));
text(0,1, {'Pn - ', 'Probability of impulse interference', ...
'STDn - ', 'StDev of the residual noise', ...
'Pfd - ', 'Probability of false detection of noise interference', ...
'Pm - ', 'Probability of missing noise interference', ...
'STDfd - ', 'StDev of errors due to false noise detection', ...
'STDm - ', 'StDev of errors due to missing noise interference', ...
'STDest - ', 'StDev of detected corrupted pixel estimation errors'}, ...
'Verticalalignment', 'top', ...
'parent', axes_8);

% '\hline', ... 
% 'STDprer - Standard deviation of the prediction error \\' ...
% 'Pn =Probability of impulse interference in the particular realization of noise \\' ...
% 'STDn - Standard deviation of the residual noise \\' ...
% 'Pfd=Probability of false detection of noise interference \\' ...
% 'Pm =Probability of missing noise interference \\' ...
% 'STDfd -Standard deviation of errors due to false noise detection \\' ...
% 'STDm - Standard deviation of errors due to missing noise interference \\' ...
% 'STDest - Standard deviation of detected corrupted pixel estimation errors \\' ...
% '\hline', ...


% 'Standard deviation of the prediction error & 5 & 6 \\' ...
% 'Probability of impulse interference in the particular realization of noise & 8 & 9 \\' ...
% 'Standard deviation of the residual noise & 8 & 9 \\' ...
% 'Probability of false detection of noise interference & 8 & 9 \\' ...
% 'Probability of missing noise interference & 8 & 9 \\' ...
% 'Standard deviation of errors due to false noise detection & 8 & 9 \\' ...
% 'Standard deviation of errors due to missing noise interferenc & 8 & 9 \\' ...
% 'Standard deviation of detected corrupted pixel estimation errors & 8 & 9 \\' ...
end