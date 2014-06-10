--------------------------------------------------------
--  Ref Constraints for Table BAREME
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."BAREME" ADD CONSTRAINT "FK_BAREME_CATEGORIE" FOREIGN KEY ("CAT_NUM")
	  REFERENCES "G11_FLIGHT"."CATEGORIE" ("CAT_NUM") ENABLE;
