
gestures={'About' 'And' 'Can' 'Cop' 'Deaf' 'Decide' 'Father' 'Find' 'GoOut' 'Hearing'};
features = {'ALX' 'ALY' 'ALZ' 'ARX' 'ARY' 'ARZ' 'EMG0L' 'EMG1L' 'EMG2L' 'EMG3L' 'EMG4L' 'EMG5L' 'EMG6L' 'EMG7L' 'EMG0R' 'EMG1R' 'EMG2R' 'EMG3R' 'EMG4R' 'EMG5R' 'EMG6R' 'EMG7R' 'GLX' 'GLY' 'GLZ' 'GRX' 'GRY' 'GRZ' 'ORL' 'OPL' 'OYL' 'ORR' 'OPR' 'OYR'}; 

for z=1:10
    filename=strcat(gestures{z},'.xls');
    data = xlsread(filename);  
for k=1:34
   
 rownumber=1;
  f0=zeros(1,45);
 
%  for i=1:70
%     rownumber = (k-1)+(1+(i-1)*34);
%     temp = data(index,:);
%     temp1 = [temp1; temp]; 
%  end
%  temp1=mean(temp1);
%  temp1=rms(temp1);
% c = 1:45;
 

 for i=1:120
    temp1 = data(rownumber,:);
    temp2 = [temp2; fft(temp1)];
    %temp2 = [temp2; dwt(temp1,'sym4')];    %function for dwt
     %temp2 = [temp2; autocorr(temp1)];        %function for autocorrelation
       %temp2 = [temp2; movmean(temp1,3)];      %function for moving mean
       
    rownumber = k+(i*34);
 end
c = 1:42;

%c = 1:21; %autcorrelation
for j=1:120
    temp3 = temp2(j,:);
   % temp3 = temp2(j,12:14); %DWT
    h = figure();
    set(h, 'Visible', 'off');
    plot(c,temp3);
    %pwelch(temp3); %for psd function
    temp=strcat(features{k},' for  ',gestures{z});
    %Labels are changed depending on the feature extraction technique
    ylabel('FFT');
    xlabel('Time Series');
    title(temp);
    hold on;
end
hold off;
folder=strcat('C:\Users\kandu\Documents\plots\fft\',temp,'.jpeg');
saveas(h,folder);

end

end