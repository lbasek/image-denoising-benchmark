function trained_model = save_trained_model(cof, mfs, stage, KernelPara)
basis = KernelPara.basis;
filter_size = KernelPara.fsz;
m = filter_size^2 - 1;
filtN = KernelPara.filtN;

trained_model = cell(stage,1);
for s = 1:stage
    vcof = cof(:,s);
    part1 = vcof(1:filtN*m);
    cof_beta = reshape(part1,m,filtN);
    part3 = vcof(filtN*m+1);
    p = exp(part3);
    part4 = vcof(filtN*m+2:end);
    weights = reshape(part4,mfs.NumW,filtN);
    
    K = cell(filtN,1);
    f_norms = zeros(filtN,1);
    for i = 1:filtN
        x_cof = cof_beta(:,i);
        filter = basis*x_cof;
        f_norms(i) = norm(filter);
        filter = filter/(norm(filter) + eps);
        K{i} = reshape(filter,filter_size,filter_size);
    end
    %% update mfs
    mfsAll = cell(filtN,1);
    for i=1:filtN
        w = weights(:,i);
        Q = bsxfun(@times, mfs.G, w);
        mfsAll{i}.P = sum(Q,1);
    end
    %% construct model for one stage
    model.mfsAll = mfsAll;
    model.K = K;
    model.p = p;
    model.mfs = mfs;
    model.f_norms = f_norms;
    trained_model{s} = model;
end
