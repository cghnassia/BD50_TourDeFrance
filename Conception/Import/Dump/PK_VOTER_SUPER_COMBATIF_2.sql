--------------------------------------------------------
--  DDL for Index PK_VOTER_SUPER_COMBATIF
--------------------------------------------------------

  CREATE UNIQUE INDEX "G11_FLIGHT"."PK_VOTER_SUPER_COMBATIF" ON "G11_FLIGHT"."VOTER_SUPER_COMBATIF" ("TOUR_ANNEE", "SPE_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "BD50_DATA" ;
