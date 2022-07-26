function data = calCellsInIsolines(modeDef,plotData,isolines,center,noOfCells)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 1: find the isoline in which the center resides:
centerIsoline = 0;
for i = 1:size(isolines,2)
    isolineLength = isolines(1,i,2);
    if all(inpoly(center,[isolines(2:isolineLength+1,i,1),isolines(2:isolineLength+1,i,2)]))
        centerIsoline = i;
        break;
    end
end
if ~centerIsoline
    if strcmp(modeDef,'auto')
        %If could not found a isoline inside which the center resides, it
        %means that the center chosen is outside the contour levels, and all
        %the data is inside the gate.
        data = true(size(plotData,1),1);
        return;
    else 
        centerIsoline = size(isolines,2);
    end
end
%Delete all the isolines that are before the centerIsoline (meaning:
%have higher density of cells, i.e. they are the real center, but the
%user chose a lower level of dendity of cells, so just ignore them.)
isolines(:,1:centerIsoline-1,:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 2: Find isolines that are in the same level of the centerIsoline,
%        meaning, they have the same density of cells as the centerIsoline, 
%        and delete them (i.e, if the center was in a island, and there was
%        another island with the same density, delete it).
sameLevel = find(isolines(1,:,1) == isolines(1,1,1));
if length(sameLevel)>1
    isolines(:,sameLevel(sameLevel~=1),:) = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 3: Begin from the second level:
%           a. Find all the isolines that are in the same level of
%               isoline(i).
%           b. Check for each if it resides in the previous level's isoline.
%           c. If one resides inside the previous levle's isoline, delete
%               all the others.
%        The reason is to eliminate islands that are not connected to the
%        center.
indecesForDeletion = false(size(isolines,2),1);
i = 2;
previousLevel = 1;
while i<size(isolines,2)
    sameLevel = find(isolines(1,:) == isolines(1,i));
    for j = 1:length(sameLevel)
        thisIsolineLength = isolines(1,sameLevel(j),2);
        previousLevelIsolineLength = isolines(1,previousLevel,2);
        if all(inpoly([isolines(2:previousLevelIsolineLength+1,previousLevel,1),...
                       isolines(2:previousLevelIsolineLength+1,previousLevel,2)],...
                     [isolines(2:thisIsolineLength+1,sameLevel(j),1),...
                       isolines(2:thisIsolineLength+1,sameLevel(j),2)]))
            indecesForDeletion(sameLevel(sameLevel~=sameLevel(j))) = true;
            break;
        end
    end
    previousLevel = sameLevel(j);
    i = sameLevel(end)+1;
end
isolines(:,indecesForDeletion,:) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 4: check for each isoline which cells are inside it:
%        - In modeDef = 'auto' - reach the number of cells defined in
%          'noOfCells' and break, return the cells that are in the gate.
%        - In modeDef = 'semiauto' - calculate the number of cells inside each
%          of the isolines and return a matrix (cells) of the cells that
%          are in each of the isolines.

%An array that contain all the cells in each isoline
cells = false(size(plotData,1),size(isolines,2));
%An array that will contain the area of each isoline (in semiauto and
%semiauto_edit modes
areas = zeros(1,size(isolines,2));

%for auto mode:
if strcmp(modeDef,'auto')
    %First for the first isoline:
    isolineLength = isolines(1,1,2);
    cells(:,1) = inpoly(plotData,[isolines(2:isolineLength+1,1,1),isolines(2:isolineLength+1,1,2)]);
    for i = 2:size(isolines,2)
        %Pass all the cells from the previous round (as they are obviously in this isoline)
        cells(cells(:,i-1),i) = true(1,1);
        %Calculate which of the remaining cells is inside the isoline.
        isolineLength = isolines(1,i,2);
        cells(~cells(:,i-1),i) = inpoly(plotData(~cells(:,i-1),:),...
                                 [isolines(2:isolineLength+1,i,1),...
                                  isolines(2:isolineLength+1,i,2)]);
        distanceFromGoal = length(find(cells(:,i)))-noOfCells;
        if distanceFromGoal > 0
            %For the points added in the last round (not found both in the last round and in this round
            addedPoints = find(xor(cells(:,i),cells(:,i-1)));
            dists = zeros(length(addedPoints),1);
            previousisolineLength = isolines(1,i-1,2);
            %Calculate the distance from the last isoline
            for j = 1:length(addedPoints)
                [dists(j),~,~] = p_poly_dist(plotData(addedPoints(j),1),plotData(addedPoints(j),2),...
                                 isolines(2:previousisolineLength+1,i-1,1),isolines(2:previousisolineLength+1,i-1,2)); 
            end
            %Sort the points by their distance from the last isoline
            [~,indeces] = sort(dists,'descend');
            %And then delete the 'distanceFromGoal' farest cells
            cells(addedPoints(indeces(1:distanceFromGoal)),i) = false(1,1);
            break;
        elseif distanceFromGoal == 0
            break;
        end
    end
    if i
        data = cells(:,i);
    else
        data = cells(:,1);
    end
%for semiauto mode: do the same, just without stopping and without passing the cells
%from the previous isoline, each isoline by its own, and also calculate the area of each isoline
elseif strcmp(modeDef,'semiauto')
    finishedCells = false(size(cells,1),1);
    isolineLength = isolines(1,1,2);
    cellsInCheck = ~any([plotData(:,1)>max(isolines(2:isolineLength+1,1,1)),...
                         plotData(:,2)>max(isolines(2:isolineLength+1,1,2)),...
                         plotData(:,1)<min(isolines(2:isolineLength+1,1,1)),...
                         plotData(:,2)<min(isolines(2:isolineLength+1,1,2))],2);
    cells(cellsInCheck,1) = inpoly(plotData(cellsInCheck,:),[isolines(2:isolineLength+1,1,1),isolines(2:isolineLength+1,1,2)]);
    finishedCells(cells(:,1)) = true;
    areas(1) = polyarea(isolines(2:isolineLength+1,1,1),isolines(2:isolineLength+1,1,2));
    for i = 2:size(isolines,2)
        isolineLength = isolines(1,i,2);
        cellsInCheck = ~any([finishedCells,plotData(:,1)>max(isolines(2:isolineLength+1,i,1)),...
                                           plotData(:,2)>max(isolines(2:isolineLength+1,i,2)),...
                                           plotData(:,1)<min(isolines(2:isolineLength+1,i,1)),...
                                           plotData(:,2)<min(isolines(2:isolineLength+1,i,2))],2);
        cells(cellsInCheck,i) = inpoly(plotData(cellsInCheck,:),...
                                        [isolines(2:isolineLength+1,i,1),...
                                         isolines(2:isolineLength+1,i,2)]);
        finishedCells(cells(:,i)) = true;
        areas(i) = polyarea(isolines(2:isolineLength+1,i,1),isolines(2:isolineLength+1,i,2));
    end
    %return 'isolines' (as they were changed in the above process,
    %'cells' (logical array in which each column is an isoline, and each row
    %is a cell, and the value is 1 if the cell appears in this isoline),
    %and the area of each isoline.
    data = {isolines,cells,areas};
end