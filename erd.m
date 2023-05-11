function ERD = erd(ch,EEG)

Prest = mean(EEG(ch,1:400,:));
P = mean(EEG(ch,1:1800,:));
ERD = 
end
