function [Gxu,Gxt,Gtu]=FT_CBd (Gxt,Gtu,Gxu,ts)

[num,den] = numden(Gxt);
Cnum = sym2poly(num);
Cden = sym2poly(den);
Gxt=zpk(tf(Cnum,Cden));

[num,den] = numden(Gtu);
Cnum = sym2poly(num);
Cden = sym2poly(den);
Gtu=zpk(tf(Cnum,Cden));

[num,den] = numden(Gxu);
Cnum = sym2poly(num);
Cden = sym2poly(den);
Gxu=zpk(tf(Cnum,Cden));

Gtu=(c2d(Gtu,ts));
Gxt=(c2d(Gxt,ts));
Gxu=(c2d(Gxu,ts));

end