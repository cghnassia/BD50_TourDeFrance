--------------------------------------------------------
--  DDL for Index PK_BAREME
--------------------------------------------------------

  CREATE UNIQUE INDEX "G11_FLIGHT"."PK_BAREME" ON "G11_FLIGHT"."BAREME" ("CAT_NUM", "BAREME_PLACE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
  TABLESPACE "BD50_IND" ;
