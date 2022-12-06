function control_observ(G)

EE=ss(G);

%teste de controlabilidade 1
M=ctrb(EE.A,EE.B);

if(rank(M)>=size(EE.A,1))
    disp('O Sistema é controlável')  
else
    disp('O Sistema não é completamente controlável')
end

%teste de observabilidade 
N=obsv(EE.A,EE.C);

if(rank(N)>=size(EE.A,1))
    disp('O Sistema é Observável')    
else
    disp('O Sistema não é completamente Observável.')
end

end