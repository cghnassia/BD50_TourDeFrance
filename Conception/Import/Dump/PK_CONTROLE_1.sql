--------------------------------------------------------
--  DDL for Index PK_CONTROLE
--------------------------------------------------------

  CREATE UNIQUE INDEX "G11_FLIGHT"."PK_CONTROLE" ON "G11_FLIGHT"."CONTROLE" ("CONTR_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
  TABLESPACE "BD50_IND" ;
