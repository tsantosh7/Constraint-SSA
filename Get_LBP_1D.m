function [FreqLBP] = Get_LBP_1D(EEG,segsize)

    [FreqLBP.Alpha,~]= onedlbp(EEG.Alpha,segsize);
    [FreqLBP.Beta,~]= onedlbp(EEG.Beta,segsize);
    [FreqLBP.Theta,~]= onedlbp(EEG.Theta,segsize);
    [FreqLBP.Gamma,~]= onedlbp(EEG.Gamma,segsize);
    [FreqLBP.Delta,~]= onedlbp(EEG.Delta,segsize);
     FreqLBP.Concat = [FreqLBP.Alpha;FreqLBP.Beta;FreqLBP.Theta;...
         FreqLBP.Gamma;FreqLBP.Delta]';

end