close all;
clear all;
addpath('LFW_image');
addpath('libsvm_matlab');
addpath('Politic_image');

load('LFW_meta.mat')

%calculate the number of training samples and testing samples
count_train = 0;
count_test = 0;
for i = 1 : 3795
    if is_train(i,1)
        count_train = count_train + 1;
    else 
        count_test = count_test + 1;
    end
end

%training
for attr = 1 : 73 %for each attribute (there are 73 attributes in all)
    flag = zeros(count_train,1); %flag of image i to determine if attribute value is zero
    index = 1;
    for i = 1 : count_train %each training image
        if attribute_annotation(i,attr) == 0
            flag(i,1) = 1;
        end
        if flag(i,1) == 0
            training_label_vector(index,1) = attribute_annotation(i,attr);
            training_instance_matrix(index,:) = landmark(i,:);
            index = index + 1; 
        end
    end
    
    w_1 = sum(attribute_annotation(1:count_train,attr) == 1);
    w_minus1 = sum(attribute_annotation(1:count_train,attr) == -1);
    
    model(attr) = struct(svmtrain(training_label_vector, training_instance_matrix, strcat('-s 0 -t 2 -c 10 -b 1') ));
    [predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model(attr), '-b 1');

    %training error
%     training_error(attr) = 100 - accuracy_training(1,1);
    accuracy_training_lm(attr) = accuracy_training(1,1);
    mean_squared_err_training_lm(attr) = accuracy_training(2,1);
end
%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%testing
for attr = 1 : 73 %for each attribute (there are 73  attributes in all)
    flag = zeros(count_test,1); %flag of image i to determine if attribute value is zero
    index = 1;
    for i = 1 : count_test
        if attribute_annotation(i+count_train,attr) == 0 
            flag(i,1) = 1;
        end
        if flag(i,1) == 0
            testing_label_vector(index,1) = attribute_annotation(i+count_train,attr);
            testing_instance_matrix(index,:) = landmark(i+count_train,:);
            index = index + 1;
        end
    end
    [predicted_label_testing, accuracy_testing, prob_estimates_testing] = svmpredict(testing_label_vector, testing_instance_matrix, model(attr), '-b 1');
    
    test_pos = 0;
    test_neg = 0;
        t = size(testing_label_vector(:,1));
    for i = 1 : t(1)
        if testing_label_vector(i,1) == 1
            test_pos = test_pos + 1;
        end
        if testing_label_vector(i,1) == -1
            test_neg = test_neg + 1;
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
    
    avg_precision_lm(attr) = ((predicted_pos/test_pos) + (predicted_neg/test_neg)) /2 * 100;
    
%     testing_error(attr) = 100 - accuracy_testing(1,1);
    accuracy_testing_lm(attr) = accuracy_testing(1,1);
    mean_squared_err_testing_lm(attr) = accuracy_testing(2,1);
end

save accuracy_training_lm.mat accuracy_training_lm;
save accuracy_testing_lm.mat accuracy_testing_lm;
save mean_squared_err_traning_lm.mat mean_squared_err_training_lm;
save mean_squared_err_testing_lm.mat mean_squared_err_testing_lm;
save avg_precision_lm.mat avg_precision_lm;
