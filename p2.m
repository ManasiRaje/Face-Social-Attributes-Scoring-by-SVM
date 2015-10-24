%PCA over hogfeatures :-


% Find the hogfeatures for all the images
sdirectory = 'LFW_image';
jpgfiles = dir([sdirectory '\*.jpg']);

for k = 1:length(jpgfiles)
    
    filename = [sdirectory '\' jpgfiles(k).name];
    im = imread(filename);
    im = double(im);
    hogfeat(:,:,:) = HoGfeatures(im);
    %convert this 3D array into 1D
    all_hf(:,k) = double(reshape(hogfeat,[26912,1]));
end

all_hf = vertcat(all_hf,landmark');

%PCA on hogfeatures
%compute the mean
% mean_hf = double(mean(all_hf,2));
[r,c] = size(all_hf);
for i=1:r
    mean_hf(i,1) = sum(all_hf(i,:)/c);
end

%diff_matrix for the warpings
[r,c] = size(all_hf);
for i = 1 : c
    diff_matrix(:,i) = double(all_hf(:,i)) - mean_hf(:,1);
end
%scatter_matrix
scatter_matrix = diff_matrix' * diff_matrix;
%eigen_vectors
[U,L,V] = svd(scatter_matrix);
e = diff_matrix * U;
%normalize the eigen_vectors
for i = 1 : 3795
    e(:,i) = e(:,i)/norm(e(:,i));
end

e_reduced = e(:,1:250);
% matrix of principal components
% a = e_reduced' * diff_matrix;
hogfeat_new = e_reduced' * diff_matrix;
save hogfeat_new_1col.mat hogfeat_new;
%--------------------------------------------------------------------------------------------------------------------------------
