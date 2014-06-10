--------------------------------------------------------
--  DDL for Index I_FK_PORTER_PARTICIPANT
--------------------------------------------------------

  CREATE INDEX "G11_FLIGHT"."I_FK_PORTER_PARTICIPANT" ON "G11_FLIGHT"."PORTER" ("PART_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_IND" ;
