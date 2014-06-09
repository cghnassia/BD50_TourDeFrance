--------------------------------------------------------
--  DDL for Index PK_CATEGORIE
--------------------------------------------------------

  CREATE UNIQUE INDEX "G11_FLIGHT"."PK_CATEGORIE" ON "G11_FLIGHT"."CATEGORIE" ("CAT_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_IND" ;