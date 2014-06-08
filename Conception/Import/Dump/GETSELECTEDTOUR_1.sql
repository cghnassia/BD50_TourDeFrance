--------------------------------------------------------
--  DDL for Function GETSELECTEDTOUR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."GETSELECTEDTOUR" 
RETURN varchar2 IS
gtour varchar2(50);
cookie OWA_COOKIE.COOKIE;
BEGIN
	 cookie := OWA_COOKIE.GET('Tour');
   if(cookie.num_vals > 0) then
     gtour  := cookie.VALS(1);
  else
     select max(tour_annee) into gtour from tour;  
  end if;
   RETURN gtour;
END getSelectedTour;

/
