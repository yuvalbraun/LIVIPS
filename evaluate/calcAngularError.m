ground_truth=open('normals-gt-face.mat').normalsMapStl;
reconstruct=permute(load('nstaticDark.mat').n,[2 1 3]);
trimedReconstruct=reconstruct(upBound:lowBound,leftBound:rightBound,:);
degrees=calcDegreeError(ground_truth,trimedReconstruct);
