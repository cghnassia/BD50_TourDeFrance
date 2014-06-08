--------------------------------------------------------
--  DDL for Table SPECIALISTE
--------------------------------------------------------

  CREATE TABLE "G11_FLIGHT"."SPECIALISTE" 
   (	"SPE_NUM" NUMBER(1,0), 
	"SPE_NOM" VARCHAR2(40 BYTE), 
	"SPE_PRENOM" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "BD50_DATA" ;
