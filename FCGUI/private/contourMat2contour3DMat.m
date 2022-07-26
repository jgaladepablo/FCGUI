function threeDMat = contourMat2contour3DMat(contourMat)
%function to create a 3d matrix from a contour matrix (see contour plot
%function help). Columns are each of the vertices, rows are the vertices
%coordinates in X (3rd dim 1) or Y (3rd dim 2). First row in X contain the
%number of vertices, and in Y the height.
k = 1;
levelsNo = 0;
maxLengthPolygon = 0;
while k<length(contourMat)
    maxLengthPolygon = max(contourMat(2,k),maxLengthPolygon);    
    k =k+contourMat(2,k)+1;
    levelsNo = levelsNo+1;
end
threeDMat = NaN(maxLengthPolygon+1,levelsNo,2);

k = 1;
n = 1;
while k<length(contourMat)
    threeDMat(1,n,1)=contourMat(1,k);
    threeDMat(1,n,2)=contourMat(2,k);    
    threeDMat(2:contourMat(2,k)+1,n,1)=contourMat(1,k+1:k+contourMat(2,k));
    threeDMat(2:contourMat(2,k)+1,n,2)=contourMat(2,k+1:k+contourMat(2,k));
    k =k+contourMat(2,k)+1;
    n = n+1;
end
threeDMat(:,1:end,:) = threeDMat(:,end:-1:1,:);