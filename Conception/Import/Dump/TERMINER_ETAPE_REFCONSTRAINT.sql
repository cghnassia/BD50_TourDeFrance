--------------------------------------------------------
--  Ref Constraints for Table TERMINER_ETAPE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."TERMINER_ETAPE" ADD CONSTRAINT "FK_TERMINER_ETAPE_ETAPE" FOREIGN KEY ("TOUR_ANNEE", "ETAPE_NUM")
	  REFERENCES "G11_FLIGHT"."ETAPE" ("TOUR_ANNEE", "ETAPE_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."TERMINER_ETAPE" ADD CONSTRAINT "FK_TERMINER_ETAPE_PARTICIPANT" FOREIGN KEY ("TOUR_ANNEE", "PART_NUM")
	  REFERENCES "G11_FLIGHT"."PARTICIPANT" ("TOUR_ANNEE", "PART_NUM") ENABLE;
