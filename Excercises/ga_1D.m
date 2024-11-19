% Geneticky algoritmus 1D
clear;clc
%% params
nInds = 50;
generations = 50;
mutProb = 5/nInds;
bounds = [-5.12, 5.12]; 
width = bounds(2) - bounds(1);
nBits = 16;
tournamentSize = 5;

x = linspace(bounds(1), bounds(2), 1000);
y = arrayfun(@CF, x);
%% random init population
pop = initPopulation(nInds, nBits);
%% GA run
for gen = 1:generations
    disp(gen )
    clf, hold on, grid on
    plot(x, y, 'LineWidth', 2)
    %% eval population
    popR = realPop(pop, width, nBits);
    CFvalues = arrayfun(@CF, popR);
    plot(popR, CFvalues, '*', 'LineWidth',3, 'MarkerSize',10)
    %% selection
    parents = cell(1, nInds/2);
    for i = 1:nInds/2
        parents{i} = selection(pop, CFvalues, tournamentSize, nBits);
    end
    %% crossover
    newPopulation = [];
    for i = 1:nInds/2
        [r1, r2] = crossover(parents{i});
        newPopulation = [newPopulation; r1; r2];
    end
    %% mutation 
    for i = 1:nInds
        if rand() < mutProb
            pop(i) = mutate(pop(i));
        end
    end
    pop = newPopulation;
    pause()
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functions

%% initPop
function pop = initPopulation(nInds, nBits)
    pop = dec2bin(round(rand(1, nInds)*(2^nBits - 1)), nBits);
end
%% realPop (prevest bin jedince do real cisel)
function rp = realPop(pop, width, nBits)
    rp = bin2dec(pop)/(2^nBits-1)*width - width/2;
end
%% costFun
function value = CF(x)
    % value = x.^2;
    value = 10 + sum(x.^2 - 10*cos(2*pi*x));
end
%% selection
function parents = selection(pop, CFvalues, tournamentSize, nBits)
    popR = bin2dec(pop);
    i = randsample(1:length(popR), tournamentSize);
    result = sortrows([popR(i),CFvalues(i)], 2);
    parents = dec2bin(result(1:2,1), nBits);
end
%% crossover
function [c1, c2] = crossover(parents)
    p1 = parents(1,:);
    p2 = parents(2,:);
    n = length(p1);
    c1 = strcat(p1(1:n/2), p2(n/2+1:end));
    c2 = strcat(p2(1:n/2), p1(n/2+1:end));
end
%% mutation
function mutant = mutate(ind)
    randPos = round(rand()*(length(ind) - 1) + 1);
    if ind(randPos) == '0'
        ind(randPos) = '1';
    else
        ind(randPos) = '0';
    end
    mutant = ind;
end