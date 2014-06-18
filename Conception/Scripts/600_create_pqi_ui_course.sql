--------------------------------------------------------
--  DDL for Package UI_COURSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_COURSE" AS 

  PROCEDURE UI_LETAPE;
  
  PROCEDURE UI_DETAIL_ETAPE (n_etape etape.etape_num%TYPE default ui_utils.getselectedetape);
END UI_COURSE;

/