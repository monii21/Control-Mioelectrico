close
clear
clc
%cargamos los datos en una variable
signal=load("EMG 2 channel Wrist Flex_Ext_Raw");

%Rectificamos los datos, es decir, hacemos que los valores negativos sean
%positivos y viceversa. Para ello usamos el comando abs que es el valor
%absoluto
signal.Data{1,2}=abs(signal.Data{1,2});
signal.Data{1,3}=abs(signal.Data{1,3});

%en el dato "data" tenemos 3 columnas, la 1 es el tiempo, la 2 es la señal
%1 y la 3 es la señal 2

% A continuación hay que rectificar la señal, se va a usar la media 
tam1=length(signal.Data{1,2});
tam2=length(signal.Data{1,3});


[up1,lo1]=envelope(signal.Data{1,2}, 250, 'rms'); %ojo el envelope no puede ser de tipo peak porque nos "deshace" lo aplicado con abs
[up2,lo2]=envelope(signal.Data{1,3},250, 'rms');  %es decir, "recupera" los valores negativos

%creamos un vector donde vamos a almacenar el supuesto felxion, extensión,
%reposo y cocontracción

respuesta=zeros(1,tam1);


for i=1: tam1
    if up1(i)>110 & up2(i)<50 
        respuesta(i)= 1; %esto significa 
    elseif up1(i) <110 & up2(i)>50
        respuesta(i)=2;
    elseif up1(i)>110 & up2(i)>50
        respuesta(i)=3;
    end
end
        


        
subplot(2,2,1)
plot(signal.Data{1,1},up1,'-r', 'LineWidth', 1.5)

subplot(2,2,2)
plot(signal.Data{1,1},up2, '-r', 'LineWidth', 1.5)

subplot(2,2,3)
plot(signal.Data{1,1}, respuesta) 
