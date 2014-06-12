--------------------------------------------------------
--  Constraints for Table ETAPE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."ETAPE" ADD CONSTRAINT "CHK_TETAPE" CHECK (TETAPE_LIB='ligne' OR TETAPE_LIB='clmi' OR TETAPE_LIB='clme' OR TETAPE_LIB='prologue') ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" ADD CONSTRAINT "PK_ETAPE" PRIMARY KEY ("TOUR_ANNEE", "ETAPE_NUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_IND"  ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" MODIFY ("TOUR_ANNEE" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" MODIFY ("ETAPE_NUM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" MODIFY ("ETAPE_NOM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" MODIFY ("ETAPE_DATE" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" MODIFY ("ETAPE_DISTANCE" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."ETAPE" MODIFY ("TETAPE_LIB" NOT NULL ENABLE);