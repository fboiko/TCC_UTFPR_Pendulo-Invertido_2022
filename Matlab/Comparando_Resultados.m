clc, clear all, close all
%Comparando Resultados
load('CB.mat')
load('CP.mat')

%% Validação DADOS
[data]=carrega_dados('Validacao_CP.xlsx');

%idx	t_abs(ms)	tempo(s)	PIDX	PIDT1	act_X	act_T1	SPX	ERX	ERT1

%(i,?)idx	
%(i,1)tempo_incremental	
%(i,2)tempo(s)
%(i,3)PIDX 	
%(i,4)PIDT1
%(i,5)act_X
%(i,6)act_T1
%(i,7)SPX
%(i,8)ERX
%(i,9)ERT1

   temp_VCP = data{1,1}(:,2);  %t(s) 
   u_sp_VCP = data{1,1}(:,7);  %setpoint 
   u_Mi_VCP = data{1,1}(:,3);  %u saida pid externo
   y_Me_VCP = data{1,1}(:,5);  %x atual 
   y_Mi_VCP = data{1,1}(:,6);  %theta atual
   u_Me_VCP = data{1,1}(:,7);  %theta atual

ts=0.01;

%uz_Real2{1,1}=zeros(length(u_Real2{1,1}),1);

    Mi_VCP=iddata(y_Mi_VCP,u_Mi_VCP,ts);
    SPi_VCP=iddata(u_Mi_VCP,u_Mi_VCP,ts);
    Me_VCP=iddata(y_Me_VCP,u_Me_VCP,ts);
    SPe_VCP=iddata(u_Me_VCP,u_Me_VCP,ts);
    
    sp_VCP=iddata(u_sp_VCP,u_sp_VCP,ts);

    f = figure(1);
    f.Position = [100 100 800 400];
    subplot(1,2,1);
    plot(Mi_VCP)
    subplot(1,2,2);
    plot(Me_VCP)

%% Comparação das Sintonias
close all

f = figure(1);
f.Position = [100 100 800 400];
compare(SPi_VCP,Mi_VCP,MFi_CP,MFi_CB)
title ('');
xlabel ('Tempo (segundos)');
ylabel('Ângulo \theta(t) em relação à vertical (%)');
legend('Ref. da posição angular do pêndulo','Resposta da planta (REQMN)','Modelo ARMAX (REQMN)','Modelo Caixa Branca (REQMN)','Location','northwest')
grid on

f = figure(2);
f.Position = [100 100 800 400];
compare(SPe_VCP,Me_VCP,MFe_CP,MFe_CB)
title ('');
xlabel ('Tempo (segundos)');
ylabel('Posição x(t) em relação ao trilho (%)');
legend('Ref. da posicao do carrinho','Resposta da planta (REQMN)','Modelo ARMAX (REQMN)','Modelo Caixa Branca (REQMN)','Location','northwest')
grid on