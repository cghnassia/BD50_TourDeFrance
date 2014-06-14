--------------------------------------------------------
--  DDL for Procedure UI_SELECT_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_SELECT_TOUR" 
(v_tour varchar2 default 2013) IS
CURSOR l_tour IS 
	SELECT 
		tour_annee 
	FROM 
		tour 
	ORDER BY 1;
BEGIN
	htp.FORmopen(curl=>'maj_selected_tour', cmethod=>'POST');
	htp.print('Tour:');
	htp.FORmSELECTopen('v_tour');
	FOR crec in l_tour LOOP
    IF (crec.tour_annee=v_tour) THEN
      htp.FORmSELECToption(crec.tour_annee,crec.tour_annee);
    ELSE
      htp.FORmSELECToption(crec.tour_annee);
    END IF;
	END LOOP ;
	htp.FORmSELECTClose;
	htp.FORmhidden('prev_url',owa_util.get_procedure);
	htp.FORmsubmit(cvalue=>'OK');
	htp.FORmclose;

END UI_SELECT_TOUR;

/
