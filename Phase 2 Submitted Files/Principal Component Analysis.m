gestures = {'About' 'And' 'Can' 'Cop' 'Deaf' 'Decide' 'Father' 'Find' 'GoOut' 'Hearing'}; 
eigenVectorsMatrix = cell(1,10);
NewFinalFeatureMatrix = cell(1,10);
for a=1:10
    filename = strcat(gestures{a},'.xls');
    data = xlsread(filename);
    features = {'ALX' 'ALY' 'ALZ' 'ARX' 'ARY' 'ARZ' 'EMG0L' 'EMG1L' 'EMG2L' 'EMG3L' 'EMG4L' 'EMG5L' 'EMG6L' 'EMG7L' 'EMG0R' 'EMG1R' 'EMG2R' 'EMG3R' 'EMG4R' 'EMG5R' 'EMG6R' 'EMG7R' 'GLX' 'GLY' 'GLZ' 'GRX' 'GRY' 'GRZ' 'ORL' 'OPL' 'OYL' 'ORR' 'OPR' 'OYR'}; 
     
    
    %  for i=1:70
%     rownumber = (k-1)+(1+(i-1)*34);
%     temp = data(index,:);
%     temp1 = [temp1; temp]; 
%  end

% c = 1:45;
    for k=1:34
    TemporaryFeatureMatrix = data(k,:);
    for m=1:120
    rowNumber = k+(m*34);
    a = data(rowNumber,:);
    TemporaryFeatureMatrix  = [TemporaryFeatureMatrix ; a];
    end
    FinalFeatureMatrix  = [FinalFeatureMatrix ; TemporaryFeatureMatrix];
    end
    
[coeff,score,latent] = princomp(FinalFeatureMatrix );
eigenVectorsMatrix{a} = coeff(:,1:3);
NewFinalFeatureMatrix  {a} = FinalFeatureMatrix * coeff(:,1:3);
%h=figure();
figure(a)

plot(NewFinalFeatureMatrix{a})
title(gestures{a});
folder=strcat('C:\Users\kandu\Documents\plots\PCAdemo\',gestures{a},'.jpeg');
saveas(figure(a),folder);

end