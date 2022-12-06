function [Gxt,Gtu,Gxu]=sym_CBc(g,m,M,l,I,bp,bc)

syms s
digits 4

mcr=I*(m+M)+M*m*l^2;

Gxu_sim=(s^2*(m*l^2+I)+s*(bp)-g*m*l)/(s*(s^3*mcr+s^2*(bp*(m+M)+bc*(I+l^2*m))+s*(bc*bp-g*l*m*(m+M))-bc*g*l*m));
Gtu_sim=(-s*m*l)/(s^3*mcr+s^2*(bp*(m+M)+bc*(I+l^2*m))+s*(bc*bp-g*l*m*(m+M))-bc*g*l*m);
Gxt_sim=-((((s^2)*((I+m*l^2))+s*(bp)-g*m*l)/(s^2*m*l)));

mcr=subs(mcr);
Gxt=vpa(subs(Gxt_sim));
Gtu=vpa(subs(Gtu_sim));
Gxu=vpa(subs(Gxu_sim));

end
