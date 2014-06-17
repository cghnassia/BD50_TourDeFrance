--------------------------------------------------------
--  DDL for Package UI_INSCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_INSCRIPTION" AS 

  PROCEDURE UI_LPARTICIPANT (crit_nom varchar2 default '%',crit_pnom varchar2 default '%');

  PROCEDURE UI_LEQUIPE (crit_nom varchar2 default '%');
  
  PROCEDURE UI_DETAIL_EQUIPE (n_equipe number default 1);
  
  PROCEDURE UI_DETAIL_PARTICIPANT (n_part number default 1);
  
END UI_INSCRIPTION;

/
