clc, clear all, close all

%Obtém o modelo Caixa Branca do pêndulo invertido sobre um carro
%de acordo com os parâmetros definidos abaixo.

syms m l I bp g M bc

m  =  0.105; 
l  =  0.074;
I  =  0.0018; 
bp =  0;
bc =  0;
g  =  9.81; 
M  =  0.606; 

%Chama a função CaixaBranca e retorna os polinômios que representam as 
%funções de transferência Gxt, Gtu e Gxu contínuas.

[Gxt_CB,Gtu_CB,Gxu_CB] = sym_CBc(g,m,M,l,I,bp,bc);

%Definindo o tempo de amostragem ts.

ts = 0.01;

%Chama a função FT_CBd e retorna as 
%funções de transferência Gxt, Gtu e Gxu discretas.

[Gxu_CB,Gxt_CB,Gtu_CB] = FT_CBd (Gxt_CB,Gtu_CB,Gxu_CB,ts)

%Chama a função gerar_rlocus para ver o LGR da Função de Transferência.

gerar_curvas(Gtu_CB,'LGR')
gerar_curvas(Gxt_CB,'LGR')

%%
% Projeto do controle da malha interna, ângulo theta.
%controlado com pequena margem de ganho
z = tf('z',ts);

Ci_CB = -2000*((z - 0.96)*(z - 0.95))/((z - 1)*(z + 0.93));
Ci_CB_2dof = tf(make2DOF((pid(Ci_CB)),1,0));

MAi_CB = -Ci_CB_2dof(2)*Gtu_CB;
MFi_CB = Ci_CB_2dof(1)*feedback(Gtu_CB,-Ci_CB_2dof(2));

%Chama a função gerar_rlocus para ver o LGR das FTs.

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
% Projeto do controle da malha externa, posição do carrinho.

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
