%Numero de cada lado de la matriz de habitantes
hab = 500;
%Numero de lugares posibles
lug = 20;
lugNum = lug^2;
lugInf = 0;
%Numero de lugares visitados al dia
lugPerDay = 5;
%Indica el estado del individuo. 0 si esta sano, 1 si esta infectado y -1
%si está muerto
estado = zeros(hab);
%Indica con un 1 si tiene mascarilla y 0 si no
mascarilla = zeros(hab);
pMasc = 0.38;
%Infectados mascarilla obligatoria
minMasc = 0.1;
dayMasc = 0;
mascIsOn = false;
%Indica con un 1 si cumple la distancia y 0 si no
distancia = zeros(hab);
%Indica con un 1 si tiene la vacuna y 0 si no
vacuna = zeros(hab);
pVac = 0.05;
%Infectados vacuna obligatoria
minVac = 0.5;
dayVac = 0;
vacIsOn = false;
%Indica con un 1 si tiene anticuerpos y 0 si no
anticuerpos = zeros(hab);
%Indica la duracion de la enfermedad
duracion = zeros(hab);
%Indica el lugar de cada habitante. Si es 0 está en casa y no se puede
%infectar
lugar = zeros(hab);
%Probabilidad de contagio
p = 0.25;
%Probabilidad de muerte
deadp = 0.6;
%Efectividad de anticuerpos
antiC = 1;

%Dias transcurridos en la simulacion
dia = 0;
%Dias maximos en la simulacion
diaMax = 30;
%Duracion maxima en dias de la enfermedad
maxDur = 14;
%Asignamos un habitante aleatorio como paciente 0
xRandInf = randi(hab);
yRandInf = randi(hab);
estado(xRandInf, yRandInf) = 1;
%Asignamos a este habitantes el tiempo que va a estar infectado
%duracion(xRandInf, yRandInf) = randi(maxDur);
duracion(xRandInf, yRandInf) = maxDur;

%Historial de sanos
historialSane = zeros(1, diaMax);
%Historial de enfermos
historialInf = zeros(1, diaMax);
%Historial de muertos
historialDead = zeros(1, diaMax);

while sum(estado(:) == 1) ~= 0 && dia < diaMax
    dia = dia + 1;
    historialSane(dia) = sum(estado(:) == 0);
    historialInf(dia) = sum(estado(:) == 1);
    historialDead(dia) = sum(estado(:) == -1);
    fprintf('Day: %i\n', dia)
    fprintf('Sanos: %i\n', historialSane(dia))
    fprintf('Infectados: %i\n', historialInf(dia))
    fprintf('Muertos: %i\n', historialDead(dia))
    if (sum(historialInf))/(hab^2) >= minMasc && mascIsOn == false
        %Asumimos que todo el mundo usa mascarilla
        mascarilla = ones(hab);
        dayMasc = dia;
        mascIsOn = true;
    end
    if (sum(historialInf))/(hab^2) >= minVac && vacIsOn == false
        %Asumimos que todo el mundo usa mascarilla
        vacuna = ones(hab);
        dayVac = dia;
        vacIsOn = true;
    end
    for k = 1:lugPerDay
        %Actualizamos los destinos de cada persona
        for i = 1:hab
            for j = 1:hab
                lugar(i, j) = randi(lugNum);
            end
        end
        %disp('Lugares:');
        %disp(lugar);
        %Actualizamos el array de lugares en el que hay personas infectadas
        if ~ismember(lugar((estado == 1)), (lugInf))
            lugInf = lugar((estado == 1));
        end
        %Si coinciden, ¿se contagian o no? ¿Cuanto tiempo?
        for i = 1:hab
            for j = 1:hab
                %El lugar es 1 y es casa. Aqui no hay contagios
                if lugar(i, j) == 1
                    %Null
                elseif ismember(lugar(i, j), (lugInf)) && estado(i, j) == 0
                    %Actualizar. Queremos que varie la probabilidad de
                    %infeccion dependiendo de las medidas que tomen. de
                    %momento la probabilidad base es del 30%
                   
                    pTotal = p;
                    if estado(i, j) == -1
                        pTotal = 0;
                    end

                    if anticuerpos(i, j) == 1
                        pTotal = pTotal * antiC;
                    end
                    
                    if mascarilla(i, j) == 1
                        pTotal = pTotal*pMasc;
                    end

                    if vacuna(i, j) == 1
                        pTotal = pTotal*pVac;
                    end

                    if rand < pTotal
                        estado(i, j) = 1;
                        duracion(i, j) = randi(maxDur);
                        %duracion(i, j) = maxDur;
                        %fprintf('El habitante %i,%i ha coincidido con un infectado. SI se ha infectado. Estará %i dias enfermo.\n', i, j, duracion(i,j))
                    else
                        %fprintf('El habitante %i,%i ha coincidido con un infectado. NO se ha infectado.\n', i, j)
                    end
                end
            end
        end
        %Se podria borrar?
        lugar = zeros(hab);
    end
    %Le restamos un dia de enfermedad a todos los infectados
    duracion((estado == 1)) = duracion((estado == 1)) - 1;
    %estado(xRandInf, yRandInf) = 0;
    for i = 1:hab
        for j = 1:hab
            if estado(i,j) == -1
                continue   % no hacer nada con muertos
            elseif estado(i, j) == 0
                continue
            else
                if duracion(i,j) == 0
                    if rand < deadp
                        estado(i, j) = -1; %El individuo muere
                    else
                        estado(i, j) = 0; % El individuo se recupera
                        anticuerpos(i, j) = 1;
                    end
                else
                    %LLegados a este punto si la duracion es 0, el estado
                    %ya es 1, prueba a borrarlo
                    estado(i, j) = 1;
                end
            end
        end
    end
    
end

plot(historialSane(1:dia), 'g', 'LineWidth', 1.5);
hold on;
plot(historialInf(1:dia), 'y', 'LineWidth', 1.5);
plot(historialDead(1:dia), 'r', 'LineWidth', 1.5);
hold off;
if mascIsOn == true 
    xline(dayMasc, 'r--', 'Mascarillas Obligatorias');
end

if vacIsOn == true
    xline(dayVac, 'r--', 'Vacunas Obligatorias');
end


xlabel('Tiempo (dias)');
legend('Sanos', 'Infectados', 'Muertos');
grid on;