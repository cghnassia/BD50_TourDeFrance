--------------------------------------------------------
--  DDL for Procedure UI_FORM_PASSER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_FORM_PASSER" (
v_etape_num etape.etape_num%TYPE default 1, 
v_pt_pass_num point_passage.pt_pass_num%TYPE default 0,
v_part_num participant.part_num%TYPE default 0,
v_temps VARCHAR2 default '',
v_code NUMBER default 0,
v_message VARCHAR2 default NULL
) IS
BEGIN
	UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
	
	htp.print('<h1>Ajout d'' un résultat pour le tour ' || getselectedtour || '</h1>');
  
  IF v_code = -1 THEN
    htp.print('Erreur : <ul>' || v_message || '</ul>');
  ELSIF v_code = 1 THEN
    htp.print(v_message);
  END IF;
	
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execform_passer', 'GET', cattributes => 'id="form_passer"');
	ui_aff_select_etapes(v_etape_num);
	ui_aff_select_point_passages(v_etape_num, v_pt_pass_num);
	ui_aff_select_participants(v_etape_num, v_pt_pass_num, v_part_num);		
	
  htp.print('	
	<div>
		<input name="button_submit" type="submit" value="Envoyer">
	</div>
	');
	htp.formClose;
	
	UI_MAIN_CLOSE;
	UI_FOOTER;
EXCEPTION 
	WHEN OTHERS THEN htp.print('Erreur');
END UI_FORM_PASSER;

/
