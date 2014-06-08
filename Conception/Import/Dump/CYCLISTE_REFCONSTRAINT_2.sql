--------------------------------------------------------
--  Ref Constraints for Table CYCLISTE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."CYCLISTE" ADD CONSTRAINT "FK_CYCLISTE_PAYS" FOREIGN KEY ("PAYS_NUM")
	  REFERENCES "G11_FLIGHT"."PAYS" ("PAYS_NUM") ENABLE;
