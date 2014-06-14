--------------------------------------------------------
--  DDL for Function RECUP_MAX_ETAPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_MAX_ETAPE" 
RETURN etape.etape_num%TYPE IS
n_etape etape.etape_num%TYPE;
BEGIN
	SELECT max(etape_num) INTO n_etape FROM terminer_etape WHERE tour_annee=GETSELECTEDTOUR;
     return n_etape;
END RECUP_MAX_ETAPE;

/
