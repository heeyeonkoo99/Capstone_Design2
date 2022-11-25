clc; clear;


% disp("i")
% [UnXrec]=tmpPhaseUnwrapping(input,'DCT');

%[size_xy size_xy]=size(input);
%wrap=sqrt(mean((phawrap(:)-wXrec(:))).*(phawrap(:)-(wXrec(:))));
%rmse_pha=sqrt(mean((gt(:)-(UnXrec(:))).*(gt(:)-(UnXrec(:)))));
% rmses=sqrt(sum(sum((UnXrec-gt).^2))/(size_xy*size_xy)); 

% path1='./test_gt_today/';  % path of the testing results
% path2='./test_in_today/'
% imgDir1  = dir([path1 '*.mat']);  % get dir of the results
% imgDir2  = dir([path2 '*.mat']);
% n=length(imgDir1); % get size of the testing data
% 
% for j = 1:n     
% load([path1 imgDir1(j).name]); % read the results
% load([path2 imgDir2(j).name]);

path1='./test_gt_noise/';  % path of the testing results
path2='./test_in_noise/'
imgDir1  = dir([path1 '*.mat']);  % get dir of the results
imgDir2  = dir([path2 '*.mat']);
n=length(imgDir1); % get size of the testing data

for j = 1:n   
% [size_xy size_xy]= size(phawrap);
size_xy=128;
load([path1 imgDir1(j).name]); % read the results
load([path2 imgDir2(j).name]); % read the results


% M = max(input,[],'all')
% M = min(input,[],'all')
% [UnXrec]=tmpPhaseUnwrapping(input,'DCT');
UnXrec=DCTPhaseUnwrap(input);

%UnXrec= accel_unwrapping(input, 'puma', 2, 2*pi, 1, 1, 0);
%UnXrec=abs(UnXrec)
UnXrec=2*pi+UnXrec;

% phaUnwrap=abs(phaUnwrap)

rmses(j)=sqrt(sum(sum((gt-UnXrec).^2))/(size_xy*size_xy)); % get RMSE for each result

save hey.mat UnXrec gt 
j/n
end

disp("rmse의 평균은!");
rmse_mean=sum(rmses)/length(rmses);

% get standard deviation of RMSE
sum_sd=0;
for ii =1 : length(rmses)
sum_sd  = sum_sd +  (rmses(ii)-rmse_mean)^2
end
% show scatter of RMSEs
xx = 1 : length(rmses);
figure
scatter(xx,rmses);

% show histogram of RMSEs
figure
histogram(rmses,20);








% close all
% clear all
% clc
% 
% path1='./Results_real/Results_real/';  % path of the testing results
% imgDir1  = dir([path1 '*.mat']);  % get dir of the results
% n=length(imgDir1); % get size of the testing data
% 
% for j = 1:n     
% load([path1 imgDir1(j).name]); % read the results
% [size_xy size_xy]= size(input);
% rmses(j)=sqrt(sum(sum((output-gt).^2))/(size_xy*size_xy)); % get RMSE for each result
% j/n
% end
% 
% rmse_mean=sum(rmses)/length(rmses); % get mean of RMSE
% 
% % get standard deviation of RMSE
% sum_sd=0;
% for ii =1 : length(rmses)
% sum_sd  = sum_sd +  (rmses(ii)-rmse_mean)^2
% end
% % show scatter of RMSEs
% xx = 1 : length(rmses);
% figure
% scatter(xx,rmses);
% 
% % show histogram of RMSEs
% figure
% histogram(rmses,20);