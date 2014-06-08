--------------------------------------------------------
--  DDL for Trigger TI_EQUIPE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_EQUIPE" 
BEFORE INSERT ON equipe
FOR EACH ROW
BEGIN
	 SELECT pays_nom INTO :new.equipe_pays FROM pays WHERE pays_num = :new.pays_num;
	 SELECT COUNT(*) INTO :new.equipe_num FROM EQUIPE WHERE tour_annee = :new.tour_annee;
	 
	:new.equipe_num := :new.equipe_num + 1;
	:new.equipe_tps_gene := 0;
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_equipe;
/
ALTER TRIGGER "G11_FLIGHT"."TI_EQUIPE" ENABLE;
