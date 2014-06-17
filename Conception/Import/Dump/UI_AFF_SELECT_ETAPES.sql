--------------------------------------------------------
--  DDL for Procedure UI_AFF_SELECT_ETAPES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_SELECT_ETAPES" (
  v_etape_num etape.etape_num%TYPE default 0
) IS
CURSOR c_etape IS 
SELECT * FROM etape WHERE tour_annee=getselectedtour ORDER BY etape_num ASC;
r_etape c_etape%ROWTYPE;
BEGIN
	htp.print('<div><span>Etape</span><select name="select_etape" onchange="document.getElementById(''form_passer'').submit()">');
	OPEN c_etape;
	LOOP
		FETCH c_etape INTO r_etape;
		EXIT WHEN c_etape%NOTFOUND;
    
    htp.print('"<option value="' || r_etape.etape_num || '"');
    
    IF v_etape_num = r_etape.etape_num THEN
      htp.print(' selected="selected"');
    END IF;
    
    htp.print('> Etape ' || r_etape.etape_num || ' (' || r_etape.etape_nom ||')</option>');
    
	END LOOP;
	CLOSE c_etape;
	htp.print('</select></div>');
END UI_AFF_SELECT_ETAPES;

/
