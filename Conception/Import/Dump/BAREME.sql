--------------------------------------------------------
--  DDL for Table BAREME
--------------------------------------------------------

  CREATE TABLE "G11_FLIGHT"."BAREME" 
   (	"CAT_NUM" NUMBER(2,0), 
	"BAREME_PLACE" NUMBER(3,0), 
	"BAREME_PTS" NUMBER(3,0)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "BD50_DATA" ;
