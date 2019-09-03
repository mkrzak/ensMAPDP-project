%%%%%%%%%%%Loading data%%%%%%%%%%%%%% 
%cd '/media/monika/683375f9-7173-4a68-ba60-f33b0c47a470/Analysis/MATLAB/MAP-DP_Gaussian_Poisson'

X = dlmread(filebase, ',', 1, 0);
X=X';

%%%%%%%%%%%%%%%%%%MAP-DP/Poisson-DP set parameters%%%%%%%%%%%%%%%%

D = size(X,1);
N = size(X,2); 

% Set up Normal-Wishart MAP-DP prior parameters

%N0 = csvread(strcat(filebase,'/N0.csv'))
%N0 = 1.4
%N0 = [0.5 0.6 0.7 0.8 0.9]
%N0 = [1 1.4 1.6 1.8 2 2.2 2.4]     % Prior count (concentration parameter)
m0 = mean(X,2);                     % Normal-Wishart prior mean
a0 = 10;                            % Normal-Wishart prior scale
c0 = 10/N;                          % Normal-Wishart prior degrees of freedom
B0 = diag(1./(pB0*var(X,0,2)));    % Normal-Wishart prior precision

%%%%%%%%%%%%%%%%%%MAP-DP/Poisson-DP starts%%%%%%%%%%%%%%%%

[mu,z,k,E] = S1_Function(X,N0,m0,a0,c0,B0);

% or
% inferred_z= zeros(N,1);
% for i = 1:size(N0,2)
% [mu,z,k,E] = S1_Function(X,N0(i),m0,a0,c0,B0);
% inferred_z = [inferred_z ,z];
% end

% Plot results
% close all;
% figure;
% 
% % Plot 
% plot(X(1,:),X(2,:),'.')
   
%%%%%%%%%%%%%%%%%%MAP-DP/Poisson-DP save results%%%%%%%%%%%%%%%%
inferredClusters = z; %inferred clusters

% filename = strcat(filebase,'/Gaussian_matlab.mat');
% save(filename)








