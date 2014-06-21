--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
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

 FUNCTION getPartAll(n_tour_annee tour.tour_annee%TYPE) return db_param_commun.ref_cur IS
  c_participant db_param_commun.ref_cur;
BEGIN
  OPEN c_participant FOR 'SELECT * FROM participant WHERE tour_annee = ' || n_tour_annee || ' ORDER BY part_num ASC';
  RETURN c_participant;
END getPartAll;

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
  
     FUNCTION getDirSportif(n_equipe varchar2) return db_param_commun.ref_cur IS
  cur_dir db_param_commun.ref_cur;
  BEGIN
  OPEN cur_dir for
    SELECT
      ds.dirs_nom,ds.dirs_prenom
    FROM
      directeur_sportif ds inner join diriger di
        on ds.dirs_num=di.dirs_num
    WHERE
      di.tour_annee=ui_utils.getSelectedTour
    AND di.equipe_num = n_equipe
    ORDER BY ds.dirs_nom;
  return cur_dir;
  exception when others then
  return null;
  END getDirSportif;
  
  FUNCTION getNbDirSportif(n_equipe varchar2) return number IS
  n_dirs number(1);
  BEGIN
    SELECT
      count(ds.dirs_num) into n_dirs
    FROM
      directeur_sportif ds inner join diriger di
        on ds.dirs_num=di.dirs_num
    WHERE
      di.tour_annee=ui_utils.getSelectedTour
    AND di.equipe_num = n_equipe;
  return n_dirs;
  exception when others then
  return 0;
  END getNbDirSportif;

END DB_INSCRIPTION;

/
