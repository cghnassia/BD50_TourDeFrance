CREATE OR REPLACE FUNCTION returnVille(numVille ville.num_ville%type)
RETURN ville.nom_ville%type IS
nomVille ville.nom_ville%type;
BEGIN
	select ville_nom into nomVille from ville where ville.ville_num =  numVille;
   
   RETURN nomVille;
END;
/

create or replace 
FUNCTION returnPays(numPays pays.pays_num%type)
RETURN pays.pays_nom%type IS
nomPays pays.pays_nom%type;
BEGIN
	select pays_nom into nomPays from pays where pays.pays_num =  numPays;
   
   RETURN nomPays;
END;
/

