--------------------------------------------------------
--  DDL for Index PK_UTILISATEUR
--------------------------------------------------------

  CREATE UNIQUE INDEX "G11_FLIGHT"."PK_UTILISATEUR" ON "G11_FLIGHT"."UTILISATEUR" ("UTIL_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
  TABLESPACE "BD50_IND" ;
