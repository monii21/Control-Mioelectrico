close
clear
clc

%cargamos los datos en una variable
signal=load("EMG 2 channel Wrist Flex_Ext_Raw.mat");

%cargamos la aplicacion de app designer
app=app1;

%consideramos que estamos en el estado inicial que es el 1
estado=1; %tenemos 3 estados
valor_estado=0; %inicializamos la variable que nos va a almacenar en que tipo de "movimiento" estamos dentro de cada estado
cocontrac=false; %inicializamos la variable que nos va a marcar la existencia de cocontraccion

%Rectificamos los datos, es decir, hacemos que los valores negativos sean
%positivos y viceversa. Para ello usamos el comando abs que es el valor
%absoluto
signal.Data{1,2}=abs(signal.Data{1,2});
signal.Data{1,3}=abs(signal.Data{1,3});

%en el dato "data" tenemos 3 columnas, la 1 es el tiempo, la 2 es la señal
%flexion y la 3 es la señal contracción

% A continuación hay que rectificar la señal, se va a usar la media 
tam1=length(signal.Data{1,2});
tam2=length(signal.Data{1,3});


[up1,lo1]=envelope(signal.Data{1,2}, 250, 'rms'); %ojo el envelope no puede ser de tipo peak porque nos "deshace" lo aplicado con abs
[up2,lo2]=envelope(signal.Data{1,3},250, 'rms');  %es decir, "recupera" los valores negativos

%creamos el array donde vamos a plotear las tres "respuestas" :
%Señal1=activo, señanal2=activo, cocontraccion=activo.
respuesta=zeros(1,tam1);

for i=1: tam1
    if up1(i)>110 & up2(i)<50 
        respuesta(i)= 1; %Flexion
    elseif up1(i) <110 & up2(i)>50
        respuesta(i)=2;  %extension
    elseif up1(i)>110 & up2(i)>50
        respuesta(i)=3;  %cocontraccion
    end
end

%imprimimos las gráficas correspondientes a las dos señales y la salida
subplot(2,2,1)
plot(signal.Data{1,1},up1,'-r', 'LineWidth', 1.5)

subplot(2,2,2)
plot(signal.Data{1,1},up2, '-r', 'LineWidth', 1.5)

subplot(2,2,3)
plot(signal.Data{1,1}, respuesta)


for i=1:tam1
    
    if up1(i)> 110 && up2(i)>50 % hay una cocontracción
      
       cocontrac=true; %nos va a servir para comprobar cuando se deja de detectar la cocontraccion y no estar cambiando el estado todo el rato
       app.Switch.Value='On'; 
       pause(0.001); %se pone 0.0001 que es la direferencia de unidad del data{1,1}
       
    end
    
    %comprobamos si se ha dejado de detectar una cocontraccion para cambiar
    %el estado
    if cocontrac==true && ((up1(i)> 110 && up2(i)<50) || (up1(i)< 110 && up2(i)>50)) %comprobamos que se ha dejado de detectar una cocont
        if estado==1 
            estado=2;
        elseif estado==2
            estado=3;
        elseif estado==3
            estado=1;
        end
        cocontrac=false;
        app.Switch.Value='Off';
    end
    
    %en caso de que no haya cocontracción asignamos el valor del estado
    %correspondiente
    if cocontrac==false 
        if up1(i)>110 && up2(i)<50 
            valor_estado= 1; 
        elseif up1(i) <110 && up2(i)>50 
            valor_estado=2;
        else
            valor_estado=0; %esta en reposo
        end
    else 
        valor_estado=0;
    end
    %encendemos las bombillas correspondientes al estado en que estemos
    switch estado
        case 1
            if valor_estado==1
                app.FlexinLamp.Color='red';
                pause(0.001)%paramos la ejecución cada 0,3s para simular una lectura de datos en tiempo real
                app.FlexinLamp.Color='black';
            elseif valor_estado==2
                app.ExtensinLamp.Color='blue';
                pause(0.001)
                app.ExtensinLamp.Color='black';
            elseif valor_estado==0 
                app.FlexinLamp.Color='black';
                app.ExtensinLamp.Color='black';
            end
        case 2
            if valor_estado==1
                app.PronacinLamp.Color='red';
                pause(0.001)
                app.PronacinLamp.Color='black';
            elseif valor_estado==2
                app.SupinacinLamp.Color='blue';
                pause(0.001)
                app.SupinacinLamp.Color='black';
            elseif valor_estado==0
                app.PronacinLamp.Color='black';
                app.SupinacinLamp.Color='black';
            end
        case 3
            if valor_estado==1
                app.AbduccinLamp.Color='red';
                pause(0.001)
                app.AbduccinLamp.Color='black';
            elseif valor_estado==2
                app.AduccinLamp.Color='blue';
                pause(0.001)
                app.AduccinLamp.Color='black';
            elseif valor_estado==0
                app.AbduccinLamp.Color='black';
                app.AduccinLamp.Color='black';
            end
    end

end