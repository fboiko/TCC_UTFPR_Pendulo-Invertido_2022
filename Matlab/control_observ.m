function control_observ(G)

EE=ss(G);

%teste de controlabilidade 1
M=ctrb(EE.A,EE.B);

if(rank(M)>=size(EE.A,1))
    disp('O Sistema � control�vel')  
else
    disp('O Sistema n�o � completamente control�vel')
end

%teste de observabilidade 
N=obsv(EE.A,EE.C);

if(rank(N)>=size(EE.A,1))
    disp('O Sistema � Observ�vel')    
else
    disp('O Sistema n�o � completamente Observ�vel.')
end

end