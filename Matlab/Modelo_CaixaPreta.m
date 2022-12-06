clc, clear all, close all
%Caixa Preta - Importação dos dados obtidos com o arduíno.

[data]=carrega_dados('Aquisicao_Dados.xlsx');

% data{1,i}(i,1)
%informaçoes da estrutura:

%matrix_data(i,2) -> pwm
%matrix_data(i,3) -> x
%matrix_data(i,4) -> theta

%Data

for j = 1:length(data)

for i = 1:numel(data{1,j}(:,1))-1
        data_col(i,1) = data{1,j}(i+1,2);   %PWM
        data_col(i,2) = data{1,j}(i+1,3);   %X
        data_col(i,3) = data{1,j}(i+1,4);   %Theta
        
end

 err=20;               % max erro permitido para o cos em porcentagem
 AngC = acos(1/(1+(err/100)))*(100/pi);
 
for i = 1:numel(data_col(:,1))
    if(abs(data_col(i,3)) > AngC) % 16.6667% de 180° equivale a 30°
        break;
    end
end

   data_col(i:end,:) = [];
   Aquisicao_Dados{1,j} =  data_col;
  
end

ts=0.01;
%% ARMAX (U/theta)

  NY = 1;                   %n de saídas
  NU = 1;                   %n de entradas

  na = 3*eye(NU,NY);        %n polos
  nb = 3*ones(NY,NU);       %n zeros +1
  nc = 2*ones(NY);          %n coeficientes C
  nk = 1*eye(NY,NU);        %n ocorrencias antes da entrada afetar a saída
  
  %Identificação ARMAX
  [Gi_CP]=ident_ARMAX (na,nb,nc,nk,Aquisicao_Dados,1,3,ts);
  
%% ARMAX (theta/x)

    NY = 1;
    NU = 1;

  na = 3*eye(NY,NY);        %n polos
  nb = 3*ones(NY,NU);       %n zeros +1
  nc = 2*ones(NY);          %n número de coeficientes C
  nk = 0*eye(NY,NU);        %n ocorrências antes da entrada afetar a saída

  [Ge_CP]=ident_ARMAX (na,nb,nc,nk,Aquisicao_Dados,3,2,ts);
  
%% Analise de Controlabilidade e Observabilidade

disp('Gi_CP')
control_observ(Gi_CP)
disp('Ge_CP')
control_observ(Ge_CP)

%% Transforma em FT

Gi_CP=zpk(tf(Gi_CP))
Ge_CP=zpk(tf(Ge_CP))

close all
gerar_curvas(Gi_CP,'LGR')
gerar_curvas(Ge_CP,'LGR')

%% Projeto do controle da malha interna, ângulo theta 
%controlado com pequena margem de ganho

z = tf('z',ts);

Ci_CP = -222.7*((z - 0.95)*(z -0.6))/((z - 1)*(z + 0));
Ci_CP_2dof = tf(make2DOF((pid(Ci_CP)),1,0));

MAi_CP = -(Ci_CP_2dof(2))*Gi_CP;
MFi_CP = (Ci_CP_2dof(1))*feedback(Gi_CP,-Ci_CP_2dof(2));

close all
gerar_curvas(MAi_CP,'LGR')
gerar_curvas(MFi_CP,'LGR')

%Resposta ao Impulso
gerar_curvas(MFi_CP,'impulso')

%% Analise de Controlabilidade e Observabilidade

disp('Gi_CP')
control_observ(Gi_CP)
disp('Ge_CP')
control_observ(Ge_CP)

%% LGR Ge_CP*MFi_CP
close all
gerar_curvas(Ge_CP*MFi_CP,'LGR')
gerar_curvas(Ge_CP*MFi_CP,'LGR_zoom')

%% Projeto do controle da malha externa, posição do carrinho.

Ce_CP = 0.4*((z -0.999)*(z - 0.992)/((z - 1)*(z - 0.96)));
Ce_CP_2dof = tf(make2DOF((pid(Ce_CP)),1,0));

MAe_CP = -Ce_CP_2dof(2)*Ge_CP*MFi_CP;
MFe_CP = Ce_CP_2dof(1)*feedback(Ge_CP*MFi_CP,-Ce_CP_2dof(2));

close all
gerar_curvas(MAe_CP,'LGR')
gerar_curvas(MAe_CP,'LGR_zoom')

%Resposta ao Degrau
gerar_curvas(MFe_CP,'degrau')

%% Ganhos PI-DF

PIDF_i_CB = make2DOF((pid(Ci_CP)),1,0)
PIDF_e_CB = make2DOF((pid(Ce_CP)),1,0)

%% Export

save('CP.mat','MFi_CP','MFe_CP')
