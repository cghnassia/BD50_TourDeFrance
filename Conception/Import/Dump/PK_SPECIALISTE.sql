--------------------------------------------------------
--  DDL for Index PK_SPECIALISTE
--------------------------------------------------------

  CREATE UNIQUE INDEX "G11_FLIGHT"."PK_SPECIALISTE" ON "G11_FLIGHT"."SPECIALISTE" ("SPE_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
  TABLESPACE "BD50_IND" ;
