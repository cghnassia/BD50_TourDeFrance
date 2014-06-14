--------------------------------------------------------
--  DDL for Function RECUP_ACRO_PAYS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_ACRO_PAYS" 
(n_part participant.part_num%TYPE )
RETURN pays.pays_acro%TYPE IS
   v_acro pays.pays_acro%TYPE;
BEGIN
   SELECT DISTINCT 
		pays_acro INTO v_acro 
	FROM pays 
	INNER JOIN cycliste cy 
		ON pays.pays_num=cy.pays_num 
	INNER JOIN participant pa 
		ON cy.cycliste_num=pa.cycliste_num 
	WHERE pa.part_num=n_part 
	AND pa.tour_annee=GETSELECTEDTOUR ;
	return v_acro;
END RECUP_ACRO_PAYS;

/
