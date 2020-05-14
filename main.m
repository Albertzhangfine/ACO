clc,clear,close all
warning off
feature jit off
% ACO 参数
maxiter = 50;  % 迭代次数
sizepop = 20;  % 种群数量
popmin1 = -1;  popmax1 = 1; % x1
popmin2 = -1;  popmax2 = 1; % x2
Rou = 0.8;     % 信息素增量强度
P0 = 0.1;      % 转移概率   
% 初始化种群
for i=1:sizepop
    x1 = popmin1 + (popmax1-popmin1)*rand;
    x2 = popmin2 + (popmax2-popmin2)*rand;
    pop(i,1) = x1;
    pop(i,2) = x2;
    fitness(i) = fun([x1,x2]);
end
% 记录一组最优值
[bestfitness,bestindex]=min(fitness);
zbest=pop(bestindex,:);   % 全局最佳
gbest=pop;                % 个体最佳
fitnessgbest=fitness;     % 个体最佳适应度值
fitnesszbest=bestfitness; % 全局最佳适应度值
%% 迭代寻优
for i=1:maxiter
    lamda = 1/i;       % 信息素挥发因子
    [bestfit,flag] =min(fitness);
    for j=1:sizepop
        Pt(j) = (fitness(j)-bestfit)./bestfit;
    end
    for j=1:sizepop
        % 转移概率值
        if Pt(j)<P0
            pop(j,:) = pop(j,:) + (2*rand-1)*lamda/2;
        else
            pop(j,1) = pop(j,1) + (popmax1-popmin1)*(rand-0.5);
            pop(j,2) = pop(j,2) + (popmax2-popmin2)*(rand-0.5);
        end   
        
        % 越界处理
        if pop(j,1)>popmax1
            pop(j,1)=popmax1;
        end
        if pop(j,1)<popmin1
            pop(j,1)=popmin1;
        end
        if pop(j,2)>popmax2
            pop(j,2)=popmax2;
        end
        if pop(j,2)<popmin2
            pop(j,2)=popmin2;
        end
        
        % 适应度值
        fitness1 = fun(pop(j,:));
        fitness2 = fun(gbest(j,:));
        if fitness1<fitness2
            gbest(j,:) = pop(j,:);
        else
            pop(j,:) = gbest(j,:);
        end
        
        fitness(j) = (1-Rou)*fitness(j) + fun(pop(j,:));
        
        if fitness(j) < fitnesszbest
            fitnesszbest = fitness(j);
            fitnessgbest(j) = fun(pop(j,:));
        end
    end
    [fitness_iter(i),index]= min(fitnessgbest);
end
zbest = pop(index,:);  % 最优个体

figure('color',[1,1,1])
plot(fitness_iter,'ro-','linewidth',2)
grid on
xlabel('迭代次数');
ylabel('适应度函数值')

fprintf('最优个体')
zbest