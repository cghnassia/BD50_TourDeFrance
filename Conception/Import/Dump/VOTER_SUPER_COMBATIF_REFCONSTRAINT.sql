--------------------------------------------------------
--  Ref Constraints for Table VOTER_SUPER_COMBATIF
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."VOTER_SUPER_COMBATIF" ADD CONSTRAINT "FK_VOTER_SUPER_COMBATIF_PARTIC" FOREIGN KEY ("TOUR_ANNEE", "PART_NUM")
	  REFERENCES "G11_FLIGHT"."PARTICIPANT" ("TOUR_ANNEE", "PART_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."VOTER_SUPER_COMBATIF" ADD CONSTRAINT "FK_VOTER_SUPER_COMBATIF_SPECIA" FOREIGN KEY ("SPE_NUM")
	  REFERENCES "G11_FLIGHT"."SPECIALISTE" ("SPE_NUM") ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."VOTER_SUPER_COMBATIF" ADD CONSTRAINT "FK_VOTER_SUPER_COMBATIF_TOUR" FOREIGN KEY ("TOUR_ANNEE")
	  REFERENCES "G11_FLIGHT"."TOUR" ("TOUR_ANNEE") ENABLE;
