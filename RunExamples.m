%
% This file runs several examples of diffusion maps
% If variables are not cleared before running this script and pExampleIdx exists, it will run the corresponding example without querying the user
%
%

clc
clear all;close all;

global X Data;

pExampleNames   = { ...
    'S-Manifold',
    'Swissroll',
    'Two spirals'
    };

fprintf('\n\n Select example to run:\n');
for k = 1:length(pExampleNames),
    fprintf('\n [%d] %s',k,pExampleNames{k});
end;
fprintf('\n\n  ');

while true,
    if (~exist('pExampleIdx') || isempty(pExampleIdx) || pExampleIdx==0),
        try
            pExampleIdx = input('');
            pExampleIdx = str2num(pExampleIdx);
        catch
        end;
    end;
    if (pExampleIdx>=1) && (pExampleIdx<=length(pExampleNames)),
        break;
    else
        fprintf('\n %d is not a valid Example. Please select a valid Example above.',pExampleIdx);
        pExampleIdx=0;
    end;
end;

%% Set parameters for constructing the graph
EstDimOpts = struct('NumberOfTrials',15,'verbose',0,'MAXDIM',100,'MAXAMBDIM',100,'Ptwise',false,'NetsOpts',[],'UseSmoothedS',false, 'EnlargeScales',true );

%% Set parameters for data generation and generates the data set
switch pExampleIdx
    case 1
        XName = 'S-Manifold'; XNickName = 'S';
        XOpts = struct('NumberOfPoints',5000,'Dim',2,'EmbedDim',100,'NoiseType','Gaussian','NoiseParam',0.001);
    case 2
        XName = 'Swissroll'; XNickName = 'S';
        XOpts = struct('NumberOfPoints',5000,'Dim',2,'EmbedDim',100,'NoiseType','Gaussian','NoiseParam',0.001);
    case 3
        XName = 'Two Spirals'; XNickName = '2spirals';
        XOpts = struct('NumberOfPoints',5000,'Dim',2,'EmbedDim',100,'NoiseType','Gaussian','NoiseParam',0.001);
end

%% Generate the data set
fprintf('\nGenerating %s data...', XName);
[X,GraphDiffOpts,~,Labels] = GenerateDataSets( XName, XOpts);
X = 1*X;
fprintf('done.');

%% Compute Graph Diffusion, and generate
fprintf('\n\nConstructing graph and diffusion map...\n');
GraphDiffOpts.DontReturnDistInfo=0;
Data.G = GraphDiffusion(X, 0, GraphDiffOpts);                  % These are for debugging purposes
fprintf('done.\n');

%% Display figure
figure;
if isempty(Labels),
    subplot(1,2,1);plot3(Data.G.EigenVecs(:,2),Data.G.EigenVecs(:,3),Data.G.EigenVecs(:,4),'.');title('Diffusion embedding (2,3,4)');
    subplot(1,2,2);plot3(Data.G.EigenVecs(:,4),Data.G.EigenVecs(:,5),Data.G.EigenVecs(:,6),'.');title('Diffusion embedding (5,6,7)');
else
    subplot(1,2,1);scatter3(Data.G.EigenVecs(:,2),Data.G.EigenVecs(:,3),Data.G.EigenVecs(:,4),20,Labels,'filled');title('Diffusion embedding (2,3,4)');
    subplot(1,2,2);scatter3(Data.G.EigenVecs(:,4),Data.G.EigenVecs(:,5),Data.G.EigenVecs(:,6),20,Labels,'filled');title('Diffusion embedding (5,6,7)');
end

fprintf('\n');