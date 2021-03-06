--------------------------------------------------------
--  Ref Constraints for Table PORTER
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."PORTER" ADD CONSTRAINT "FK_PORTER_ETAPE" FOREIGN KEY ("TOUR_ANNEE", "ETAPE_NUM")
	  REFERENCES "G11_FLIGHT"."ETAPE" ("TOUR_ANNEE", "ETAPE_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."PORTER" ADD CONSTRAINT "FK_PORTER_PARTICIPANT" FOREIGN KEY ("TOUR_ANNEE", "PART_NUM")
	  REFERENCES "G11_FLIGHT"."PARTICIPANT" ("TOUR_ANNEE", "PART_NUM") ENABLE;
