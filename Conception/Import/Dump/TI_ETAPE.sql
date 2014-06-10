--------------------------------------------------------
--  DDL for Trigger TI_ETAPE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_ETAPE" 
BEFORE INSERT ON etape
FOR EACH ROW
BEGIN
	SELECT COUNT(*) INTO :new.etape_num FROM etape WHERE tour_annee = :new.tour_annee;
	:new.etape_num := :new.etape_num + 1;
	
	IF :new.ville_num_debuter IS NOT NULL THEN
		SELECT ville_nom INTO :new.ville_nom_debuter FROM ville WHERE ville_num = :new.ville_num_debuter;
	END IF;
	
	IF :new.ville_num_finir IS NOT NULL THEN
		SELECT ville_nom INTO :new.ville_nom_finir FROM ville WHERE ville_num = :new.ville_num_finir;
	END IF;
	
	IF :new.etape_num = 1 THEN
		UPDATE tour SET tour_dated = :new.etape_date WHERE tour_annee = :new.tour_annee;
	END IF;
	
	UPDATE tour SET tour_datef = :new.etape_date WHERE tour_annee = :new.tour_annee;
EXCEPTION
		WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ajouter_etape;
/
ALTER TRIGGER "G11_FLIGHT"."TI_ETAPE" ENABLE;
