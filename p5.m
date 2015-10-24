%4A
clear all;
addpath('LFW_image');
addpath('libsvm_matlab');
addpath('Politic_image');
load('hogfeat_new_1col_4A.mat');
load('Politic_meta.mat');

% classifier 1 : election outcome
attr = 1;
    
    training_label_vector = double(politic_label_win_loss(:,1));
    training_instance_matrix = double(hogfeat_new_4A);
    cv(attr) = svmtrain(training_label_vector, training_instance_matrix, '-s 0 -t 2 -v 200 -g 0.01 -c 10 -b 1');

% classifier 2 : party affiliation
attr = 2;
    
    training_label_vector = double(politic_label_dem_gop(:,1));
    training_instance_matrix = double(hogfeat_new_4A);
    
    cv(attr) = svmtrain(training_label_vector, training_instance_matrix, '-s 0 -t 2 -v 200 -g 0.01 -c 10 -h 1 -b 1');

% %---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

save cv_4A.mat cv;