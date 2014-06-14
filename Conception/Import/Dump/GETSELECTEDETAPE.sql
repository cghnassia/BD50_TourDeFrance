--------------------------------------------------------
--  DDL for Function GETSELECTEDETAPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."GETSELECTEDETAPE" 
RETURN varchar2 IS
getape varchar2(50);
cookie OWA_COOKIE.COOKIE;
BEGIN
	 cookie := OWA_COOKIE.GET('Etape');
   if(cookie.num_vals > 0) then
     getape  := cookie.VALS(1);
  else
     select max(etape_num) into getape from terminer_etape where tour_annee=getselectedtour;
  end if;
   RETURN getape;
END GETSELECTEDETAPE;

/
