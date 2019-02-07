
clc;
clear;
moves = readtable('moves.xlsx', 'ReadRowNames', true);

% % Full Section
%   close all;
% 
%   pressF2();
%   recObj = audiorecorder(8000,24,1);
%   disp('Start speaking.')
%   runtime = 10;
%   record(recObj, runtime);
%   t = timer('ExecutionMode', 'singleShot', 'StartDelay', runtime, 'TimerFcn', @pressEnter);
%   start(t);
%   ride = input('Record Ride', 's');
%   stop(t);
%   delete(t);
%   disp('End of Recording.');
% 
%   interTable = calcscore(ride , moves);
%   times = gettimes(recObj);
%   run = mergeTables(times, interTable);
% 
%   disp(run);
%   writetable(run,'run.csv','WriteRowNames',true);

%% Showing timer function. 
% 
%   close all;
% 
%   recObj = audiorecorder(8000,24,1);
%   disp('Start speaking.')
%   runtime = 10;
%   recordblocking(recObj, runtime);
%   disp('End of Recording.');
% 
%   times = gettimes(recObj);
% 


%% Showing calc and merge

ride = 'back roundhouse left cartwheel right shuvit left split wheel air screw right';
[interTable, timeIndexs, moveIndexs] = calcscore(ride , moves);

times = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
times = seconds(times);
run = mergeTables(times, interTable, timeIndexs, moveIndexs);
disp(run)


writetable(run,'run.csv','WriteRowNames',true);


%% Potentially useful code
% x = 'charlotte car will spacegodzilla'
% potentialmoves = readtable('potentialmoves.xlsx')
% beginning = strfind(quietParts',[0 1 ]);
% ending = strfind(quietParts', [1 0]);\


function [interTable, timeIndexs, moveIndexs] = calcscore(rawRun, moves)

timeIndexs = zeros(1,100);
moveIndexs = zeros(1,100);
movesMade = strings(1,100);
skipNextWord = 0;

rawRun = lower(rawRun);
individualWords = strsplit(rawRun,' ');

% Looping through the run to find how many moves were done and their
% indexs.
for idx = 1:(length(individualWords))
    if skipNextWord
        skipNextWord = 0;
        continue; %Skips the next word 
    end 
    isamove = strcmp(moves.Properties.RowNames, individualWords{idx});
    if sum(isamove) == 0
        if idx < (length(individualWords)) % check unrecognised move isnt the last in the list
            twomoves = strcat (individualWords{idx},{' '},individualWords{idx+1});
            isamove = strcmp(moves.Properties.RowNames, twomoves);
            if sum(isamove) == 1
                timeIndexs(idx) = 1;
                movesMade(idx) = char(twomoves);
                moveIndex = find(ismember(moves.Properties.RowNames,char(twomoves)));
                moveIndexs(idx) = moveIndex;
                skipNextWord = 1;
            end
        end
    else
        timeIndexs(idx) = 1;
        movesMade(idx) = individualWords{idx};
        moveIndex = find(ismember(moves.Properties.RowNames,individualWords{idx}));
        moveIndexs(idx) = moveIndex;
    end
end

moveIndexs = moveIndexs(moveIndexs~=0);
timeIndexs = find(timeIndexs);

for i = 1:(length(timeIndexs))
    if((i+1) < length(timeIndexs))
        splicedRun{(i)} = individualWords(timeIndexs(i):(timeIndexs(i+1)-1));
    else
        splicedRun{(i)} = individualWords(timeIndexs(i):length(individualWords));
    end
end

numOfRows = length(timeIndexs);

%Create table with rows depending on the number of moves.
interTable = table('Size',[numOfRows 5],'VariableTypes',{'string','string','int16', 'int16', 'int16'},'VariableNames',{'bonus','direction','bonusScore','baseScore','moveScore'});
interTable.bonus(1:numOfRows) = "None";

movesMade = movesMade(movesMade~="");
interTable.Properties.RowNames = movesMade;

% Populate the table.
for index = 1:numOfRows
    
    interTable.baseScore(index) = moves{moveIndexs(index),'BaseScore'};
    
    for i = 1:(length(splicedRun{index}))
        
        if strcmp(splicedRun{index}(i),'clean')
            interTable.bonusScore(index) = moves{moveIndexs(index),'Clean'};
            interTable.bonus(index) = "Clean";
        elseif strcmp(splicedRun{index}(i),'huge')
            interTable.bonusScore(index) = moves{moveIndexs(index),'Huge'};
            interTable.bonus(index) = "Huge";
        elseif strcmp(splicedRun{index}(i),'air')
            interTable.bonusScore(index) = moves{moveIndexs(index),'Air'};
            interTable.bonus(index) = "Air";
        end
        if strcmp(splicedRun{index}(i),'linked')
            interTable.bonus(index) = moves{moveIndexs(index),'Linked'};
            %         FIX THIS interTable.bonus(index-1) = moves{(index-1),'Linked'};
            interTable.move{index} = individualWords{index};
        end
        if strcmp(splicedRun{index}(i),'left') || strcmp(splicedRun{index}(i),'right')
            interTable.direction{index} = char(splicedRun{index}(i));
        end
    end
    interTable.moveScore(index) = interTable.bonusScore(index)+interTable.baseScore(index);
    
    %writetable(run,'run.csv','WriteRowNames',true)  ;
end
end

function run = mergeTables(times,interTable, timeIndexs, moveIndexs)

totalscore = 0;

% A = interTable.Properties.RowNames;
% [n, bin] = histc(A, unique(A));

times = times(timeIndexs);
interTable.time(:) = times;

if length(moveIndexs) ~= length(unique(moveIndexs))
    
    [C,idx]=unique(moveIndexs,'stable');%don't sort
    idx=setxor(idx,1:numel(moveIndexs));
    repeating_values=moveIndexs(idx);
    
end



disp(moveIndexs);

for idx = 1:height(interTable)
    totalscore = totalscore + interTable.moveScore(idx);
    interTable.totalScore(idx) = totalscore;
end

% times(numel(interTable.time)) = 0;
interTable.time(:) = times;
interTable.time.Format = 's';

run = interTable;

end