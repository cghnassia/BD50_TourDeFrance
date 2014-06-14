--------------------------------------------------------
--  DDL for Procedure UI_SELECT_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_SELECT_ETAPE" 
(n_etape varchar2 default GETSELECTEDETAPE) IS
	CURSOR letape IS 
		SELECT 
			* 
		FROM 
			etape 
		WHERE 
			tour_annee = GETSELECTEDTOUR 
		ORDER BY 1;
BEGIN
	htp.FORmopen(curl=>'maj_selected_etape', cmethod=>'GET');
	htp.print('Etape:');
	htp.FORmSELECTopen('n_etape');
	FOR crec in letape LOOP
		IF (crec.etape_num=n_etape) THEN
			htp.FORmSELECToption(crec.etape_num,crec.etape_num);
		ELSE
			htp.FORmSELECToption(crec.etape_num);
		END IF;
	END LOOP ;
	htp.FORmSELECTClose;
	htp.FORmhidden('prev_url',owa_util.get_procedure);
	htp.FORmsubmit(cvalue=>'OK');
	htp.FORmclose;
END UI_SELECT_ETAPE;

/
