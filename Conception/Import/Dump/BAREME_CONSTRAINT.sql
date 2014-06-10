--------------------------------------------------------
--  Constraints for Table BAREME
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."BAREME" ADD CONSTRAINT "PK_BAREME" PRIMARY KEY ("CAT_NUM", "BAREME_PLACE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_IND"  ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."BAREME" MODIFY ("CAT_NUM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."BAREME" MODIFY ("BAREME_PLACE" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."BAREME" MODIFY ("BAREME_PTS" NOT NULL ENABLE);
