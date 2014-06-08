--------------------------------------------------------
--  Ref Constraints for Table PARTICIPANT
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."PARTICIPANT" ADD CONSTRAINT "FK_PARTICIPANT_CYCLISTE" FOREIGN KEY ("CYCLISTE_NUM")
	  REFERENCES "G11_FLIGHT"."CYCLISTE" ("CYCLISTE_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."PARTICIPANT" ADD CONSTRAINT "FK_PARTICIPANT_EQUIPE" FOREIGN KEY ("TOUR_ANNEE", "EQUIPE_NUM")
	  REFERENCES "G11_FLIGHT"."EQUIPE" ("TOUR_ANNEE", "EQUIPE_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."PARTICIPANT" ADD CONSTRAINT "FK_PARTICIPANT_POINT_PASSAGE" FOREIGN KEY ("TOUR_ANNEE", "ETAPE_NUM", "PT_PASS_NUM")
	  REFERENCES "G11_FLIGHT"."POINT_PASSAGE" ("TOUR_ANNEE", "ETAPE_NUM", "PT_PASS_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."PARTICIPANT" ADD CONSTRAINT "FK_PARTICIPANT_TOUR" FOREIGN KEY ("TOUR_ANNEE")
	  REFERENCES "G11_FLIGHT"."TOUR" ("TOUR_ANNEE") ENABLE;
