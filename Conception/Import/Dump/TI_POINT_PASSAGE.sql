--------------------------------------------------------
--  DDL for Trigger TI_POINT_PASSAGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_POINT_PASSAGE" 
BEFORE INSERT ON point_passage
FOR EACH ROW
DECLARE
	inconsistency_km EXCEPTION;
	v_pt_pass_km_dep_previous point_passage.pt_pass_km_dep%TYPE;
BEGIN
	SELECT COUNT(*) INTO :new.pt_pass_num FROM point_passage WHERE tour_annee = :new.tour_annee and etape_num = :new.etape_num;
	:new.pt_pass_num := :new.pt_pass_num + 1;
	--Si ce n'est pas le premier point de passage, on vérifie que le kilométrage est cohérent
	IF:new.pt_pass_num > 1 THEN
		SELECT pt_pass_km_dep INTO v_pt_pass_km_dep_previous FROM point_passage 
		WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num - 1;
    
		IF v_pt_pass_km_dep_previous > :new.pt_pass_km_dep THEN
			RAISE inconsistency_km;
		END IF;
	ELSIF :new.pt_pass_km_dep > 0 THEN
		RAISE inconsistency_km;
	END IF;
	
	IF :new.ville_num is NOT NULL THEN
		SELECT ville_nom INTO :new.pt_pass_ville_nom FROM ville WHERE ville_num = :new.ville_num;
		IF :new.pt_pass_num = 1 THEN
			UPDATE etape SET 
				 ville_num_debuter = :new.ville_num
				,ville_nom_debuter = :new.pt_pass_ville_nom
			WHERE 
				tour_annee = :new.tour_annee
				AND etape_num = :new.etape_num;
		END IF;
		UPDATE etape SET
			 ville_num_finir = :new.ville_num
			,ville_nom_finir = :new.pt_pass_ville_nom
		WHERE
			tour_annee = :new.tour_annee
			AND etape_num = :new.etape_num;
	END IF;
	
	--Mettre à jour l'étape
	UPDATE etape SET
		etape_distance = :new.pt_pass_km_dep
	WHERE
		tour_annee = :new.tour_annee
		AND etape_num = :new.etape_num;
		
	--Update tous les points de passage de l'étape (km arrivée) (!!! A voir si ne pas mettre quand on 'valide l'étape!!!)
	UPDATE point_passage SET
		pt_pass_km_arr = :new.pt_pass_km_dep - pt_pass_km_dep
	WHERE
		tour_annee = :new.tour_annee
		AND etape_num = :new.etape_num;
		
	:new.pt_pass_km_arr := 0;
		
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Fatal erreur');
END ti_point_passage;
/
ALTER TRIGGER "G11_FLIGHT"."TI_POINT_PASSAGE" ENABLE;
