/* Exercice 1 : Découverte d’un dataset avec PROC CONTENTS
Instructions : Utilisez le dataset sashelp.class. Affichez les informations sur les
variables et leurs types.
Questions :
1. Combien de variables contient le dataset ?
2. Quel est le type de la variable Age ? */

proc contents data=sashelp.class;
run;

/* Réponses :
   1. Nombre de variables : 5 (Name, Sex, Age, Height, Weight)
   2. Type de Age : Numérique
*/


/*Exercice 2 : Affichage des données avec PROC PRINT
Instructions : Affichez les 10 premières observations du dataset sashelp.cars.
Questions :
1. Combien d’observations sont affichées ?
2. Quelle est la marque de la première voiture ?*/

proc print data=sashelp.cars (firstobs=6 obs=10) NOOBS;
VAR make model;
run;

/* Réponses :
   1. Nombre d'observations affichées : 10
   2. Marque de la première voiture : Acura
*/


/* Exercice 3 : Tri des données avec PROC SORT
Instructions : Triez le dataset sashelp.class par ordre croissant de Age et affichez
le résultat.
Questions :
1. Qui est l’étudiant(e) le plus jeune ?
2. Qui est l’étudiant(e) le plus âgé(e) ? */

proc sort data=sashelp.class out=class_sorted;
    by Age sex;
run;

proc print data=class_sorted;
run;

/* Réponses :
   1. Étudiant le plus jeune : Joyce et Thomas (Age=11)
   2. Étudiant le plus âgé : Philip (Age=16)
*/


/* Exercice 4 : Trier, supprimer les doublons et afficher
sans la colonne Obs
Instructions : Utilisez le dataset sashelp.cars pour :
1. Supprimer les doublons pour ne garder qu’une observation par marque (Make) et
enregistrer cette base dans une nouvelle dataset appelée cars_filtered.
2. Trier les voitures par prix (MSRP) en ordre décroissant.
3. Afficher le résultat sans la colonne automatique Obs.
Questions :
1. Quelle est la voiture la plus chère ?
2. Combien de marques uniques sont affichées après suppression des doublons ? */

proc sort data=sashelp.cars out=cars_filtered nodupkey;
    by Make;
run;

proc sort data=cars_filtered ;
	by descending MSRP;
run;

proc print data=cars_filtred noobs;
run;

/* Réponses :
   1. Voiture la plus chère : Mercedes-Benz	G500 (MSRP=$76,870)
   2. Nombre de marques uniques affichés : ~38 pour sashelp.cars
*/
