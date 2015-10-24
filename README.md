# Face-Social-Attributes-Scoring-by-SVM
How do we measure the social dimensions of faces in political elections and social networks?

Face Social Attribute Scoring by SVM
 
Objective:

This project is an exercise for studying the social attributes of human faces using Support Vector Machines. We have collected a set of face images of US politicians, and in some cases we have a pair of images for the two competing candidates running for public offiices: congress, senator or governor. We divide these faces into training and testing subsets. We asked human subjects to give relative scores of two faces shown on screen (unfamiliar to the subject) which one is more 'honest', 'intelligent', etc. These relative scores will be used to train the weights over certain geometric and appearance features extracted from the images. Then we use the learned weights to predict the scores of a new face.
Furthermore, we train a second layer SVM classifier to predict the winner and loser for a pair of faces, based on the scores of their social attributes. This turns out to predict the electon results for more than 60%.

1) Design facial features for predicting the social attributes.

2) Using SVM to learn the weights of the features to fit the human scores on various social attributes.

3) Using SVM to predict the election results based on the social attributes.

4) Discover the features that contribute the most to each social attributes, and to the election results for various types of publical offices.


Tools: LibSVM for Matlab
 
 

