--------------------------------------------------------
--  Fichier créé - lundi-juin-16-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body DB_INSCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."DB_INSCRIPTION" AS 

  FUNCTION getPart(n_part varchar2) return participant%rowtype IS
  v_part participant%rowtype;
  BEGIN
   SELECT *
    INTO v_part
    FROM participant pa
    WHERE pa.part_num=n_part
    AND tour_annee   =ui_utils.getselectedtour;
    RETURN v_part;
 END getPart;
 
  FUNCTION getEquipe(n_equipe varchar2) return equipe%rowtype IS
  v_equipe equipe%rowtype;
  BEGIN
   SELECT *
    INTO v_equipe
    FROM equipe
    WHERE equipe_num=n_equipe
    AND tour_annee   =ui_utils.getselectedtour;
    RETURN v_equipe;
 END getEquipe;
 
 FUNCTION getCycliste(n_cycliste varchar2) return cycliste%rowtype IS
 v_cycliste cycliste%rowtype;
 BEGIN
    SELECT *
    INTO v_cycliste
    FROM cycliste
    WHERE cycliste_num=n_cycliste;
    RETURN v_cycliste;
  END getCycliste; 


  FUNCTION getPartCrit(crit_nom varchar2 default '%',crit_pnom varchar2 default '%') return db_param_commun.ref_cur IS
  cur_part db_param_commun.ref_cur;
  BEGIN
  OPEN cur_part for 
    select 
      * 
    from 
       participant
    where tour_annee = ui_utils.getSelectedTour
    AND UPPER(cycliste_nom) like UPPER('%'||crit_nom||'%')
		AND UPPER(cycliste_prenom) like UPPER('%'||crit_pnom||'%')
    order by part_num;
  return cur_part;
    exception when others then
  return null;
  END getPartCrit;
  
  FUNCTION getEquipeCrit(crit_nom varchar2 default '%') return db_param_commun.ref_cur IS
  cur_equipe db_param_commun.ref_cur;
  BEGIN
  OPEN cur_equipe for 
    SELECT 
			* 
		FROM 
			equipe 
		WHERE 
			tour_annee=ui_utils.getSelectedTour 
		AND UPPER(equipe_nom) like UPPER('%'||crit_nom||'%')
		ORDER BY equipe_num;
  return cur_equipe;
    exception when others then
  return null;
  END getEquipeCrit;

END DB_INSCRIPTION;

/
