/* Exercice 1 : Création de datasets simples
1. Créer un dataset db_simple1 avec 3 observations, contenant :
— 2 variables numériques
— 1 variable caractère
Utiliser l’instruction DATALINES sans préciser d’informat.
2. Vérifier le dataset via l’interface SAS.
3. Créer un dataset db_simple2 avec :
— 1 variable numérique entière
— 1 variable numérique avec deux décimales
— 1 variable caractère (au moins une observation > 8 caractères)
Appliquer les informats adaptés.
4. Ajouter un FORMAT statement pour :
— n’afficher qu’une seule décimale pour les variables numériques */

data db_simple1;
	input nom_char $ age_num1 note_num2;
	datalines;
Hugo  	20 15
Pierre  26 12
Anne 	22 17
;
run;

*Vérifier le dataset via l’interface SAS;
proc print data= db_simple1;
	title "dataset db_simple1";
run;

data db_simple2;
	input nom_char $ age_num1 note_decimal 4.1;
	format note_decimal 4.2 ;
	datalines;
Jennyrubyjean  	30 15.4
LalisaManoban  	29 12.7
Rose 			29 17.3
;
run;

proc print data= db_simple2;
	title "dataset db_simple1 avec format";
run;


/*Exercice 2 : Sauvegarde dans un dossier
1. Créer un dossier sur SAS Studio pour stocker les datasets SAS.
2. Assigner ce dossier à une library SAS avec la commande LIBNAME.
3. Sauvegarder les datasets db_simple1 et db_simple2 dans ce dossier.
*/

libname ma_lib "/home/u64474285/sasuser.v94/Les_datasets_SAS" ;

data ma_lib.db_simple1;
	set db_simple1;
run;

data ma_lib.db_simple2;
	set db_simple2;
run;

proc contents data=ma_lib._all_;
run;

/*Exercice 3 : Importation d’un fichier externe
1. Télécharger le fichier cars.txt et le placer dans le dossier de travail SAS Studio.
2. Utiliser la commande FILENAME pour associer ce fichier à un nom SAS, par exemple
Cars.
3. Créer un dataset SAS SAScars dans la library définie à l’exercice 2, en sélectionnant :
— uniquement les 5 premières observations
— toutes les colonnes du fichier ou seulement celles souhaitées (Brand, Type,
Origin, Cylinders)
4. Appliquer les informats adéquats pour chaque variable afin de garantir un format
correct dans SAS.
5. Sauvegarder le code SAS pour réutilisation*/

filename Cars '/home/u64474285/sasuser.v94/Les_datasets_SAS/cars.txt';

data Cars_data ;
	infile Cars firstobs= 2 obs=6 ;
	input Brand $ Type $ Origin $ Cylinders ;	
run;

proc print data=Cars_data;
run;

/*Exercice 4 : Creation et transformation d’un dataset
Contexte : Vous allez travailler sur une petite base de films. Chaque film a un titre,
une annee de sortie, une duree en minutes et une note sur 10. Vous allez creer le dataset
initial puis le transformer en utilisant des fonctions SAS.
1. Creer un dataset films1 avec 5 observations et 4 variables :
— Titre (caractere)
— Annee (numerique)
— Duree (numerique)
— Note (numerique)
Utiliser DATALINES pour entrer les donnees et verifier le dataset avec PROC PRINT.
2. Creer un nouveau dataset films2 a partir de films1 et ajouter :
— Titre_maj : titre en majuscules (UPCASE)
— Titre_net : titre sans espaces (COMPRESS)
— Titre_concat : concatenation du titre et de l’annee (CAT)
— Duree_heure : duree en heures (Duree/60)
— Note_sur100 : note sur 100 (Note*10)
Verifier le dataset avec PROC PRINT.
3. Creer un dataset final films_final avec :
— Titre original
— Titre_maj
— Duree_heure
— Note_sur100
4. Sauvegarder ce dataset dans votre library personnelle.*/

data film1;
	length Titre $20;
	input Titre $ Anne Duree Note;
	datalines;
Annabelle 2013 90 7
Home_Alone 2002 96 8
Iron_Man 2007 70 9
Spider_Man 2009 80 6
Toy_Story 2006 93 10
;
run;

/* 2. Création d'un nouveau dataset films2 avec transformations */
data film2;
	set film1;
	Titre_maj = upcase(Titre);
	Titre_net = compress(Titre,'_');
	Titre_concat = cat(Titre,Anne);
	Duree_heure = (Duree/60);
	Note_sur100 = (Note*10);
run;

proc print data=film2;
run;

/* 3. Création du dataset final films_final */

data films_final;
    set film2;
    
    keep Titre Titre_maj Duree_heure Note_sur100;
run;

proc print data=films_final;
run;


/* 4. Sauvegarde dans la library personnelle */

data ma_lib.films_final;
    set films_final;
run;
