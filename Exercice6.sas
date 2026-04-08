/* Exercice 1 : Variables globales avec %LET
On utilise la table sashelp.class contenant des informations sur des étudiants (Name,
Age, Height, Weight).
1. Créer les variables macro globales suivantes :
— seuil_age = 13
— coef_poids = 1.1
2. Créer un nouveau dataset class_modifie dans lequel :
— Weight_adj = Weight × coef_poids
— jeune = 1 si Age < seuil_age, 0 sinon
3. Afficher les résultats avec PROC PRINT.
4. Modifier les valeurs des variables macro et observer les changements.*/

proc print data= sashelp.class;
	var name age height weight;
run;

%let seuil_age = 13;
%let coef_poids = 1.1;

data class_analyse;
	set sashelp.class;
	Weight_adj = Weight * &coef_poids;
	
	if age < &seuil_age. then jeune =1;
	else jeune =0;
run;

proc print class_analyse;
run;

/*
Exercice 2 : Macro-programme avec variables locales
On utilise la table sashelp.cars.
1. Écrire une macro %ajustement avec les paramètres :
— var
— taux
— data= (par défaut sashelp.cars)
Indice : avec le "=" on peut définir une valeur par défaut.
2. À l’intérieur de la macro :
— Définir une variable locale facteur = 1 + taux
— Créer une variable var_adj = var × facteur
3. Exécuter la macro avec différents paramètres.*/

proc print data = sashelp.cars;
run;

%macro adjustement(var,taux,data= sashelp.cars );
	
	%local facteur;
	%let facture = %sysevalf(1+ &taux);
	
	data ajuste;
	set &data;
	&var._adj= &var + &facture;
	run;

	proc print data=ajuste (obs=10);
	run;

%mend;

%adjustement(MPG_City,0.05)
%adjustement(Horsepower,0.10)
%adjustement(Weight,0.02,data=sashelp.cars);


/*Exercice 3 : Boucles et conditions dans une macro
On utilise sashelp.class.
1. Écrire une macro %analyse_var qui :
— Parcourt les variables Height et Weight avec une boucle
2. Pour chaque variable :
— Calculer la moyenne avec PROC MEANS
3. Ajouter une condition :
— Si la moyenne > 100 afficher “Valeur élevée”
— Sinon afficher “Valeur faible”
4. Utiliser %DO, %IF, %THEN, %ELSE.*/

%macro analyse_var(height,weight,data=sashelp.class);
	%local vars;
	%let vars= height weight;
	



/*Exercice 4 : Régression OLS et extraction des résultats
On utilise sashelp.cars.
1. Estimer le modèle :
MPG_City = β0 + β1Horsepower + β2W eight
avec PROC REG.
2. Utiliser :
— ODS OUTPUT ParameterEstimates=param_ods
3. Puis :
— OUTEST=param_outest
4. Comparer :
— Le format des deux tables
— Le contenu (coefficients, statistiques)
5. Expliquer les différences d’usage.*/


proc reg data=sashelp.cars;
	model MPG_City = Horsepower Weight;
run;
	
ODS OUTPUT ParameterEstimates=param_ods;

proc reg data=sashelp.cars;
	model MPG_City = Horsepower Weight;
run;

ods output close;	

proc reg data=sashelp.cars OUTEST=param_outest ;
	model MPG_City = Horsepower Weight;
run;


/*Exercice 5 : Modèles Logit et Probit
On utilise sashelp.cars.
1. Créer une variable binaire :
— eco = 1 si MPG_City > 20, 0 sinon
2. Estimer un modèle Logit :
eco = f(Horsepower, W eight) avec PROC LOGISTIC.
3. Estimer un modèle Probit avec link=probit.
4. Utiliser l’option :
— OUTPUT OUT=pred_data P=prob_pred
pour stocker les probabilités prédites.
5. Comparer les probabilités issues du Logit et du Probit.*/

data cars_analyse;
	set sashelp.cars;
	
	if MPG_City > 20 then eco =1;
	else eco =0;
run;

proc logistic data=cars_analyse;
	model eco(event='1') = Horsepower Weight;
run;

proc logistic data =cars_analyse ;
	model eco(event='1') = Horsepower Weight / link = probit;
	output out = pred_probit p = pro_probit ;
run ;
	
proc logistic data =cars_analyse ;
	model eco(event='1') = Horsepower Weight / link = logit;
	output out = pred_logit p = pro_logit ;
run ;

proc means data=pred_logit;
	var pro_logit;
run;

proc means data=pred_probit;
	var pro_probit;
run;