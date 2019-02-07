function a = mergeTables(times,interTable)


  totalscore = 0;
  run = table('Size',[0 5],'VariableTypes',{'duration','string','int16','int16','int16'},'VariableNames',{'time','move','bonus','baseScore','totalScore'});
  nonWordIdx = find(interTable.naMove);
  notRecogIdx = find(interTable.NR);
  i = 1;
  
  for elm = nonWordIdx
      times(elm) = [];
  end
  
  for elm = notRecogIdx
      interTable(elm,:) = []; % delete row 
  end
  
   
  for idx = 1:height(interTable)
       if ~interTable.naMove(idx)
           run.move{i} = interTable.word{idx};
           run.baseScore(i) = interTable.baseScore(idx);
           score = interTable.baseScore(idx);
           totalscore = totalscore + score;
           run.totalScore(i) = totalscore;        
           i = i + 1;
           
       else
           i = i - 1;
           run.bonus(i) = interTable.bonus(idx);
           score = interTable.bonus(idx);
           totalscore = totalscore + score;
           run.totalScore(i) = totalscore; 
           i = i + 1; 
       end
        
  end

  
    times(numel(run.time)) = 0; 
    run.time(:) = times;
    run.time.Format = 's';
   
  
end

