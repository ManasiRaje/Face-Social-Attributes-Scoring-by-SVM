%4A
close all;
clear all;
addpath('LFW_image');
addpath('libsvm_matlab');
addpath('Politic_image');
load('hogfeat_new_1col_4A.mat');
load('model3B.mat');
load('LFW_meta.mat');
sdirectory = 'Politic_image';
jpgfiles = dir([sdirectory '\*.jpg']);

for i = 1 : 235 %each politician's image
    filename = [sdirectory '\' jpgfiles(i).name];
    im = (imread(filename));
    im = reshape(im,750,250);
    for m = 1 : 73 %there are 73 models/classifiers
        [predicted_label, accuracy, prob_estimates] = svmpredict(attribute_annotation(1:750,m) , double(im), model(m),'-b 1');
        prob(i,m) = prob_estimates(m,1);
    end
end

for attr = 1 : 73
    
    training_label_vector = 1;
    training_instance_matrix = double(prob(:,attr));
            
    model(attr) = struct(svmtrain(training_label_vector, training_instance_matrix, '-s 0 -t 2 -v 3 -g 0.01 -c 10 -h 1 -b 1'));
    [predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model(attr), '-b 1');

    pos = 0;
    neg = 0;
    t = size(testing_label_vector(:,1));
    for i = 1 : t(1)
        if testing_label_vector(i,1) == 1
            pos = pos + 1;
        end
        if testing_label_vector(i,1) == -1
            neg = neg + 1;
        end
        
    end
    
    predicted_pos = 0;
    predicted_neg = 0;

    for i = 1 : t(1)
        if testing_label_vector(i,1) == predicted_label_testing(i,1) 
            if predicted_label_testing(i,1) == 1
                predicted_pos = predicted_pos + 1;
            else
                predicted_neg = predicted_neg + 1;
            end
        end
    end
    
    avg_precision_4B(attr) = ((predicted_pos/pos) + (predicted_neg/neg)) /2 * 100;
    
    accuracy_4B(attr) = accuracy_training(1,1);
    mean_squared_err_4B(attr) = accuracy_training(2,1);
end

% %---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

save accuracy_4B.mat accuracy_4B;
save mean_squared_err_4B.mat mean_squared_err_4B;
save avg_precision_4B.mat avg_precision_4B;

