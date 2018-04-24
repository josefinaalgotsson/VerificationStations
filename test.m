clear
% dates = {'2017-05-07';'2017-05-10';'2017-06-09'};
% 
% datenumbers = datenum(dates);
% 
% datevec(datenumbers)
% 
% daysworth = datenum('2017-05-07')-datenum('2017-05-06')
% 
% datevec(datenumbers+daysworth)
%--------------------------------------
% a = [1 2 3 4 5 6 7 ]'
% b =[3 5 8 43 5 8 5]'
% c =[2 4 6 9 4 6 9]'
% d = [2.01 3.04 4.001 5.6 6 7 8]'
% 
% A = [a,b,c,d ]
% 
% rankX = rank(A);
% 
% STDs = std(A)
% RMSs = sqrt(sum(((A-a).^2)/(length(A)-rankX)))
% CORs = corrcoef(A)
% CORs = CORs(1,:)
% 
% taylordiag(STDs,RMSs,CORs)

%-------------------------------------
% close all
% height = [2 3 3 4 7 8 9 8 8 7 6 3 2]
% time = [5 6 7 8 9 10 11 12 13 14 15 16 17]
% plot(time,height)
% hold on
% min_time = 6
% max_time = 10
% id1 = find (time >= min_time)
% id2 = find (time <= max_time)
% id_frame = intersect(id1,id2)
% plot(time(id_frame), height(id_frame),'o')
% 
% id_max_inframe = find(height(id_frame) == max(height(id_frame)))
% id_max = id_max_inframe+id_frame(1)-1
% id_max = id_max(1)
% ids = [id_max-3:id_max+3]
% plot(time(ids), height(ids),'*')
% legend('serie','frame','picked values')

%------------------------------------------------------
% [X, Y] = meshgrid([1:15], [1:15]);
% mask = X > Y
% a = magic(15)
% a.*mask
% 

%------------------------
A = randn(50,3);       
A(:,4) = sum(A,2); 
A(1,3) = NaN;
A(3,2) = NaN;
A

[R,P] = corrcoef(A)
[R2,P2] = corrcoef(A,'rows','complete')













