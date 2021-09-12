function b=BarPlotBreak(Y,y_break_start,y_break_end,break_type,scale)

% BarBreakPlot(y,y_break_start,y_break_end,break_type,scale)
% Produces a plot who's y-axis skips to avoid unecessary blank space
% 
% INPUT
% y
% y_break_start
% y_break_end
% break_type
%    if break_type='RPatch' the plot will look torn
%       in the broken space
%    if break_type='Patch' the plot will have a more
%       regular, zig-zag tear
%    if break_plot='Line' the plot will merely have
%       some hash marks on the y-axis to denote the
%       break
% scale = between 0-1, the % of max Y value that needs to subtracted from
% the max value bars
% USAGE:
% figure;
% BarPlotBreak([10,40,1000], 50, 60, 'RPatch', 0.85);
%
% Original Version developed by:
% Michael Robbins
% robbins@bloomberg.net
% michael.robbins@bloomberg.net
%
% Modified by: 
% Chintan Patel
% chintan.patel@dbmi.columbia.edu

% data
if nargin<5 break_type='RPatch'; end;
if nargin<4 y_break_end=40; end;
if nargin<3 y_break_start=10; end;
if nargin<2 y=[1:10,40:50]; end;
if nargin<1 x=rand(1,21); end;

y_break_mid   = (y_break_end-y_break_start)./2+y_break_start;

Y2=Y;
Y2(Y2>=y_break_end)=Y2(Y2>=y_break_end)-(Y2(Y2>=y_break_end)*scale);

%find the max and min and cut max to 1.5 times the min
bar(Y2, 0.5);

my_xlim=get(gca,'xlim');
ytick=get(gca,'YTick');
[junk,i]=min(ytick<=y_break_start);
y=(ytick(i)-ytick(i-1))./2+ytick(i-1);
dy=(ytick(2)-ytick(1))./10;
xtick_m=get(gca,'XTick');

dx=(xtick_m(2)-xtick_m(1))./2;
x=my_xlim(1);
%break_type = 'Patch';
switch break_type
    case 'Patch'
		% this can be vectorized
        dx=(my_xlim(2)-my_xlim(1))./10;
        yy=repmat([y-2.*dy y-dy],1,2);
        xx=my_xlim(1)+dx.*[0:3];
		patch([xx(:);flipud(xx(:))], ...
            [yy(:);flipud(yy(:)-2.*dy)], ...
            [.8 .8 .8])
    case 'RPatch'
		% this can be vectorized
        dx=(my_xlim(2)-my_xlim(1))./100;
        yy=y+rand(101,1).*2.*dy;
        xx=my_xlim(1)+dx.*(0:100);
		patch([xx(:);flipud(xx(:))], ...
            [yy(:);flipud(yy(:)-2.*dy)], ...
            [.8 .8 .8])
    case 'Line'
		h = line([x-dx x   ],[y-2.*dy y-dy   ]);
		line([x    x+dx],[y+dy    y+2.*dy]);
		line([x-dx x   ],[y-3.*dy y-2.*dy]);
		line([x    x+dx],[y+2.*dy y+3.*dy]);
        set(gca, 'xlim', my_xlim);
end;
%ytick(ytick>y_break_start)=ytick(ytick>y_break_start)+y_break_mid;

ytick(ytick>y_break_start)=ytick(ytick>y_break_start)+(Y(Y>=y_break_end)*scale);

for i=1:length(ytick)
   yticklabel{i}=sprintf('%d',ytick(i));
end;
set(gca,'yticklabel',yticklabel);