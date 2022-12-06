function [Modelo_Ident]=ident_ARMAX (na,nb,nc,nk,data,col_ent,col_saida,ts)

k=1;

for j = 1:length(data)
    
u{j} = data{1,j}(:,col_ent);      %input
y{j} = data{1,j}(:,col_saida);    %output
t{j} = (0:10:10*(length(u{j})-1))';

[Saida,Fit,Ci]=compare(iddata(y{j},u{j},ts),armax(iddata(y{j},u{j},ts),[na nb nc nk]));

if Fit>50
 yf{k}=y{j};   
 uf{k}=u{j};
 k=k+1;   
end   
 
end

ident_data = iddata(yf,uf,ts);
Modelo_Ident = armax(ident_data,[na nb nc nk]);
compare(ident_data,Modelo_Ident)

end