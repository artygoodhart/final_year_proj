function [interTable, moveIndexs] = a(rawRun, moves)
import java.util.*; %used Java's library to create dynamic arrays.
moveIndexs = Stack();
movesMade = Stack();

% score = 0;
rawRun = lower(rawRun);
splitRun = strsplit(rawRun,' ');

% Looping through the run to find how many moves were done and their
% indexs.
for idx = 1:(numel(splitRun))
    isamove = strcmp(moves.Properties.RowNames, splitRun{idx});
    if sum(isamove) == 0
        if idx < (length(splitRun)) % check unrecognised word isnt the last in the list
            twowords = strcat (splitRun{idx},{' '},splitRun{idx+1});
            class(twowords)
            isamove = strcmp(moves.Properties.RowNames, twowords);
            if sum(isamove) == 1
                moveIndexs.push(idx)
                movesMade.push(char(twowords));
            end
        end
    else
        moveIndexs.push(idx)
        movesMade.push(splitRun{idx});
    end
end

disp(movesMade)

numOfRows = moveIndex.size;
%Create table with rows depending on the number of moves.
interTable = table('Size',[numOfRows 5],'VariableTypes',{'string','string','string','int8', 'int8',},'VariableNames',{'move','bonus','direction','bonusScore','baseScore'});


% Populate the table.
for idx = 1:(numel(splitRun))
    
    if strcmp(splitRun{idx},'clean')
        interTable.bonus(idx) = moves{index,'Clean'};
        interTable.word{idx} = splitRun{idx};
    elseif strcmp(splitRun{idx},'huge')
        interTable.bonus(idx) = moves{index,'Huge'};
        interTable.word{idx} = splitRun{idx};
    elseif strcmp(splitRun{idx},'air')
        interTable.bonus(idx) = moves{index,'Air'};
        interTable.word{idx} = splitRun{idx};
    elseif strcmp(splitRun{idx},'linked')
        interTable.bonus(idx) = moves{index,'Linked'};
        interTable.bonus(idx-1) = moves{(index-1),'Linked'};
        interTable.word{idx} = splitRun{idx};
    elseif strcmp(splitRun{idx},'left') || strcmp(splitRun{idx},'right')
        interTable.direction{idx} = splitRun{idx};
    else
        
        
        isamove = strcmp(moves.Properties.RowNames, splitRun{idx});
        
        if sum(isamove) == 0
            if idx < (length(splitRun)) % check unrecognised word isnt the last in the list
                twowords = strcat (splitRun{idx},{' '},splitRun{idx+1});
                isamove = strcmp(moves.Properties.RowNames, twowords);
                if sum(isamove) == 1
                    index = find(isamove,1);
                    interTable.word{idx} = char(twowords);
                    interTable.baseScore(idx) = moves{index,'BaseScore'};
                else
                    disp('this word was not recognised');
                    interTable.word{idx} = splitRun{idx};
                end
            end
        else
            interTable.word{idx} = splitRun{idx};
            index = find(isamove,1);
            interTable.baseScore(idx) = moves{index,'BaseScore'};
            moveIndexs.push(idx)
        end
        
        %         interTable.totalscore(i) = score;
        
        %writetable(run,'run.csv','WriteRowNames',true)  ;
    end
end

end

