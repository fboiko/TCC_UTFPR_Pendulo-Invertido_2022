clc, clear all, close all

%Obt�m o modelo Caixa Branca do p�ndulo invertido sobre um carro
%de acordo com os par�metros definidos abaixo.

syms m l I bp g M bc

m  =  0.105; 
l  =  0.074;
I  =  0.0018; 
bp =  0;
bc =  0;
g  =  9.81; 
M  =  0.606; 

%Chama a fun��o CaixaBranca e retorna os polin�mios que representam as 
%fun��es de transfer�ncia Gxt, Gtu e Gxu cont�nuas.

[Gxt_CB,Gtu_CB,Gxu_CB] = sym_CBc(g,m,M,l,I,bp,bc);

%Definindo o tempo de amostragem ts.

ts = 0.01;

%Chama a fun��o FT_CBd e retorna as 
%fun��es de transfer�ncia Gxt, Gtu e Gxu discretas.

[Gxu_CB,Gxt_CB,Gtu_CB] = FT_CBd (Gxt_CB,Gtu_CB,Gxu_CB,ts)

%Chama a fun��o gerar_rlocus para ver o LGR da Fun��o de Transfer�ncia.

gerar_curvas(Gtu_CB,'LGR')
gerar_curvas(Gxt_CB,'LGR')

%%
% Projeto do controle da malha interna, �ngulo theta.
%controlado com pequena margem de ganho
z = tf('z',ts);

Ci_CB = -2000*((z - 0.96)*(z - 0.95))/((z - 1)*(z + 0.93));
Ci_CB_2dof = tf(make2DOF((pid(Ci_CB)),1,0));

MAi_CB = -Ci_CB_2dof(2)*Gtu_CB;
MFi_CB = Ci_CB_2dof(1)*feedback(Gtu_CB,-Ci_CB_2dof(2));

%Chama a fun��o gerar_rlocus para ver o LGR das FTs.

close all
gerar_curvas(MAi_CB,'LGR')
gerar_curvas(MFi_CB,'LGR')

%Resposta ao Impulso
gerar_curvas(MFi_CB,'impulso')

%%
% LGR Gxt_CB*MFi_CB
close all
gerar_curvas(Gxt_CB*MFi_CB,'LGR')
gerar_curvas(Gxt_CB*MFi_CB,'LGR_zoom')

%%
% Projeto do controle da malha externa, posi��o do carrinho.

Ce_CB = 13*((z - 0.999)*(z -0.98))/((z - 1)*(z - 0));
Ce_CB_2dof = tf(make2DOF((pid(Ce_CB)),1,0));

MAe_CB = -Ce_CB_2dof(2)*Gxt_CB*MFi_CB;
MFe_CB = feedback((-Ce_CB_2dof(2)*Gxt_CB*MFi_CB),1);

close all
gerar_curvas(MAe_CB,'LGR')
gerar_curvas(MAe_CB,'LGR_zoom')

%Resposta ao Degrau
close all
gerar_curvas(MFe_CB,'degrau')

%% Export

save('CB.mat','MFi_CB','MFe_CB')

%%
%Ganhos PI-DF
close all
PIDF_i_CB = make2DOF((pid(Ci_CB)),1,0)
PIDF_e_CB = make2DOF((pid(Ce_CB)),1,0)
