function [EEG_Frequencies] = get_SSA_Freqs(X,SSA_WINDOW)

[EEG_Frequencies.Delta,~] = get_SSA_EEG(X,0.2,3.9,SSA_WINDOW);
[EEG_Frequencies.Delta,~] = get_SSA_EEG(X,4,7.9, SSA_WINDOW);
[EEG_Frequencies.Alpha,~] = get_SSA_EEG(X,8,12.9,SSA_WINDOW);
[EEG_Frequencies.Beta,~] = get_SSA_EEG(X,13,40,SSA_WINDOW);
[EEG_Frequencies.Gamma,~] = get_SSA_EEG(X,40,60,SSA_WINDOW);
EEG_Frequencies.Concat = [EEG_Frequencies.Delta;EEG_Frequencies.Delta...
    EEG_Frequencies.Alpha,EEG_Frequencies.Beta,EEG_Frequencies.Gamma]';

end
