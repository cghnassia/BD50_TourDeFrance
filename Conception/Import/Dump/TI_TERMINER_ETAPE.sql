--------------------------------------------------------
--  DDL for Trigger TI_TERMINER_ETAPE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_TERMINER_ETAPE" 
BEFORE INSERT ON terminer_etape
FOR EACH ROW
DECLARE
	r_participant participant%ROWTYPE;

BEGIN
	SELECT * INTO r_participant FROM participant WHERE tour_annee = :new.tour_annee AND part_num = :new.part_num;
  
	:new.cycliste_nom := r_participant.cycliste_nom;
	:new.cycliste_prenom := r_participant.cycliste_prenom;
	:new.cycliste_pays := r_participant.cycliste_pays;
	:new.cycliste_daten := r_participant.cycliste_daten;
	:new.equipe_nom := r_participant.equipe_nom;
	:new.gene_tps := r_participant.part_tps_gene;
	:new.gene_pts_mont := r_participant.part_pts_mont;
	:new.gene_pts_sprint := r_participant.part_pts_sprint;
  
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('Erreur');
END terminer_etape;
/
ALTER TRIGGER "G11_FLIGHT"."TI_TERMINER_ETAPE" ENABLE;
