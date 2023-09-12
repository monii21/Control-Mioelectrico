close
clear
clc

%cargamos los datos en una variable
signal_1=load("EMG 1 channel recording_MVC.mat");
signal_2=load("EMG 1 channel recording_Proportional.mat");



%Rectificamos los datos, es decir, hacemos que los valores negativos sean
%positivos y viceversa. Para ello usamos el comando abs que es el valor
%absoluto
signal_1.Data{1,2}=abs(signal_1.Data{1,2});
signal_2.Data{1,2}=abs(signal_2.Data{1,2});


%en el dato "data" tenemos 2 columnas, la 1 es el tiempo, la 2 es la señal

% A continuación hay que rectificar la señal, se va a usar la  envolvente
[up1,lo1]=envelope(signal_1.Data{1,2}, 500, 'rms');
[up2,lo2]=envelope(signal_2.Data{1,2}, 500, 'rms');


MVC=max(up1);

%calculo proporcional, es decir si mvc=100% el valor de up2 en porcentaje
%será X*100/mvc
tam1=length(signal_2.Data{1,2});
respuesta=zeros(1,tam1);

for i=1: tam1
    respuesta(i)= up2(i)*100/MVC;
end

plot(signal_2.Data{1,1},respuesta,'-r', 'LineWidth', 1.5)






