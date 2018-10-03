
gestures={'About' 'And' 'Can' 'Cop' 'Deaf' 'Decide' 'Father' 'Find' 'GoOut' 'Hearing'};
for a=1:10
    action_number = strcat(gestures{a},'\');
    Cell1 = cell(20,2);
    Cell2 = cell(6,2);
    m={20,23,29,33,35,37};
   for j=1:6
   folder = sprintf('DM%d',m{j});
   path = 'C:\Users\kandu\Documents\DM\Asgesturesment2\Data\';
   source_folder = strcat(path,action_number,folder);
   desti_folder = 'C:\Users\kandu\Documents\MATLAB\OutputData\CanDemo\';
   source_files = dir(fullfile(source_folder, '*.csv'));
   for k = 1:length(source_files)
    data = xlsread(fullfile(source_folder,source_files(k).name));
    getData = data.';
    getData = getData(1:34,1:42);
    Cell1{k,2} = getData; 
    feature = {'ALX' 'ALY' 'ALZ' 'ARX' 'ARY' 'ARZ' 'EMG0L' 'EMG1L' 'EMG2L' 'EMG3L' 'EMG4L' 'EMG5L' 'EMG6L' 'EMG7L' 'EMG0R' 'EMG1R' 'EMG2R' 'EMG3R' 'EMG4R' 'EMG5R' 'EMG6R' 'EMG7R' 'GLX' 'GLY' 'GLZ' 'GRX' 'GRY' 'GRZ' 'ORL' 'OPL' 'OYL' 'ORR' 'OPR' 'OYR'};
    Action_NUmber = sprintf('Action%d  ',k);
    Action_NUmber = strcat(Action_NUmber,feature);
    tempee = Action_NUmber.';
    Cell1{k,1} = tempee;
   end
   matrix = [cell2mat(Cell1(1,2)); cell2mat(Cell1(2,2))];
   Header_names = [table(Cell1{1,1}); table(Cell1{2,1})];
   for i=3:20
       matrix = [matrix; cell2mat(Cell1(i,2))];
       Header_names = [Header_names; table(Cell1{i,1})];
   end
   Cell2{j,1}=Header_names;
   Cell2{j,2}=matrix;
   end
   col1 = [table(Cell2{1,1}); table(Cell2{2,1})];
   col2 = [table(Cell2{1,2}); table(Cell2{2,2})];
   for n = 3:6
    col1 = [col1; table(Cell2{n,1})];
    col2 = [col2; table(Cell2{n,2})];
   end
   y = table2array(col1);
   z = table2array(col2);
   x = [y num2cell(z)];
   final_file = strcat(desti_folder,gestures{a},'.xls');
   writetable(x,final_file);
end