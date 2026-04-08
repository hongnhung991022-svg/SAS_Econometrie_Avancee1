/*Exercice 1 : Analyse de voitures (SASHELP.CARS)
Contexte : La table SASHELP.CARS contient des informations sur différentes voitures.
On souhaite analyser les prix.
Consignes :
1. Créer une variable prix_ttc = MSRP * 1.2.
2. Créer une variable categorie : "Bas" si prix_ttc < 20000, "Moyen" si 20000 <=
prix_ttc <= 40000, "Élevé" si prix_ttc > 40000.
3. Ne garder que les variables Make, Model, prix_ttc, categorie.
4. Ajouter des labels pour toutes les variables et formater prix_ttc en $.
5. Supprimer les voitures dont le prix TTC est inférieur à 20000$.*/

data voitures_analyse;
    set sashelp.cars;
	
    prix_ttc = MSRP * 1.2;

run;

data voitures_analyse;
    set voitures_analyse;
    length categorie $6.;

    if prix_ttc < 20000 then categorie="Bas";
    else if prix_ttc <= 40000 then categorie="Moyen";
    else categorie="Eleve";

    keep Make Model prix_ttc categorie;

run;


data voitures_analyse;
    set voitures_analyse;

    label Make="Marque"
          Model="Modèle"
          prix_ttc="Prix TTC"
          categorie="Catégorie prix";
          
    format prix_ttc dollar10.;
run;


data voitures_analyse;
    set voitures_analyse;

    if prix_ttc < 20000 then delete;
run;

data voitures_analyse;
    set voitures_analyse(where=(prix_ttc > 20000));

    *if prix_ttc < 20000 then delete;
run;





/*Exercice 2 : Notes des élèves (SASHELP.CLASS)
Contexte : La table SASHELP.CLASS contient les informations d’élèves d’une classe.
On souhaite analyser les tailles et poids et séparer par sexe.
Consignes :
1. Créer une variable cat_taille : "Petit" si Height < 60, "Moyen" si 60 <= Height
< 65, "Grand" si Height >= 65.
2. Ajouter des labels pour toutes les variables.
3. Séparer les élèves en deux data sets : femmes (Sex=’F’) et hommes (Sex=’M’) avec
THEN OUTPUT.
4. Concaténer les deux data sets pour recréer classe_finale.*/

data classe1;
	set sashelp.class;
	
	if Height < 60 then cat_taille="Petit";
    else if Height < 65 then cat_taille="Moyen";
    else cat_taille="Grand";
	
run;

data classe2;
	set classe1;
	
	    label Name="Nom"
          Sex="Sexe"
          Age="Âge"
          Height="Taille"
          Weight="Poids"
          cat_taille="Categorie taille";

run;

data femmes hommes;
	set classe2;
	
	if Sex='F' then output femmes;
    else if Sex='M' then output hommes;
	
run;

data hommes;
	set hommes;
	drop Age;
run;

data classe_finale;
	set femmes hommes;
run;




/*Exercice 3 : Ventes de chaussures (SASHELP.SHOES)
Contexte : La table SASHELP.SHOES contient les ventes de chaussures par région et
produit. On souhaite analyser le chiffre d’affaires et créer des catégories.
Consignes :
1. Créer une variable categorie_CA : "Faible" si Sales < 2000, "Moyen" si 2000 <=
Sales <= 4000, "Élevé" si Sales > 4000.
1
2. Ne garder que les variables Region, Product, Subsidiary, Sales, categorie_CA.
3. Ajouter des labels pour toutes les variables.
4. Créer deux data sets CA_eleve et CA_autre en utilisant THEN OUTPUT.
5. Concaténer les deux data sets pour obtenir CA_final*/

data ventes_categorise;
    set sashelp.shoes;

    if Sales < 2000 then categorie_CA="Faible";
    else if Sales <= 4000 then categorie_CA="Moyen";
    else categorie_CA="Eleve";

    label Region="Région"
          Product="Produit"
          Subsidiary="Filiale"
          Sales="Ventes"
          categorie_CA="Catégorie CA";

    keep Region Product Subsidiary Sales categorie_CA;
run;

data CA_eleve CA_autre;
	set ventes_categorise;

    if categorie_CA="Eleve" then output CA_eleve;
    else output CA_autre;
run;

data CA_final;
    set CA_eleve CA_autre;
run;





data villes_pays;
    infile datalines dlm=',' dsd;
    length Ville $12 Pays $50;
    input Ville $ Pays $;
datalines;
"Addis Ababa","Ethiopia"
"Al-Khobar","Saudi Arabia"
"Algiers","Algeria"
"Auckland","New Zealand"
"Bangkok","Thailand"
"Bogota","Colombia"
"Budapest","Hungary"
"Buenos Aires","Argentina"
"Cairo","Egypt"
"Calgary","Canada"
"Canberra","Australia"
"Caracas","Venezuela"
"Chicago","USA"
"Copenhagen","Denmark"
"Dubai","United Arab Emirates"
"Geneva","Switzerland"
"Heidelberg","Germany"
"Jakarta","Indonesia"
"Johannesburg","South Africa"
"Khartoum","Sudan"
"Kingston","Jamaica"
"Kinshasa","DR Congo"
"Kuala Lumpur","Malaysia"
"La Paz","Bolivia"
"Lisbon","Portugal"
"London","UK"
"Los Angeles","USA"
"Luanda","Angola"
"Madrid","Spain"
"Managua","Nicaragua"
"Manila","Philippines"
"Mexico City","Mexico"
"Minneapolis","USA"
"Montevideo","Uruguay"
"Montreal","Canada"
"Moscow","Russia"
"Nairobi","Kenya"
"New York","USA"
"Ottawa","Canada"
"Paris","France"
"Prague","Czech Republic"
"Rome","Italy"
"San Juan","Puerto Rico"
"Santiago","Chile"
"Sao Paulo","Brazil"
"Seattle","USA"
"Seoul","South Korea"
"Singapore","Singapore"
"Tel Aviv","Israel"
"Tokyo","Japan"
"Toronto","Canada"
"Vancouver","Canada"
"Warsaw","Poland"
;
run;

proc sort data=CA_final; by subsidiary; 
run;

proc sort data=villes_pays; by Ville; 
run;

data CA_final;
    merge CA_final (in=a)
          villes_pays (in=b rename=(Pays=subsidiary_country Ville=subsidiary));
    by subsidiary;
    if a;
run;
