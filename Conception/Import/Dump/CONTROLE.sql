--------------------------------------------------------
--  DDL for Table CONTROLE
--------------------------------------------------------

  CREATE TABLE "G11_FLIGHT"."CONTROLE" 
   (	"CONTR_NUM" NUMBER(5,0), 
	"CONTR_DATE" DATE, 
	"CONTR_RESULT" VARCHAR2(50 BYTE), 
	"TOUR_ANNEE" NUMBER(4,0), 
	"PART_NUM" NUMBER(3,0)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "BD50_DATA" ;
