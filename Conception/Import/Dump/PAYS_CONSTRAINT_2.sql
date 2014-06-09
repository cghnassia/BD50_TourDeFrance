--------------------------------------------------------
--  Constraints for Table PAYS
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."PAYS" ADD CONSTRAINT "PK_PAYS" PRIMARY KEY ("PAYS_NUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_IND"  ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."PAYS" MODIFY ("PAYS_NUM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."PAYS" MODIFY ("PAYS_NOM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."PAYS" MODIFY ("PAYS_ACRO" NOT NULL ENABLE);