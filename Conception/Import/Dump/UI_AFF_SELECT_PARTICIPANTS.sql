--------------------------------------------------------
--  DDL for Procedure UI_AFF_SELECT_PARTICIPANTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_SELECT_PARTICIPANTS" (
	v_etape_num etape.etape_num%TYPE default 0,
	v_pt_pass_num point_passage.pt_pass_num%TYPE default 0,
  v_part_num participant.part_num%TYPE default 0
)
IS
  c_participant SYS_REFCURSOR;
  r_participant participant%ROWTYPE;
  v_temps NUMBER := 0;
  v_part_num_selected participant.part_num%TYPE := 0;
BEGIN
	htp.print('<div><span>Participant</span><select name="select_participant" onchange="document.getElementById(''form_passer'').submit()">');
  IF v_pt_pass_num > 1 THEN
    OPEN c_participant FOR '
      SELECT pr.* FROM participant pr INNER JOIN PASSER ps
      ON pr.tour_annee = ps.tour_annee AND pr.part_num = ps.part_num
      WHERE pr.tour_annee= ' || getselectedtour || ' AND ps.etape_num = ' || v_etape_num || '
      AND ps.pt_pass_num = ' || (v_pt_pass_num - 1) || '
      AND pr.etape_num IS NULL
      AND pr.part_num NOT IN (
        SELECT part_num FROM passer WHERE tour_annee = ' || getselectedtour || ' AND etape_num = ' || v_etape_num || ' AND pt_pass_num =' || v_pt_pass_num || ')
      ORDER BY pr.part_num ASC';
   ELSIF v_etape_num > 1 THEN
    OPEN c_participant FOR 
      'SELECT pr.* FROM participant pr INNER JOIN PASSER ps
      ON pr.tour_annee = ps.tour_annee AND pr.part_num = ps.part_num
      WHERE ps.tour_annee= ' || getselectedtour || ' AND ps.etape_num= ' || (v_etape_num - 1) || '
      AND ps.pt_pass_num = ( 
        SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = ' || getselectedtour || ' AND etape_num = ' || (v_etape_num - 1) || '
      )
      AND pr.etape_num IS NULL
      AND pr.part_num NOT IN (
        SELECT part_num FROM passer WHERE tour_annee = ' || getselectedtour || ' AND etape_num = ' || v_etape_num || ' AND pt_pass_num =' || v_pt_pass_num || ')
      ORDER BY pr.part_num ASC';
  ELSE
    OPEN c_participant FOR 
      'SELECT * FROM participant WHERE tour_annee= ' || getselectedtour || ' AND etape_num IS NULL 
      AND pr.part_num NOT IN (
        SELECT part_num FROM passer WHERE tour_annee = ' || getselectedtour || ' AND etape_num = ' || v_etape_num || ' AND pt_pass_num =' || v_pt_pass_num || ')
      ORDER BY pr.part_num ASC';
  END IF;
  
	LOOP
		FETCH c_participant INTO r_participant;
		EXIT WHEN c_participant%NOTFOUND;
    
      htp.print('"<option value="' || r_participant.part_num || '"');
      
      IF v_part_num_selected = 0 THEN
        v_part_num_selected := r_participant.part_num;
      ELSIF v_part_num = r_participant.part_num THEN
        htp.print(' selected="selected"');
        v_part_num_selected := v_part_num;
      END IF;
      
      htp.print('> Dossard ' || r_participant.part_num || ' (' || r_participant.cycliste_prenom || ' ' || r_participant.cycliste_nom || ')</option>');
      
      END LOOP;
    CLOSE c_participant;
	htp.print('</select></div>');
  
  IF v_pt_pass_num > 1 AND v_part_num > 0 THEN
    BEGIN
      SELECT pass_tps INTO v_temps FROM passer WHERE tour_annee= getselectedtour AND etape_num = v_etape_num AND pt_pass_num = (v_pt_pass_num - 1) AND part_num = v_part_num_selected;
    EXCEPTION
      WHEN OTHERS THEN htp.print(sqlerrm);
    END;
  END IF;
  htp.print('<div><span>Temps</span><input type="text" name="text_temps" value="' || v_temps || '" /></div>');
  
END UI_AFF_SELECT_PARTICIPANTS;

/
