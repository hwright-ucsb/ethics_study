% clear environment
clearvars;
close all;
clc;
warning('off');

% parameters
restriction = 0; % do you remove everyone with failed attention check

% variables
filename = 'Ethics_May+15,+2020_09.06.csv';
individual = 244; % sonja
individual = 209; % christof
individual = 119; % michel
individual = 249; % moran
last = 581;

%% load data
cd('E:\Biotech\EthicsMorality');
a = readtable(filename,'PreserveVariableNames',1);

% clean
tic
fprintf('\ncleaning...');

a = removevars(a, 'Finished');
a = removevars(a, 'RecordedDate');
a = removevars(a, 'ResponseId');
a = removevars(a, 'RecipientLastName');
a = removevars(a, 'RecipientFirstName');
a = removevars(a, 'RecipientEmail');
a = removevars(a, 'ExternalReference');
a = removevars(a, 'UserLanguage');
a = removevars(a, 'DistributionChannel');

for i=1:15
    eval(sprintf('a = removevars(a,''T%02d_First Click'');',i));
    eval(sprintf('a = removevars(a,''T%02d_Last Click'');',i));
    eval(sprintf('a = removevars(a,''T%02d_Page Submit'');',i));
    eval(sprintf('a = removevars(a,''T%02d_Click Count'');',i));
end

a = a(~(strcmp(a.Status,'1')),:); % This is removing 582 rows out of 583..WHY??

a = removevars(a, 'Status');
a = removevars(a, 'Duration (in seconds)');

a.Properties.VariableNames{1} = 'start';
a.Properties.VariableNames{2} = 'end';
a.Properties.VariableNames{3} = 'ip';
a.Properties.VariableNames{4} = 'progress';
a.Properties.VariableNames{5} = 'lat';
a.Properties.VariableNames{6} = 'long';
a.Properties.VariableNames{7} = 'gender'; %  (1 = male)
a.Properties.VariableNames{8} = 'age';
a.Properties.VariableNames{9} = 'race'; %  (1 = male)
a.Properties.VariableNames{10} = 'education'; %  (1 = male)
a.Properties.VariableNames{11} = 'american'; %  (1 = male)
a.Properties.VariableNames{12} = 'income';
a.Properties.VariableNames{13} = 'attention1'; %  should be empty
a.Properties.VariableNames{14} = 'ethics'; %  
a.Properties.VariableNames{15} = 'attention2'; %  should be exactly as 14
a.Properties.VariableNames{16} = 'liberal'; %  correct
a.Properties.VariableNames{17} = 'religious'; %  correct

for i=18:32
    a.Properties.VariableNames{i} = sprintf('q%02d',i-17);
end

a.Properties.VariableNames{33} = 'comments';

% remove header lines

a(1,:) = [];
a(1,:) = [];

% gender
b = categorical();
for i=1:size(a,1)
    if isempty(a{i,7}{1})
        b(i) = 'other';
    else
        switch str2num(a{i,7}{1})
            case 1
                b(i) = 'male';
            case 2
                b(i) = 'female';
        end
    end
end
b = categorical(b,{'male','female','other'},'Ordinal',true);
a.gender = b';
clear b;

% age
for i=1:size(a,1)
    if isempty(a.age{i})
        b(i) = nan;
    else
        b(i) = str2num(a.age{i});
    end
end
a.age = b';
clear b;

% race
b = categorical;
for i=1:size(a,1)
    if isempty(a{i,9}{1})
        b(i) = 'other';
    else
        switch str2num(a{i,9}{1})
            case 1
                b(i) = 'white';
            case 2
                b(i) = 'black';
            case 3
                b(i) = 'hispanic';
            case 4
                b(i) = 'hispanic';
            case 5
                b(i) = 'hispanic';
            case 6
                b(i) = 'hispanic';
            case 7
                b(i) = 'indian';
            case 8
                b(i) = 'indian';
            case 9
                b(i) = 'asian';
            case 10
                b(i) = 'asian';
            case 11
                b(i) = 'asian';
            case 12
                b(i) = 'asian';
            case 13
                b(i) = 'asian';
            case 14
                b(i) = 'asian';
            case 15
                b(i) = 'pacific';
            case 16
                b(i) = 'pacific';
            case 17
                b(i) = 'pacific';
            case 18
                b(i) = 'pacific';
            case 19
                b(i) = 'other';
        end
    end
end
b = categorical(b,{'white','black','hispanic','asian','indian','pacific','other'},'Ordinal',true);
a.race = b';
clear b;

% education
b = categorical;
for i=1:size(a,1)
    if isempty(a{i,10}{1})
        b(i) = 'other';
    else
        switch str2num(a{i,10}{1})
            case 1
                b(i) = 'school';
            case 2
                b(i) = 'school';
            case 3
                b(i) = 'school';
            case 4
                b(i) = 'college';
            case 5
                b(i) = 'professional';
            case 6
                b(i) = 'ba';
            case 7
                b(i) = 'graduate';
        end
    end
end
b = categorical(b,{'school','professional','college','ba','graduate','other'},'Ordinal',true);
a.education = b';
clear b;

% american
b = categorical;
for i=1:size(a,1)
    if isempty(a{i,11}{1})
        b(i) = 'other';
    else
        switch str2num(a{i,11}{1})
            case 1
                b(i) = 'american';
            case 2
                b(i) = 'international';
            case 3
                b(i) = 'american';
            case 4
                b(i) = 'international';
        end
    end
end
b = categorical(b,{'american','international','other'},'Ordinal',true);
a.american = b';
clear b;

% income
b = categorical;
for i=1:size(a,1)
    if isempty(a{i,12}{1})
        b(i) = 'other';
    else
        switch str2num(a{i,12}{1})
            case 1
                b(i) = '<10k';
            case 2
                b(i) = '10k-15k';
            case 3
                b(i) = '15k-25k';
            case 4
                b(i) = '25k-35k';
            case 5
                b(i) = '35k-50k';
            case 6
                b(i) = '50k-75k';
            case 7
                b(i) = '75k-100k';
            case 8
                b(i) = '100k-150k';
            case 9
                b(i) = '150k-200k';
            case 10
                b(i) = '>200k';
        end
    end
end
b = categorical(b,{'<10k','10k-15k','15k-25k','25k-35k','35k-50k','50k-75k','75k-100k','100k-150k','150k-200k','>200k'},'Ordinal',true);
a.income = b';
clear b;

for i=[4:6 14:32]
    clear b;
    for j=1:size(a,1)
        if isempty(a{j,i}{1})
            b(j) = nan;
        else
            b(j) = str2num(a{j,i}{1});
        end
    end
    eval(sprintf('a.%s = b'';',a.Properties.VariableNames{i}));
end
clear b;

% attention
b = strcmp(a.attention1,'');
a.attention1 = b;

b = (a.ethics == a.attention2);
a.attention2 = b;

% dates
for i=1:size(a,1)
    a.newstart {i} = datetime(a{i,1}{1});
    a.newend {i} = datetime(a{i,2}{1});
end
a.start = a.newstart;
a.end = a.newend;
a = removevars(a, 'newstart');
a = removevars(a, 'newend');

fprintf('done.\n');
toc

if restriction
    % getting rid of partial data
    a = a((a.attention1 == 1) & (a.attention2 == 1) & (a.progress == 100),:);
end
a = removevars(a, 'attention1');
a = removevars(a, 'attention2');
a = removevars(a, 'progress');

warning('on');

clear b i j;

%% summary statistics
figure(100);
clf;
subplot(3,3,1);
histogram(a.gender,'Normalization','probability','BarWidth',0.8);
xtickangle(45);
ylim([0 1]);
title('Gender');
set(gca,'YGrid','on');

subplot(3,3,2);
histogram(a.race,'Normalization','probability','BarWidth',0.8);
xtickangle(45);
ylim([0 1]);
title('Race');
set(gca,'YGrid','on');

subplot(3,3,3);
histogram(a.education,'Normalization','probability','BarWidth',0.8);
xtickangle(45);
ylim([0 1]);
title('Education');
set(gca,'YGrid','on');

subplot(3,3,4);
histogram(a.american,'Normalization','probability','BarWidth',0.8);
xtickangle(45);
ylim([0 1]);
title('Nationality');
set(gca,'YGrid','on');

subplot(3,3,5);
histogram(a.income,'Normalization','probability','BarWidth',0.8);
ylim([0 1]);
title('Income');
set(gca,'YGrid','on');

subplot(3,3,6);
[b,c] = hist(a.liberal,1:7);
bar(b./sum(b),'FaceColor',[0 0 0],'EdgeColor',[1 1 1],'BarWidth',1);
ylim([0 1]);
title('Liberalism');
set(gca,'YGrid','on');
set(gca,'XTickLabel',{'liberal','','','','','','conservative'});
xtickangle(45);

subplot(3,3,7);
[b,c] = hist(a.religious,1:7);
bar(b./sum(b),'FaceColor',[0 0 0],'EdgeColor',[1 1 1],'BarWidth',1);
ylim([0 1]);
title('Religion');
set(gca,'YGrid','on');
set(gca,'XTickLabel',{'secular','','','','','','religious'});
xtickangle(45);

subplot(3,3,9);
text(0.1,0.8,sprintf('n = %d',size(a,1)));
text(0.1,0.4,sprintf('age = %2.1f ± %2.1f\n',nanmean(a.age),nanstd(a.age)));
text(0.1,0.2,sprintf('ethics = %d (times/month)\n',nanmedian(a.ethics)));
axis off;

saveas(gcf,'summary01.png','png');

%% Location 
figure(200);
clf;
worldmap world
geoshow('landareas.shp','FaceColor',[0.5 1.0 0.5])
geoshow(a.lat,a.long,'marker','o','markerfacecolor','black','LineStyle','none');

saveas(gcf,'summary02.png','png');

%% Notes

% mean(a.implant) = 3.31 % [1 deny implant -7 support implant]; 17
% mean(a.ai1) = 4.5 % [1 want ai that helps humanity but becomes uncontrollable - 7 do not want it] 22
% mean(a.ai2) = 4.94 % [1 sentencing 100% by human - 7 100% ai]; 5 = 60% human 27
% mean(a.healthcare) = 3.94 % [1 doctor is machine - 7 doctor is human] =  ~4 = in the middle 32 
% mean(a.privacy1) = 5.51 % [1 share data for perfect experiene  - 7 don't share] = 5.5 = don't share 37
% mean(a.privacy2) = 4.56 % [1 cameras that prevent crime - 7 no cameras]; 4.5 = leaning no cameras 42
% mean(a.consciousness) = 5.99 % [1 consciousness in duplicate - 7 consciousness in me]; 6 = neary absolutely NOT willing to be killed 47 
% mean(a.genetics) = 2.91 % [1 no to engineering babies - 7 support engineering babies]; 3 = leaning no. 52
% mean(a.dreams) = 5.29 % [1 approve dream manipulation - 7 disapprove]; 5.3 = mostly disapprove 57 
% mean(a.research) = 4.49 % [1 no research that is amazing if it poses risk - 7 do the research]; 4.5 = leaning 'do'. 62
% mean(a.cyber1) = 4.29 % [1 ok to respond with military to cyber - 7 not ok]; 4.28 = mostly not ok. 67 
% mean(a.cyber2) = 4.29 % [1 ok to respond with military to cyber - 7 not ok]; 3.60 = mostly not ok. %CYBER KLLED LIVES 72 
% mean(a.robots) = 5.25 % [1 abusive sex with robots - 7 not ok]; 5.25 = mostly not ok. 77
% mean(a.morality1) = 2.83 % [1 wrong to have sex with chicken - 7 ok to have sex]; 2.83 = leaning wrong 82
% mean(a.morality2) = 2.40 % [1 wrong to sleep with sister - 7 ok]; 2.40 = leaning wrong. 87

%% Results
figure(2);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

clf;

reverse_answers = [0 1 0 0 1 1 1 0 1 0 1 1 1 0 0];
titles = {'Implant that will help people but create inequality',...
    'AI that can help humanity but can become uncontrollable',...
    'Legal sentencing by AI',...
    'Diagnosis done by more accurate machine or by human',...
    'Share data and get perfect experiences (but deny services)',...
    'Cameras that see everything and prevent crime',...
    'Money to an alive identical conscious clone',...
    'Engineering babies should be:',...
    'Ultimate understanding of dreams with risk of injecting thoughts',...
    'Remarkable research that creates potential risks',...
    'Military in response to cyber attack',...
    'Military in response to fatal cyber attack',...
    'Sexually abuse robots',...
    'Sex with chicken',...
    'Sex between sibling'
    };
for i=1:15
    subplot(4,4,i);
    
    tmp1 = a{:,i+14};
    [b,c] = hist(tmp1,1:7);
    if reverse_answers(i)
        bar(100.*b(end:-1:1)./sum(b),'FaceColor',[0 0 0],'EdgeColor',[1 1 1],'BarWidth',1);
    else
        bar(100.*b./sum(b),'FaceColor',[0 0 0],'EdgeColor',[1 1 1],'BarWidth',1);
    end
    title(titles{i});
    ylabel('Frequency (%)');
    box on;
    
    switch i
        case {1,2,9,10}
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Deny','','','Neutral','','','Approve'},'YGrid','on');
        case 3
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'AI','80% AI','60% AI','Equal','60% Human','80% Human','Human'},'YGrid','on');
            xtickangle(45);
        case 4
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'AI','','','Equal','','','Human'},'YGrid','on');
        case 5
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Not share','','','Equal','','','Share'},'YGrid','on');
        case 6
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Do not','','','Equal','','','Allow'},'YGrid','on');
        case 7
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Never','','','Equal','','','Absolutely'},'YGrid','on');
        case 8
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Prohibited','','','Equal','','','Allowed'},'YGrid','on');
        %case 10
        %    set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Do not do','','','Equal','','','Do'},'YGrid','on');
        case {11,12,13}
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Not OK','','','Equal','','','OK'},'YGrid','on');
        case {14,15}
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Wrong','','','Equal','','','OK'},'YGrid','on');           
    end
    set(get(gca,'title'),'Position',[4 105 0]);
    pbaspect([1 1 1]);
    xlim([0.5 7.5]);
    ylim([0 100]);
    set(gca,'YTickLabel',{'','20','40','60','80','100'});
    if reverse_answers(i)
        line([8-nanmean(tmp1) 8-nanmean(tmp1)],[0 100],'LineStyle',':','Color','red','LineWidth',2);
    else
        line([nanmean(tmp1) nanmean(tmp1)],[0 100],'LineStyle',':','Color','red','LineWidth',2);
    end
    if individual
        if ~isnan(tmp1 (individual))
            tmp2 = tmp1 (individual);
            if reverse_answers(i)
                line([8-tmp2 8-tmp2],[0 100],'LineStyle',':','Color','blue','LineWidth',2)
            else
                line([tmp2 tmp2],[0 100],'LineStyle',':','Color','blue','LineWidth',2)
            end
        end
    end
    clear tmp1 tmp2;
end

subplot(4,4,11,'Color',[0.8 0.8 0.8]);
subplot(4,4,12,'Color',[0.8 0.8 0.8]);

subplot(4,4,16);
hold on;
bar(0,0,'blue');
bar(0,0,'red');
text(0.1,0.8,sprintf('n = %d',size(a,1)));
ylim([0 1]);
legend('You','Mean','Location','SouthEast');
if individual
    text(-1,0.9,sprintf('Gender: %s',string(a{individual,6})));
    text(-1,0.8,sprintf('Age: %d',a{individual,7}));
    text(-1,0.7,sprintf('Race: %s',string(a{individual,8})));
    text(-1,0.6,sprintf('Education: %s',string(a{individual,9})));
    text(-1,0.5,sprintf('Nationality: %s',string(a{individual,10})));
    text(-1,0.4,sprintf('Income: %s',string(a{individual,11})));
    text(-1,0.3,sprintf('Monthly ruminations on ethichs: %d',a{individual,12}));
    text(-1,0.2,sprintf('Liberal (1) - Conservative (7): %d',a{individual,13}));
    text(-1,0.1,sprintf('Secular (1) - Religious (7): %d',a{individual,14}));
    if ~isempty(a.comments {individual})
        if length(a.comments {individual}) > 50
            text(-1,-0.1,a.comments {individual}(1:50));
            text(-1,-0.2,a.comments {individual}(51:end));
        else
            text(-1,-0.1,a.comments {individual});
        end
    end
end
axis off;

saveas(gcf,sprintf('%04d.png',individual),'png');