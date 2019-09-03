% MAP-DP for Normal-Wishart data.
%
% [mu,z,K,E] = mapdp_nw(X,N0,m0,a0,c0,B0)
%
% Inputs:  X  - DxN matrix of data
%          N0 - prior count (DP concentration parameter)
%          m0 - cluster prior mean
%          a0 - cluster prior scale
%          c0 - cluster prior degrees of freedom
%          B0 - cluster prior precision (inverse covariance)
%
% Outputs: mu - cluster centroids
%          z  - data point cluster assignments
%          K  - number of clusters
%          E  - objective function value for each iteration
%
% Follows the implementation described in "What to do when K-means
% clustering fails: a simple yet principled alternative algorithm"
% by Yordan P. Raykov et al.
%
% CC BY-SA 3.0 Attribution-Sharealike 3.0, Max A. Little. If you use this
% code in your research, please cite:
% Y.P. Raykov, A. Boukouvalas, M.A. Little (2015)
% "MAP for Exponential Family Dirichlet Process Mixture Models",
% in NIPS 2015 Workshop: Nonparametric Methods for Large Scale
% Representation Learning, 2015: Montreal, Canada.

function [mu,z,K,E] = S1_Function(X,N0,m0,a0,c0,B0)

    D = size(X,1);
    N = size(X,2);
    epsilon = 1e-6;

    % Initialization (Alg. 3 line 1)
    K = 1;
    z = ones(N,1);
    Enew = inf;
    dE = inf;
    iter = 0;
    E = [];

    % Convergence test (Alg. 3 line 14 and Appendix B)
    while (abs(dE) > epsilon)

        Eold = Enew;
        dik = inf(N,1);

        for i = 1:N

            dk = inf(K+1,1);
            Nki = inf(K+1,1);

            for k = 1:K

                zki = (z == k);
                zki(i) = false;
                Nki(k) = sum(zki);
                
                % Updates meaningless for Nki=0
                if (Nki(k) == 0)
                    continue;
                end
                
                % Update NW cluster hyper parameters (Alg. 3 line 7)
                [mki,aki,cki,Bki] = nwupd(Nki(k),X(:,zki),m0,a0,c0,B0);

                % Compute Student-t NLL, existing clusters (Alg. 3 line 8)
                dk(k) = stnll(X(:,i),mki,aki,cki,Bki,D);
            end

            % Avoid reinforcement effect at initialization (Appendix B)
            if (iter == 0)
                Nki(1) = 1;
            end
            
            Nki(K+1) = N0;

            % Compute Student-t NLL, new cluster (Alg. 3 line 9)
            dk(K+1) = stnll(X(:,i),m0,a0,c0,B0,D);
            
            % Compute MAP assignment (Alg. 3 line 10)
            [dik(i),z(i)] = min(dk-log(Nki));

            % Create new cluster if required (Alg. 3 line 11-12)
            if (z(i) == K+1)
                K = K + 1;
            end

        end

        % Remove any empty clusters and re-assign (Appendix B)
        Knz = 0;
        for k = 1:K
            i = (z == k);
            Nk = sum(i);
            if (Nk > 0)
                Knz = Knz + 1;
                z(i) = Knz;
            end
        end
        K = Knz;
        Nk = hist(z,1:K);
        
        % Compute updated NLL (Alg. 3 line 13)
        Enew = sum(dik)-K*log(N0)-sum(gammaln(Nk));

        dE = Eold - Enew;
        iter = iter + 1;
        E(iter,1) = Enew;
        fprintf('Iteration %d: K=%d, E=%f, dE=%f\n',iter,K,Enew,dE);
    end
    
    % Compute cluster centroids (Appendix D)
    mu = nan(D,K);
    for k = 1:K
        xk = X(:,z==k);
        mu(:,k) = mean(xk,2);
    end

end

% Compute Student-t negative log likelihood (Appendix A, eqn. (20))
function nl = stnll(x,m,a,c,B,D)
    mu = m;
    nu = a-D+1;
    Lambda = c*nu/(c+1)*B;
    nl = (nu+D)/2*log(1+(x-mu)'*Lambda*(x-mu)/nu)...
         -1/2*log(det(Lambda))+gammaln(nu/2)...
         -gammaln((nu+D)/2)+D/2*log(nu*pi);
end

% Update Normal-Wishart hyper parameters (Appendix A, eqns. (18-19))
function [mki,aki,cki,Bki] = nwupd(Nki,xki,m0,a0,c0,B0)
    xmki = mean(xki,2);
    xmcki = xki-repmat(xmki,1,Nki);
    Ski = xmcki*xmcki';
    cki = c0+Nki;
    mki = (c0*m0+Nki*xmki)/cki;
    xm0cki = xmki-m0;
    Bki = inv(inv(B0)+Ski+c0*Nki/cki*xm0cki*xm0cki');
    aki = a0+Nki;
end



