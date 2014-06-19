CREATE OR REPLACE FUNCTION returnVille(numVille ville.num_ville%type)
RETURN ville.nom_ville%type IS
nomVille ville.nom_ville%type;
BEGIN
	select ville_nom into nomVille from ville where ville.ville_num =  numVille;
   
   RETURN nomVille;
END;
/

create or replace FUNCTION returnPays(numPays pays.pays_num%type)
RETURN pays.pays_nom%type IS
nomPays pays.pays_nom%type;
BEGIN
	select pays_nom into nomPays from pays where pays.pays_num =  numPays;
   
   RETURN nomPays;
END;
/

create or replace FUNCTION returnNomCycliste(num cycliste.cycliste_num%type)
RETURN cycliste.cycliste_nom%type IS
nom cycliste.cycliste_nom%type;
BEGIN
	select cycliste_nom into nom from cycliste where cycliste.cycliste_num = num;
   RETURN nom;
END;
/

create or replace FUNCTION returnPrenomCycliste(num cycliste.cycliste_num%type)
RETURN cycliste.cycliste_prenom%type IS
prenom cycliste.cycliste_prenom%type;
BEGIN
	select cycliste_prenom into prenom from cycliste where cycliste.cycliste_num = num;
   RETURN prenom;
END;
/

create or replace FUNCTION returnDateCycliste(num cycliste.cycliste_num%type)
RETURN cycliste.cycliste_daten%type IS
daten cycliste.cycliste_daten%type;
BEGIN
	select cycliste_daten into daten from cycliste where cycliste.cycliste_num = num;
   RETURN daten;
END;
/

create or replace FUNCTION returnNomEquipe(num equipe.equipe_num%type)
RETURN equipe.equipe_nom%type IS
nom equipe.equipe_nom%type;
BEGIN
	select equipe_nom into nom from equipe where equipe.equipe_num = num;
   RETURN nom;
END;
/

create or replace FUNCTION convertTemps(heure number,minu number, sec number, cent number )
RETURN vtps in number(10)
vtps number(10);
BEGIN
	vtps:=(heure*60*60*60)+(minu*60*60)+(sec*60)+cent;
   RETURN tps;
END;
/

