alpha_pred=alphavec(end-95:end);
beta_pred=betavec(end-95:end);
retGOOG_pred=retGOOG(end-95:end);
retTTWO_pred=retTTWO(end-95:end);

PL=0;
for i=3:length(alpha_pred)-1
    pred_prof=YPred2(i+1)-mean(YTest(i-2:i));
    if pred_prof > 0
        daily_PL=-retGOOG_pred(i+1)+beta_pred(i+1)*retTTWO_pred(i+1)-alpha_pred(i+1);
    elseif pred_prof < 0
        daily_PL=retGOOG_pred(i+1)-beta_pred(i+1)*retTTWO_pred(i+1)-alpha_pred(i+1);
    else
        daily_PL=0;
    end
    PL(i)=daily_PL;
end

cum_PL=cumsum(PL)*100;

plot(cum_PL')