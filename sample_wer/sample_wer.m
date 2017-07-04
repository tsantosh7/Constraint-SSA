clear all;
close all;
clc;


addpath C:\Users\NurulAin\Documents\MATLAB\Spoof\lib\VR-EER

%% load scores
load('genuine_scores.mat')
load('impostor_scores.mat')

%% using the wer function to get the density and DET curve
i_ = impostor_scores;
g_ = genuine_scores;
figure, wer(i_(:), g_(:), [],1); % all (density, FAR FRR, DET, WER)