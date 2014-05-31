--------------------------------------------------------
--  Ref Constraints for Table EQUIPE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."EQUIPE" ADD CONSTRAINT "FK_EQUIPE_PAYS" FOREIGN KEY ("PAYS_NUM")
	  REFERENCES "G11_FLIGHT"."PAYS" ("PAYS_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" ADD CONSTRAINT "FK_EQUIPE_TOUR" FOREIGN KEY ("TOUR_ANNEE")
	  REFERENCES "G11_FLIGHT"."TOUR" ("TOUR_ANNEE") ENABLE;
