function [EEG_Frequencies] = get_SSA_Freqs(X)


[EEG_Frequencies.Delta] = get_SSA_EEG(X,0.2,3.9);
[EEG_Frequencies.Theta] = get_SSA_EEG(X,4,7.9);
[EEG_Frequencies.Alpha] = get_SSA_EEG(X,8,12.9);
[EEG_Frequencies.Beta] = get_SSA_EEG(X,13,40);
[EEG_Frequencies.Gamma] = get_SSA_EEG(X,40,60);
