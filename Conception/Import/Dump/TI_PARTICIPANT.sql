--------------------------------------------------------
--  DDL for Trigger TI_PARTICIPANT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_PARTICIPANT" 
BEFORE INSERT ON participant
FOR EACH ROW
DECLARE
	r_cycliste cycliste%ROWTYPE;
BEGIN
	SELECT * INTO r_cycliste FROM cycliste WHERE cycliste_num = :new.cycliste_num;
	:new.cycliste_nom := r_cycliste.cycliste_nom;
	:new.cycliste_prenom := r_cycliste.cycliste_prenom;
	:new.cycliste_daten := r_cycliste.cycliste_daten;
	:new.part_tps_gene := 0;
	:new.part_pts_mont := 0;
	:new.part_pts_sprint := 0;
	
	SELECT equipe_nom INTO :new.equipe_nom FROM equipe WHERE tour_annee = :new.tour_annee AND equipe_num = :new.equipe_num;
	SELECT pays_nom INTO :new.cycliste_pays FROM pays WHERE pays_num = r_cycliste.pays_num;
	
	SELECT COUNT(*) INTO :new.part_num FROM participant WHERE tour_annee = :new.tour_annee AND equipe_num = :new.equipe_num;
	:new.part_num := (:new.equipe_num - 1) * 10 + :new.part_num + 1;

	EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_participant;
/
ALTER TRIGGER "G11_FLIGHT"."TI_PARTICIPANT" ENABLE;
