function output = entropy_metrics_efficient(choice, reward, hr_side, stay)
    metrics = ["win", "lose", "better","worse","stay","switch","winstay",...
    "winswitch","losestay","loseswitch","betterstay","worsestay","betterswitch"...
    "worseswitch", "winbest", "winworse", "losebest", "loseworse",...
    "winbeststay", "winworsestay", "losebeststay", "loseworsestay",...
    "winbestswitch", "winworseswitch", "losebestswitch", "loseworseswitch"];


    if ~exist('stay', 'var')
        stats_subset.stay = choice(2:end)==choice(1:end-1);
        stats_subset.win = reward(1:end-1)==1;
        stats_subset.lose = ~stats_subset.win;
        stats_subset.better = choice(1:end-1)==hr_side(1:end-1);
        stats_subset.worse = ~stats_subset.better;        
    else
        stats_subset.stay = stay;
        stats_subset.win = reward==1;
        stats_subset.lose = ~stats_subset.win;
        stats_subset.better = choice==hr_side;
        stats_subset.worse = ~stats_subset.better;                
    end
    stats_subset.switch = ~stats_subset.stay;
    
    stats_subset.winstay = stats_subset.stay.*stats_subset.win;
    stats_subset.winswitch = stats_subset.switch.*stats_subset.win;
    stats_subset.losestay = stats_subset.stay.*stats_subset.lose;
    stats_subset.loseswitch = stats_subset.switch.*stats_subset.lose;
    
    stats_subset.betterstay = stats_subset.stay.*stats_subset.better;
    stats_subset.worsestay = stats_subset.stay.*stats_subset.worse;
    stats_subset.betterswitch = stats_subset.switch.*stats_subset.better;
    stats_subset.worseswitch = stats_subset.switch.*stats_subset.worse;
    
    stats_subset.winbest = stats_subset.win.*stats_subset.better;
    stats_subset.winworse = stats_subset.win.*stats_subset.worse;
    stats_subset.losebest = stats_subset.lose.*stats_subset.better;
    stats_subset.loseworse = stats_subset.lose.*stats_subset.worse;
    
    stats_subset.winbeststay = stats_subset.winbest.*stats_subset.stay;
    stats_subset.winworsestay = stats_subset.winworse.*stats_subset.stay;
    stats_subset.losebeststay = stats_subset.losebest.*stats_subset.stay;
    stats_subset.loseworsestay = stats_subset.loseworse.*stats_subset.stay;
    stats_subset.winbestswitch = stats_subset.winbest.*stats_subset.switch;
    stats_subset.winworseswitch = stats_subset.winworse.*stats_subset.switch;
    stats_subset.losebestswitch = stats_subset.losebest.*stats_subset.switch;
    stats_subset.loseworseswitch = stats_subset.loseworse.*stats_subset.switch;
    
    for j = 1:length(metrics)
           stats_subset.(metrics(j)) = nanmean(stats_subset.(metrics(j)));
    end
%EODS
output.EODS_better = -nansum_zero_helper(...
    [stats_subset.betterstay*log2(stats_subset.betterstay/stats_subset.better),...
    stats_subset.betterswitch*log2(stats_subset.betterswitch/stats_subset.better)], 'all');
output.EODS_worse = -nansum_zero_helper(...
    [stats_subset.worsestay*log2(stats_subset.worsestay/stats_subset.worse),...
    stats_subset.worseswitch*log2(stats_subset.worseswitch/stats_subset.worse)], 'all');
output.EODS = nansum_zero_helper(...
    [output.EODS_better,...
    output.EODS_worse], 2);

%ERDS
output.ERDS_win = -nansum_zero_helper(...
    [stats_subset.winstay*log2(stats_subset.winstay/stats_subset.win),...
    stats_subset.winswitch*log2(stats_subset.winswitch/stats_subset.win)], 'all');
output.ERDS_lose = -nansum_zero_helper(...
    [stats_subset.losestay*log2(stats_subset.losestay/stats_subset.lose),...
    stats_subset.loseswitch*log2(stats_subset.loseswitch/stats_subset.lose)], 'all');
output.ERDS = nansum_zero_helper(...
    [output.ERDS_lose, ...
   output.ERDS_win], 2);

%ERODS
    output.ERODS_winbetter = -nansum_zero_helper([stats_subset.winbeststay*log2(stats_subset.winbeststay/stats_subset.winbest),...
        stats_subset.winbestswitch*log2(stats_subset.winbestswitch/stats_subset.winbest)], 'all');
    output.ERODS_loseworse = -nansum_zero_helper([...
        stats_subset.loseworsestay*log2(stats_subset.loseworsestay/stats_subset.loseworse),...
        stats_subset.loseworseswitch*log2(stats_subset.loseworseswitch/stats_subset.loseworse)], 'all');
    output.ERODS_losebetter = -nansum_zero_helper([...
        stats_subset.losebeststay*log2(stats_subset.losebeststay/stats_subset.losebest),...
        stats_subset.losebestswitch*log2(stats_subset.losebestswitch/stats_subset.losebest)], 'all');
    output.ERODS_winworse = -nansum_zero_helper([stats_subset.winworsestay*log2(stats_subset.winworsestay/stats_subset.winworse),...
        stats_subset.winworseswitch*log2(stats_subset.winworseswitch/stats_subset.winworse)], 'all');
    output.ERODS= nansum_zero_helper([output.ERODS_winworse, output.ERODS_winbetter,...
        output.ERODS_loseworse, output.ERODS_losebetter], 'all');
end