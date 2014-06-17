--------------------------------------------------------
--  DDL for Procedure UI_AFF_SELECT_POINT_PASSAGES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_SELECT_POINT_PASSAGES" (
	v_etape_num etape.etape_num%TYPE default 0,
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 0
)
IS
CURSOR c_point_passage IS 
SELECT * FROM point_passage WHERE tour_annee=getselectedtour AND etape_num=v_etape_num ORDER BY pt_pass_num ASC;
r_point_passage c_point_passage%ROWTYPE;
BEGIN
	htp.print('<div><span>Point de passage</span><select name="select_passage" onchange="document.getElementById(''form_passer'').submit()">');
	OPEN c_point_passage;
	LOOP
		FETCH c_point_passage INTO r_point_passage;
		EXIT WHEN c_point_passage%NOTFOUND;
    
    htp.print('"<option value="' || r_point_passage.pt_pass_num || '"');
    
    IF r_point_passage.pt_pass_num = v_pt_pass_num THEN
      htp.print(' selected="selected"');
    END IF;
    
    htp.print('> Numéro ' || r_point_passage.pt_pass_num || ' (' || r_point_passage.pt_pass_nom ||')</option>');
    
	END LOOP;
	CLOSE c_point_passage;
	htp.print('</select></div>');
END UI_AFF_SELECT_POINT_PASSAGES;

/
