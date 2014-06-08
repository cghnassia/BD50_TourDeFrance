--------------------------------------------------------
--  DDL for Trigger TI_TERMINER_ETAPE_EQUIPE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_TERMINER_ETAPE_EQUIPE" 
BEFORE INSERT ON terminer_etape_equipe
FOR EACH ROW
DECLARE
	r_equipe equipe%ROWTYPE;

BEGIN
	SELECT * INTO r_equipe FROM equipe WHERE tour_annee = :new.tour_annee AND equipe_num = :new.equipe_num;
	
	:new.equipe_nom := r_equipe.equipe_nom;
	:new.equipe_pays := r_equipe.equipe_pays;
	:new.gene_equi_tps := r_equipe.equipe_tps_gene + :new.etape_equi_tps;
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('Erreur');
END terminer_etape_equipe;
/
ALTER TRIGGER "G11_FLIGHT"."TI_TERMINER_ETAPE_EQUIPE" ENABLE;
