--------------------------------------------------------
--  Ref Constraints for Table CONTROLE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."CONTROLE" ADD CONSTRAINT "FK_CONTROLE_PARTICIPANT" FOREIGN KEY ("TOUR_ANNEE", "PART_NUM")
	  REFERENCES "G11_FLIGHT"."PARTICIPANT" ("TOUR_ANNEE", "PART_NUM") ENABLE;
