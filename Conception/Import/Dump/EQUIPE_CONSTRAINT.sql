--------------------------------------------------------
--  Constraints for Table EQUIPE
--------------------------------------------------------

  ALTER TABLE "G11_FLIGHT"."EQUIPE" ADD CONSTRAINT "PK_EQUIPE" PRIMARY KEY ("TOUR_ANNEE", "EQUIPE_NUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_IND"  ENABLE;
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("TOUR_ANNEE" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("EQUIPE_NUM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("EQUIPE_NOM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("EQUIPE_WEB" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("EQUIPE_DESC" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("EQUIPE_PAYS" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("SPON_NOM" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("SPON_ACRO" NOT NULL ENABLE);
 
  ALTER TABLE "G11_FLIGHT"."EQUIPE" MODIFY ("PAYS_NUM" NOT NULL ENABLE);
