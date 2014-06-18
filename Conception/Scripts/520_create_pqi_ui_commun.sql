--------------------------------------------------------
--  DDL for Package UI_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_COMMUN" AS 

  PROCEDURE UI_HEAD;
  PROCEDURE UI_HEADER;
  
  PROCEDURE UI_MAIN_OPEN;
  PROCEDURE UI_MAIN_CLOSE;
  
  PROCEDURE UI_FOOTER;
  
  PROCEDURE UI_SELECT_TOUR (a_tour varchar2 default ui_utils.getSelectedTour);
  
  PROCEDURE UI_SELECT_ETAPE (n_etape varchar2 default ui_utils.getSelectedEtape);
  
  PROCEDURE UI_HOME;
  
  PROCEDURE UI_HOME_AFF_PORTEURS (v_maillot porter.maillot_couleur%TYPE, n_etape porter.etape_num%TYPE);
  
  
END UI_COMMUN;

/