warning off;
clc;clear;
for m=1:6
    files=["DM30.csv";"DM31.csv";"DM32.csv";"DM33.csv";"DM34.csv";"DM35.csv"];
    disp(files(m));
[InputData,Textdata] = xlsread(files(m));
%countaction = [];
gestures = [ "About" ; "And";"Can";"Cop";"Deaf";"Decide";"Father";"Find";"Go out";"Hearing"];
for z=1:10
 
[rows,cols] = size(InputData);
Y = [];


%DominantFeature=[4,26,15,16];

indcell=cell(1,10);
indcell{1}=[26,27,28,22,21];
indcell{2}=[4,26,16,15];
indcell{3}=[11,19,6,9,24,27];
indcell{4}=[1,2,3,4,5,6];
indcell{5}=[4,5,6,17,32];
indcell{6}=[5,1,10,11,12];
indcell{7}=[6,14,15,26,27];
indcell{8}=[17,23,34,5,32];
indcell{9}=[5,33,14,23,18];
indcell{10}=[33,20,26,23,2,1];

DominantFeature=indcell{z};



sensors = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];

for feature = 1:length(DominantFeature)
    j = DominantFeature(feature);
    X = InputData(j,:);
    X(isnan(X))=[];
    X = fft(X,4);
  % X=var(X);
 % X=dwt(X,'sym4');
 % X=rms(X);
% X=autocorr(X)
    for i = j+34:34:rows
        A = InputData(i,:);
        A(isnan(A))=[];
        A = fft(A,4);
       % A=var(A);
      % A=dwt(A,'sym4');
     %  A=rms(A);
      %  A=autocorr(A);
        X = [X; A];
    end
   % plot(Fv, abs(X(Iv))*2,'DisplayName',sensors(j));
    Y = [Y; X'];
end
finalMat = abs(Y');
ZScore = zscore(finalMat);
[coeff, score, latent, tsquared, explained, mu] = pca(ZScore);
%disp(size(finalMat));
NewFeature = ZScore * coeff;
%disp(NewFeature);
[row , col] = size(NewFeature);
newcol = zeros(row,1);

for j=1:20
    newcol(j)=1;
end

NewFeature=[NewFeature newcol];
aboutmatrixTraining=[];
aboutmatrixTest=[];
k=1;
for k=1:20:200
    tempTraining=NewFeature(k:k+11,:);
    tempTest=NewFeature(k+12:k+19,:);
    aboutmatrixTraining= [aboutmatrixTraining;tempTraining];
    aboutmatrixTest= [aboutmatrixTest;tempTest];
    
end
trainrraylabel=zeros(120,1);
testrraylabel=zeros(80,1);
for j=(12*(z-1))+1:12*z
    trainrraylabel(j)=1;
end
for j=(8*(z-1))+1:8*z
    testrraylabel(j)=1;
end

dtreee=fitctree(aboutmatrixTraining(:,1:length(DominantFeature)*4),trainrraylabel);
outputlabel=predict(dtreee,aboutmatrixTest(:,1:length(DominantFeature)*4));
view(dtreee,'mode','graph');

h=[];
h= findall(0,'type','figure','Name','Classification tree viewer');
% Save file
destfile = strcat('C:\Users\kandu\Documents\DM\Assignmnet3\Tree',gestures(z)+"_"+files(m),'.fig');
saveas(h,destfile);
close(h);

title(files(m)+" "+gestures(z));
count=0;
TP=0;
FP=0;
FN=0;
F1_Score=0;
countsvm=0;
TP_SVM=0;
FN_SVM=0;
FP_SVM=0;

svm=fitcsvm(aboutmatrixTraining(:,1:length(DominantFeature)*4),trainrraylabel);
outputlabelsvm=predict(svm,aboutmatrixTest(:,1:length(DominantFeature)*4));

%Neural Network

classlabel = zeros(row,1);
for k=((z-1)*20)+1:((z-1)*20)+20
    classlabel(k)=1;
end

neuralTrain=NewFeature';
neuralLabel=classlabel';

net=patternnet(500);

[net,tr] = train(net,NewFeature',classlabel');
nntraintool;
TX=neuralTrain(:,tr.testInd);
TT=neuralLabel(:,tr.testInd);
TY=net(TX); 
testIndices = vec2ind(TY);
plotconfusion(TT,TY);
[c,cm] = confusion(TT,TY);
plotroc(TT,TY);

for l=1:80
    if(outputlabel(l,1)==testrraylabel(l,1))
        count=count+1;
    end
    if(outputlabelsvm(l,1)==testrraylabel(l,1))
        countsvm=countsvm+1;
    end
    if(outputlabel(l,1)==1 && testrraylabel(l,1)==1)
        TP=TP+1;
    end
    if(outputlabel(l,1)==0 && testrraylabel(l,1)==1)
        FN=FN+1;
    end
     if(outputlabel(l,1)==1 && testrraylabel(l,1)==0)
        FP=FP+1;
     end
    
     %SVM
     if(outputlabelsvm(l,1)==1 && testrraylabel(l,1)==1)
        TP_SVM=TP_SVM+1;
    end
    if(outputlabelsvm(l,1)==0 && testrraylabel(l,1)==1)
        FN_SVM=FN_SVM+1;
    end
     if(outputlabelsvm(l,1)==1 && testrraylabel(l,1)==0)
        FP_SVM=FP_SVM+1;
    end
end
accuracy=count/80;
accuracysvm=countsvm/80;
precision=TP/(TP+FP);
recall=TP/(TP+FN);
F1_Score = 2*(recall * precision) / (recall + precision);

%SVM
precision_SVM=TP_SVM/(TP_SVM+FP_SVM);
recall_SVM=TP_SVM/(TP_SVM+FN_SVM);
F1_Score_SVM = 2*(recall_SVM * precision_SVM) / (recall_SVM + precision_SVM);

tempacctree = [ files(m),gestures(z),'decision tree', num2str(accuracy),'svm',accuracysvm,'precision',precision,'recall',recall,'F1_score',F1_Score];
tempaccsvm=[ files(m),gestures(z),'svm',accuracysvm,'precision',precision_SVM,'recall',recall_SVM,'F1_score',F1_Score_SVM];
            if (z==1)
                finalacc = tempacctree;
                finalaccsvm = tempaccsvm;
            else
                finalacc = cat(1, finalacc, tempacctree);
                 finalaccsvm = cat(1, finalaccsvm, tempaccsvm);
            end  

           
        
end
if(m==1)
    finalfilesTree=finalacc;
    finalfilessvm=finalaccsvm;
else
    finalfilesTree=cat(1,finalfilesTree,finalacc);
    finalfilessvm=cat(1,finalfilessvm,finalaccsvm);

end
end


    



    


