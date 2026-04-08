/*Exercice 1 : Filtrage et INNER JOIN
Utiliser la base suivante de la bibliothèque SASHELP :
— SASHELP.PRDSAL2
1. Créer deux sous-ensembles à partir de la table PRDSAL2 :
— sales_1995 : toutes les observations de l’année 1995
— sales_1997 : toutes les observations de l’année 1997
2. Filtrer les deux tables pour ne conserver que les lignes correspondant :
— au mois de janvier (Month)
Indice : utiliser la syntaxe put(Month, MONNAME3.) = "Jan"
3. Ne conserver que les variables suivantes et renommer actual :
— country
— state
— product
— actual → actual_1995 pour la table 1995 et actual_1997 pour la table 1997
4. Trier les deux tables par country, state et product.
5. Réaliser une jointure de type INNER JOIN :
— fusionner sales_1995_clean et sales_1997_clean
— enregistrer le résultat dans une table dans votre bibliothéque*/


/* 1 et 2 */
data sales_1995 sales_1997;
    set sashelp.prdsal2;
    if put(Month, MONNAME3.) = "Jan" then do;
        if year = 1995 then output sales_1995;
        else if year = 1997 then output sales_1997;
    end;
run;

/* 3 */
data sales_1995_clean;
    set sales_1995(keep=country state product actual);
    rename actual = actual_1995;
run;

data sales_1997_clean;
    set sales_1997(keep=country state product actual);
    rename actual = actual_1997;
run;

/* 4 */
proc sort data=sales_1995_clean;
    by country state product;
run;

proc sort data=sales_1997_clean;
    by country state product;
run;

/* 5 */
libname lib_data "/home/u64474285/sasuser.v94/Les_datasets_SAS";

data lib_data.sales;
    merge sales_1995_clean sales_1997_clean ;
    by country state product;
run;



/* Exercice 2 : Importation d’un fichier CSV
Vous disposez du fichier :
winter_olympics_medals.csv sur Moodle.
1. Importer dans un premier temps le fichier CSV sur SAS Studio.
2. Importer ce fichier dans SAS en utilisant PROC IMPORT.
3. Enregistrer la table importée dans votre bibliothèque personnelle.
4. Vérifier la structure de la base (noms des variables et types).
5. Afficher les premières observations de la table.*/

proc import datafile="/home/u64474285/sasuser.v94/Les_datasets_SAS/winter_olympics_medals.csv"
    out=lib_data.olympics
    dbms=csv
    replace;
    guessingrows=max;
run;

proc contents data=lib_data.olympics;
run;

proc print data=lib_data.olympics (obs=10);
run;

/*Exercice 3 : Utilisation de PROC FREQ (Base Olympics)
Utiliser la base que vous avez importer dans l’exercice 2 qui contient les résultats des
Jeux Olympiques d’hiver. La base contient les variables suivantes : id, sport, year,
medal, country, host, pays.
1. Produire une table de fréquence simple pour la variable sport.
2. Trier la base par la variable year puis utiliser PROC FREQ avec l’instruction BY year
afin d’obtenir les fréquences par année.
3. Exporter les résultats obtenus avec BY dans un fichier Excel en utilisant ODS EXCEL.
4. Produire ensuite un tableau croisé entre les variables :
— country
— medal
5. Sauvegarder ce tableau croisé comme une table SAS dans votre bibliothèque personnelle.*/

/*1*/
proc freq data= lib_data.olympics ;
	BY year ;
	Table sport year ;
RUN;

proc sort data=lib_data.olympics;
    by year;
run;

proc freq data=lib_data.olympics;
    by year;
    tables sport;
run;

/*2-3*/
ODS EXCEL FILE ="/home/u64474285/resultats_sport_by_year.xlsx ";
PROC FREQ DATA = lib_data.olympics ;
	by year;
	TABLES sport ;
RUN ;
ODS EXCEL CLOSE ;


/*  4 et 5 */
proc freq data=lib_data.olympics;
    tables country*medal / out=lib_data.olympics_crosstab;
run;

proc print data=lib_data.olympics_crosstab(obs=20);
run;

/*
Exercice 4 : Analyse statistique avec PROC MEANS
(Base Baseball)
Utiliser la base SASHELP.BASEBALL.
Variables quantitatives possibles :
— nAtBat
— nHits
— nHome
— nRuns
— nRBI
1. Calculer les statistiques descriptives principales (moyenne, minimum, maximum,
écart-type) pour les variables quantitatives ci-dessus en utilisant PROC MEANS.
2. Réaliser ensuite une analyse par groupe avec l’instruction BY en utilisant la variable :
— League
3. Réaliser la même analyse mais cette fois en utilisant l’instruction CLASS avec la
même variable (League).
4. Comparer les résultats obtenus avec les méthodes BY et CLASS.
5. Exporter les résultats dans un fichier PDF en utilisant ODS PDF.
6. Ajouter un titre différent pour chaque analyse :
— Analyse avec PROC MEANS et BY
— Analyse avec PROC MEANS et CLASS
*/

/*1*/
proc print data =SASHELP.BASEBALL;
run;

proc means data = SASHELP.BASEBALL;
var nAtBat nHits nHome nRuns nRBI;
run;

/*2-3*/
proc sort data=SASHELP.BASEBALL out= baseball_sorted;
	by league;
run;

title "analyse_avec_BY";

proc means data=baseball_sorted;
	by league;
	var nAtBat nHits nHome nRuns nRBI;
run;

title "Analyse avec PROC MEANS et CLASS";
proc means data=baseball_sorted;
	class league;
	var nAtBat nHits nHome nRuns nRBI;
run;



/*5-6*/



	
/*Exercice 5 : Analyse graphique des médailles par pays
À partir de la base que vous avez importer dans l’exercice 2 et en utilisant uniquement
les variables : sport, year, medal, country, host, pays, créer une nouvelle table
résumée par pays.
1. Créer une table medals_by_country contenant, pour chaque pays :
— Le nombre total de médailles (total)
— Le nombre de médailles d’or (gold)
— Le nombre de médailles d’argent (silver)
— Le nombre de médailles de bronze (bronze)
2. Utiliser PROC UNIVARIATE sur cette table pour analyser la distribution des médailles
totales par pays (statistiques descriptives, histogramme, boîte à moustaches).
3. Créer différents graphiques avec PROC SGPLOT :
— Histogramme des médailles totales par pays
— Diagrammes en barres pour les médailles d’or, d’argent et de bronze par pays
4. Enregistrer toutes les images créées dans un répertoire dédié sur SAS Studio à l’aide
d’ODS GRAPHICS.*/

/* Question 1 */
proc sort data=lib_data.olympics out=olympics_sorted;
    by country;
run;

data lib_data.medals_by_country;
    set olympics_sorted;
    by country;

    if first.country then do;
        gold = 0;
        silver = 0;
        bronze = 0;
        total = 0;
    end;

    if medal = "gold" then gold + 1;
    else if medal = "silver" then silver + 1;
    else if medal = "bronze" then bronze + 1;

    total + 1;

    /* Sortir la ligne à la fin de chaque pays */
    if last.country then output;
    
    keep country gold silver bronze total;
run;


/* Question 2 */

proc univariate data=lib_data.medals_by_country;
    var total;
    histogram total / normal;
    inset mean median std / position=ne;
    title "Analyse univariée des médailles totales";
run;

/* Question 4 */

ods listing gpath="/home/u64400321/Images" image_dpi=300;
ods graphics on;


ods graphics / reset imagename="Histogram_Total";

proc sgplot data=lib_data.medals_by_country;
    histogram total;
    title "Histogramme des médailles totales par pays";
run;


ods graphics / reset imagename="Bar_Medals_gold";

proc sgplot data=lib_data.medals_by_country(where=(gold>10));
    vbar country / response=gold;
    title "Médailles d'or par pays";
run;

ods graphics / reset imagename="Bar_Medals_silver";

proc sgplot data=lib_data.medals_by_country(where=(silver>10));
    vbar country / response=silver;
    title "Médailles d'argent par pays";
run;

ods graphics / reset imagename="Bar_Medals_bronze";

proc sgplot data=lib_data.medals_by_country(where=(bronze>10));
    vbar country / response=bronze;
    title "Médailles de bronze par pays";
run;

ods listing close;
ods graphics off;
