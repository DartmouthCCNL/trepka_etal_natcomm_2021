function h = mysigstar22(xpos, ypos, pval, ax, linewid, whichWay, yjitter)
% replaces sigstar, which doesnt work anymore in matlab 2014b

if ~exist('ax', 'var'); ax = gca; end
if ~exist('color', 'var'); color = 'k'; end
if ~exist('whichWay', 'var'), whichWay = 'down'; end

if numel(ypos) > 1,
    assert(ypos(1) == ypos(2), 'line wont be straight!');
    ypos = ypos(1);
end
mrange = range(get(gca,'ylim'));
% draw line
hold on;
if 1 && numel(xpos) > 1,
    % plot the horizontal line
    p = plot(ax, [xpos(1), xpos(2)], ...
        [ypos ypos], '-', 'LineWidth', linewid, 'color', color);
    newY = ypos;
    %     % also add small downward ticks
        switch whichWay
            case 'down'
                plot([xpos(1) xpos(1)], [newY newY-0.025*mrange], '-k', 'LineWidth', linewid, 'color', color);
                plot([xpos(2) xpos(2)], [newY newY-0.025*mrange], '-k', 'LineWidth', linewid, 'color', color);
                yjitter = 0.025*mrange;
            case 'up'
                plot([xpos(1) xpos(1)], [newY newY+0.025*mrange], '-k', 'LineWidth', linewid, 'color', color);
                plot([xpos(2) xpos(2)], [newY newY+0.025*mrange], '-k', 'LineWidth', linewid, 'color', color);
                yjitter = -0.025*mrange;
        end
    
    % use white background
    txtBg = 'none';
else
    txtBg = 'none';
end

fz = 10; fontweight = 'bold';
fz = 15;
    yjitter = yjitter*1.25;
if pval < 1e-3
    txt = '***';
elseif pval < 1e-2
    txt = '**';
elseif pval < 0.05
    txt = '*';
    fz = 15;
elseif ~isnan(pval),
    % this should be smaller
    txt = 'n.s.';
    %txt = '';
    fz = 10; fontweight = 'normal';
else
    return
end
%txt = texlabel(txt);

% draw the stars in the bar
h = text(mean(xpos), mean(ypos)+yjitter, txt, ...
    'horizontalalignment', 'center', 'backgroundcolor', ...
    txtBg, 'margin', 1, 'fontsize', fz, 'fontweight', fontweight, 'color', color, 'Parent', ax);
end