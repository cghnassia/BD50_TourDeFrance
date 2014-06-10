--------------------------------------------------------
--  Ref Constraints for Table VILLE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."VILLE" ADD CONSTRAINT "FK_VILLE_PAYS" FOREIGN KEY ("PAYS_NUM")
	  REFERENCES "G11_FLIGHT"."PAYS" ("PAYS_NUM") ENABLE;
