--------------------------------------------------------
--  DDL for Package UI_UTILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_UTILS" AS 

  --Fonction de récupération d'une valeur de cookie
  FUNCTION getCookieValue(c_name varchar2) RETURN varchar2;
  
  --Test si un cookie existe
  FUNCTION existCookie(c_name varchar2) RETURN boolean;
  
  --Creation de cookie
  PROCEDURE createCookie (c_name varchar2,c_value varchar2);
  
  --Suppression de cookie
  PROCEDURE removeCookie(c_name varchar2);
  
  
  --Retourne le Tour sélectionné
  FUNCTION getSelectedTour  RETURN varchar2;

  --Retourne l'étape selectionnée
  FUNCTION getSelectedEtape  RETURN varchar2;
  
    PROCEDURE COLOR_ROW_P (cpt number default 0);
  
  PROCEDURE MAJ_SELECTED_TOUR (v_tour varchar2,prev_url varchar2);
  
  PROCEDURE MAJ_SELECTED_ETAPE (n_etape varchar2,prev_url varchar2);
  
  FUNCTION FORMATED_TIME (time_number NUMBER) RETURN VARCHAR2;

END UI_UTILS;

/
