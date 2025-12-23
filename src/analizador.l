/* analizador.l */
%option noyywrap

%{
#include <iostream>
#include <vector>
#include <string>
#include <iomanip>
#include <stdio.h>
#include <cstdlib>
#include <fstream>
/* Librería para que la consola pille bien las tildes y caracteres especiales */
#include <clocale>

using namespace std;

/* --- Variables para guardar los datos --- */
/* Aquí vamos metiendo los nombres de las enfermedades que encontremos */
vector<string> Nombres;

/* Vectores para guardar los datos de cada columna (Hombres y Mujeres por edad) */
vector<string> H_Total, H_0_14, H_15_29, H_30_44, H_45_64, H_65_mas;
vector<string> M_Total, M_0_14, M_15_29, M_30_44, M_45_64, M_65_mas;

ifstream fichero; 
int col = 0;   /* Para saber en qué columna de la tabla estamos */
int fila = 0;  /* Contador de filas */
bool guardar = false; /* Interruptor para saber si guardamos el dato o pasamos de él */

/* Función auxiliar para limpiar la basura del HTML */
string limpiar(string texto) {
    string sal = texto;
    // Buscamos el igual para quedarnos solo con el valor de la derecha
    size_t pos = sal.find_last_of("=");
    if (pos != string::npos) sal = sal.substr(pos + 1);
    
    // Quitamos comillas, barras y cosas raras que sobran
    string aux = "";
    for (char c : sal) {
        if (c != '"' && c != '/' && c != '>' && c != '\\') aux += c;
    }
    // Si al limpiar no queda nada, devolvemos un 0 por defecto
    if (aux == "" || aux == " ") return "0";
    return aux;
}
%}

/* --- Definiciones básicas para Flex --- */
digito      [0-9]
mayus       [A-Z]
letra       [a-z]
cualquiera  .   

/* Patrones para pillar nombres (palabras sueltas o compuestas) */
palabra     (({mayus}+|{cualquiera}){letra}*{cualquiera}*{letra}*)
compuesta   ({palabra}\b{palabra})
texto_enf   ({palabra}|{compuesta}+)

/* Etiquetas del HTML que nos interesan */
TAG_CAP     ("<caption caption=")
TAG_FIN     ("/>")
TAG_VAL     ("val=")
COMILLA     ("\"")

%%

{TAG_CAP}{COMILLA}{texto_enf}{COMILLA}{TAG_FIN} {
    /* Regla 1: Hemos encontrado un nombre de enfermedad */
    if(fila >= 0){    
        string t = limpiar(string(YYText()));
        
        /* Filtro manual para quitar cabeceras, totales y texto que no es enfermedad */
        if(t.find("Sexo") == string::npos && t.find("Hombres") == string::npos && 
           t.find("Mujeres") == string::npos && t.find("Edad") == string::npos &&
           t.find("TOTAL") == string::npos && t.find("Total") == string::npos &&
           t.find("Andaluc") == string::npos && t.find("Unidad") == string::npos &&  
           t.find("Fuente") == string::npos && t.find("Consej") == string::npos &&  
           t.find("A=") == string::npos && t.find("Nivel") == string::npos &&    
           t.find("Territorio") == string::npos && t.find("Medida") == string::npos &&    
           t.find("Casos") == string::npos && t.find("EDO") == string::npos &&       
           t.find("os") == string::npos && t.length() > 3) { 
            
            // Si pasa el filtro, activamos el guardado y metemos el nombre en la lista
            guardar = true;
            Nombres.push_back(t);
        } else {
            guardar = false;
        }
    }
    fila++;
}

{TAG_VAL}{COMILLA}[0-9.]+{COMILLA} {
    /* Regla 2: Hemos encontrado un valor numérico */
    col++;
    string v = limpiar(string(YYText()));
    
    // Solo guardamos si estamos en una fila válida (enfermedad real)
    if(guardar){
        switch (col){
            /* Hombres */
            case 1: H_Total.push_back(v); break;
            case 2: H_0_14.push_back(v); break;
            case 3: H_15_29.push_back(v); break;
            case 4: H_30_44.push_back(v); break;
            case 5: H_45_64.push_back(v); break;
            case 6: H_65_mas.push_back(v); break;
            /* Mujeres */
            case 7: M_Total.push_back(v); break;
            case 8: M_0_14.push_back(v); break;
            case 9: M_15_29.push_back(v); break;
            case 10: M_30_44.push_back(v); break;
            case 11: M_45_64.push_back(v); break;
            case 12: 
                M_65_mas.push_back(v); 
                col = 0; // Reiniciamos columna porque se acaba la fila
                break;
        }
    } else { 
        // Si no guardamos, controlamos que el contador no se desmadre
        if (col >= 12) col = 0; 
    }
}

.|\n    { /* Ignoramos todo lo que no coincida con las reglas anteriores */ }

%%

/* --- Programa Principal --- */

void ver_datos(int i) {
    if(i >= Nombres.size()) return;
    
    // Limpiamos pantalla antes de mostrar la ficha para que se vea claro
    system("clear");
    
    cout << "==========================================================" << endl;
    cout << " FICHA TÉCNICA: " << Nombres[i] << endl;
    cout << "==========================================================" << endl;
    cout << left << setw(15) << "RANGO" << setw(15) << "HOMBRES" << setw(15) << "MUJERES" << endl;
    cout << "----------------------------------------------------------" << endl;
    
    if (i < H_0_14.size()) {
        cout << left << setw(15) << "0-14"   << setw(15) << H_0_14[i]    << setw(15) << M_0_14[i] << endl;
        cout << left << setw(15) << "15-29"  << setw(15) << H_15_29[i]   << setw(15) << M_15_29[i] << endl;
        cout << left << setw(15) << "30-44"  << setw(15) << H_30_44[i]   << setw(15) << M_30_44[i] << endl;
        cout << left << setw(15) << "45-64"  << setw(15) << H_45_64[i]   << setw(15) << M_45_64[i] << endl;
        cout << left << setw(15) << "> 65"   << setw(15) << H_65_mas[i]  << setw(15) << M_65_mas[i] << endl;
        cout << "----------------------------------------------------------" << endl;
        cout << left << setw(15) << "TOTAL" << setw(15) << H_Total[i]   << setw(15) << M_Total[i] << endl;
    } 
    cout << endl;
}

int main(int argc, char *argv[]){
    // Configuración para que se vean bien las tildes en Linux
    setlocale(LC_ALL, ""); 

    char op = '0';
    int id = 0;
    
    fichero.open("data.html");
    
    // Si no tenemos el fichero, lo descargamos automáticamente
    if(!fichero){
        cout << "No encuentro 'data.html'. Descargando..." << endl;
        
        // Usamos curl para bajar el archivo y una tubería con iconv para 
        // arreglar la codificación (pasar de ISO-8859-1 a UTF-8)
        system("curl -s -L -k --data 'codConsulta=20072' https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/STPivot.jsp | iconv -f ISO-8859-1 -t UTF-8 > data.html");
        
        fichero.open("data.html");
    }

    // Le pasamos el fichero al analizador léxico
    yyFlexLexer lexico(&fichero, 0);
    lexico.yylex();

    // Limpiamos pantalla antes de entrar al menú
    system("clear");

    do {
        cout << "==========================================" << endl;
        cout << "     SISTEMA DE VIGILANCIA EDO" << endl;
        cout << "==========================================" << endl;
        cout << " 1. Ver lista de enfermedades" << endl;
        cout << " 2. Ver detalles (ID)" << endl;
        cout << " 3. Borrar datos y salir" << endl;
        cout << " 4. Salir" << endl;
        cout << "==========================================" << endl;
        cout << " Opción > ";
        cin >> op;
        
        switch(op){
            case '1':
                system("clear"); // Limpiamos para poner la lista arriba
                cout << "--- LISTADO ---" << endl;
                for(int i=0; i<Nombres.size(); i++) 
                    cout << " [" << i << "] " << Nombres[i] << endl;
                cout << endl;
            break;

            case '2':
                cout << " Introduce ID: ";
                cin >> id;
                // Comprobamos que el ID sea valido antes de mostrar nada
                if(id >= 0 && id < Nombres.size()) ver_datos(id);
                else cout << " [!] ID incorrecto." << endl;
            break;

            case '3': 
                system("rm data.html"); 
                cout << " [OK] Datos borrados." << endl;
                op = '4'; // Forzamos la salida para obligar a reiniciar
            break;

            case '4': 
                cout << "Saliendo." << endl; 
            break;
        }
    } while(op != '4');

    return 0;
}
