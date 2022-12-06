function gerar_curvas(FT,tipo)
    
f = figure();
f.Position = [150 150 400 400];

if strcmp(tipo,'LGR')==1;   
rlocus(FT)
axis([-1.2 1.2 -1.2 1.2])

elseif strcmp(tipo,'LGR_zoom')==1;  
rlocus(FT)
axis([0.8 1.2 -0.2 0.2])

elseif strcmp(tipo,'impulso')==1;  
impulse(FT)
grid

else strcmp(tipo,'degrau')==1;  
step(FT)        
grid  
end
    
title ('');
xlabel ('Eixo Real');
ylabel ('Eixo Imaginário');

end