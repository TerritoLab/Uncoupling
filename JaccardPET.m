function JaccardPET(CovMat1,CovMat2)
%% Jaccard Index 
% Vertically concatenate binarized lower triangle of matrices into a single vector per
% adjacency matrix
[rwCovMat1, clCovMat1] = size(CovMat1);
for i=2:rwCovMat1
    for j=2:clCovMat1
        P = CovMat1{i,j}; catP = P'; catP = catP(:)'; catP = catP.';
        vertcat_CovMat1{i,j} = catP; %#ok<*AGROW>
        N = CovMat2{i,j}; catN = N'; catN = catN(:)'; catN = catN.';
        vertcat_CovMat2{i,j} = catN;
        for k=1:rwCovMat1
            vertcat_CovMat1{k,1} = CovMat1{k,1}; vertcat_CovMat2{k,1} = CovMat1{k,1};
        end
        for l=1:clCovMat1
            vertcat_CovMat1{1,l} = CovMat1{1,l}; vertcat_CovMat2{1,l} = CovMat1{1,l};
        end
    end
end
clear nrP clCovMat1 P N i j k l
% Compute Jaccard Network Comparison Within, Between Sexes
[nr, nc] = size(vertcat_CovMat1);
% Within sex compared to vertically adjacent time points
for i=2:nr-1
    for j=2:nc
        P = vertcat_CovMat1{i,j}; N = vertcat_CovMat2{i,j}; %#ok<*NASGU>
        JP(i-1,j-1) = sum(vertcat_CovMat1{i,j} & vertcat_CovMat1{i+1,j})/sum(vertcat_CovMat1{i,j} | vertcat_CovMat1{i+1,j});
        JN(i-1,j-1) = sum(vertcat_CovMat2{i,j} & vertcat_CovMat2{i+1,j})/sum(vertcat_CovMat2{i,j} | vertcat_CovMat2{i+1,j});
        Jaccard{2,2} = JP; Jaccard{2,3} = JN;
    end
end
clear i j P N JP JN
% Between sex at a given time
for i=2:nr
    for j=2:nc
        P = vertcat_CovMat1{i,j}; N = vertcat_CovMat2{i,j};
        JP(i-1,1) = sum(vertcat_CovMat1{i,nc-1} & vertcat_CovMat1{i,nc})/sum(vertcat_CovMat1{i,nc-1} | vertcat_CovMat1{i,nc});
        JN(i-1,1) = sum(vertcat_CovMat2{i,nc-1} & vertcat_CovMat2{i,nc})/sum(vertcat_CovMat2{i,nc-1} | vertcat_CovMat2{i,nc});
        Jaccard{3,2} = JP; Jaccard{3,3} = JN;
    end
end
Jaccard{1,1} = 'Jaccard Index Outputs';
Jaccard{1,2} = 'Positive';
Jaccard{1,3} = 'Negative';
Jaccard{2,1} = 'Within Sex';
Jaccard{3,1} = 'Between Sex';
save("Jaccard.mat","Jaccard")
end