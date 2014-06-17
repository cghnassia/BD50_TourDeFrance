--------------------------------------------------------
--  DDL for Package DB_INSCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_INSCRIPTION" AS 

  FUNCTION getPart(n_part varchar2) return participant%rowtype;
  
  FUNCTION getEquipe(n_equipe varchar2) return equipe%rowtype;

  FUNCTION getCycliste(n_cycliste varchar2) return cycliste%rowtype;
  
  FUNCTION getPartCrit(crit_nom varchar2 default '%',crit_pnom varchar2 default '%') return db_param_commun.ref_cur;
  
  FUNCTION getEquipeCrit(crit_nom varchar2 default '%') return db_param_commun.ref_cur;
  

END DB_INSCRIPTION;

/
