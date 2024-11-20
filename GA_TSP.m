% 参数设置
numCities = 6;           % 城市数量
popSize = 16;            % 种群大小
maxGenerations = 150;    % 最大代数
mutationRate = 0.05;     % 变异概率

% 初始化城市距离矩阵（对称 TSP）
distanceMatrix = [
    0, 45, 55, 58, 65, 70;
    45, 0, 10, 13, 20, 25;
    55, 10, 0, 23, 35, 33;
    58, 13, 23, 0, 7, 15;
    65, 20, 35, 7, 0, 22;
    70, 25, 33, 15, 22, 0
];

% 随机初始化种群
population = zeros(popSize, numCities);
for i = 1:popSize
    population(i, :) = randperm(numCities);
end

% 主算法
for gen = 1:maxGenerations
    % 计算适应度 (总距离的倒数)
    fitness = zeros(popSize, 1);
    for i = 1:popSize
        route = population(i, :);
        totalDistance = 0;
        for j = 1:(numCities - 1)
            totalDistance = totalDistance + distanceMatrix(route(j), route(j + 1));
        end
        totalDistance = totalDistance + distanceMatrix(route(end), route(1)); % 返回起点
        fitness(i) = 1 / totalDistance;
    end

    % 轮盘赌选择
    totalFitness = sum(fitness);
    probabilities = fitness / totalFitness;
    cumulativeProb = cumsum(probabilities);
    newPopulation = zeros(popSize, numCities);

    for i = 1:popSize
        r = rand;
        selectedIndex = find(cumulativeProb >= r, 1, 'first');
        newPopulation(i, :) = population(selectedIndex, :);
    end

    % 交叉 (单点交叉)
    for i = 1:2:popSize
        if rand < 0.8  % 交叉概率
            parent1 = newPopulation(i, :);
            parent2 = newPopulation(i + 1, :);
            point = randi([1, numCities - 1]);
            child1 = [parent1(1:point), setdiff(parent2, parent1(1:point), 'stable')];
            child2 = [parent2(1:point), setdiff(parent1, parent2(1:point), 'stable')];
            newPopulation(i, :) = child1;
            newPopulation(i + 1, :) = child2;
        end
    end

    % 变异
    for i = 1:popSize
        if rand < mutationRate
            route = newPopulation(i, :);
            idx = randperm(numCities, 2);
            route([idx(1), idx(2)]) = route([idx(2), idx(1)]); % 交换两个城市
            newPopulation(i, :) = route;
        end
    end

    % 更新种群
    population = newPopulation;
end

% 输出最佳路径
bestFitness = 0;
bestRoute = [];
for i = 1:popSize
    route = population(i, :);
    totalDistance = 0;
    for j = 1:(numCities - 1)
        totalDistance = totalDistance + distanceMatrix(route(j), route(j + 1));
    end
    totalDistance = totalDistance + distanceMatrix(route(end), route(1));
    if 1 / totalDistance > bestFitness
        bestFitness = 1 / totalDistance;
        bestRoute = route;
    end
end

disp('最佳路径:');
disp(bestRoute);
disp('最短距离:');
disp(1 / bestFitness);
