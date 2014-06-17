--------------------------------------------------------
--  DDL for Procedure UI_EXECFORM_PASSER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_EXECFORM_PASSER" (
	select_etape etape.etape_num%TYPE default 0,
	select_passage point_passage.pt_pass_num%TYPE default 0,
	select_participant participant.part_num%TYPE default 0,
  text_temps VARCHAR2 DEFAULT '',
  button_submit VARCHAR2 DEFAULT NULL
) IS
v_code NUMBER := 0;
v_message VARCHAR2(255) := '';
BEGIN
  
  IF button_submit IS NOT NULL THEN
    IF select_etape = 0 THEN
      v_message  := v_message + '<li>Choisissez une étape</li>';
      v_code := -1;
    END IF;
    
    IF select_passage = 0 THEN
      v_message  := v_message + '<li>Choisissez un point de passage</li>';
      v_code := -1;
    END IF;
    
    IF to_number(text_temps) < 0 THEN 
       v_message  := v_message + '<li>Saisissez un temps valide</li>';
       v_code := -1;
    END IF;
   
   IF v_code = 0 THEN
      BEGIN
        INSERT INTO passer(tour_annee, etape_num, pt_pass_num, part_num, pass_tps) VALUES (getSelectedTour, select_etape, select_passage, select_participant, text_temps);
        v_message := 'Les données ont été insérées avec succès';
        v_code := 1;
      EXCEPTION
        WHEN OTHERS THEN 
          v_message := 'Erreur lors de l''insertion de données; vérifier la cohérence';
          v_code := -1;
      END;
    END IF;
  END IF;
  ui_form_passer(select_etape, select_passage, select_participant, text_temps, v_code, v_message);
EXCEPTION
  WHEN OTHERS THEN htp.print(sqlerrm);
END UI_EXECFORM_PASSER;

/
