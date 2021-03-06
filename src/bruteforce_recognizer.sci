function [acepted, rejected] = bruteforce_recognizer(trainSamples, testSamples)
    brain = bruteforce_train(trainSamples);
    acepted = list();
    rejected = list();
    for i=1: size(testSamples)
        sampl = testSamples(i);
        c = bruteforce_test(imread(sampl.path), brain);
        if c == sampl.class then
            acepted($+1) = sampl;
        else
            rejected($+1) = sampl;
        end
    end
endfunction

function out = bruteforce_train(samples)
    brain = tlist(["brain", "class", "samples"], [], list());
    for i=1:Nc
        brain.class(i) = iClass(i);
        brain.samples(i) = list();
    end
    for i=1:size(samples)
        sampl = samples(i);
        index = find(brain.class==sampl.class);
        class = brain.samples(index);
        class($+1) = imread(sampl.path);
        brain.samples(index) = class;
    end
    out = brain;
endfunction

function [class, sampl] = bruteforce_test(imagem, brain)
    nc = size(brain.class, 1);
    for i=1:nc
        nSamples = brain.samples(i);
        ni = size(nSamples);
        for j=1:ni
           sampl = nSamples(j);
           diffs(i,j) = bruteforce_diffImagem(imagem, sampl);
        end
    end
    [j,k] = min(diffs);
    cIndex = k(1);//indice da classe
    sIndex = k(2);//indice da imagem

    class = brain.class(cIndex);
    samples = brain.samples(cIndex);
    sampl = samples(sIndex);
endfunction

function out = bruteforce_diffImagem(A,B)
    out = norm(A(:) - B(:));
endfunction
