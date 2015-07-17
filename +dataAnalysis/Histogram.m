% Create uft histogram with log normal and gamma pdf functions
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'XTick',[0 15 30 45 60 75 90 105],...
    'FontSize',17,'box', 'on',...
    'FontName','Times');
box(axes1,'on');
hold(axes1,'all');

axis([0 95 0 0.05]);

% Create bar
bar(x,f/trapz(x,f),...      %divide by area to normalize
    'FaceColor',[0.20392157137394 0.301960796117783 0.494117647409439],...
    'BarWidth',1,...
    'Parent',axes1,...
    'DisplayName','frequency');            

% plot1 = plot(x,[y;y2],'Parent',axes1);
% set(plot1(1),'line','--', 'LineWidth', 1.5, 'Color',[0 1 0],'DisplayName','lognormal fit');
% set(plot1(2),'line', '-.','LineWidth', 1.5, 'Color',[1 0 0],'DisplayName','gamma fit');

% Create xlabel
xlabel('Fluid Threshold Shear Velocity (m/s)','FontSize',20,...
    'FontName','Times');

% Create ylabel
ylabel('Probability Density (s/m)','FontSize',20,'FontName','Times');

% Create title
title('Distribution of u_{ft} for D_m = 0.1mm', 'FontSize', 22);

% Inflection point
%plot2 = plot(uftInflec,(y(Result(1)) + y(Result(1) + 1))/2,'kx', 'MarkerSize',15, 'DisplayName','inflection point of lognormal pdf')

% Create legend
%legend(axes1,'show');