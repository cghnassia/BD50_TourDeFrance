--------------------------------------------------------
--  Fichier cr�� - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body DB_COURSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."DB_COURSE" AS 

 FUNCTION getAllEtape return db_param_commun.ref_cur IS
 cur_etape db_param_commun.ref_cur;
  BEGIN
   OPEN cur_etape for 
    select 
      * 
    from 
       etape
    where tour_annee = ui_utils.getSelectedTour
    order by etape_num;
  return cur_etape;
 END getAllEtape;
 
  FUNCTION getAllPdP (n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) return db_param_commun.ref_cur IS
 cur_pp db_param_commun.ref_cur;
  BEGIN
   OPEN cur_pp for 
    SELECT 
      * 
    FROM 
      point_passage 
    WHERE 
      tour_annee=ui_utils.getSelectedTour
    AND etape_num=n_etape  
    ORDER BY pt_pass_num;
  return cur_pp;
 END getAllPdP;
 
 FUNCTION getEtape(n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) return etape%rowtype IS
 v_etape etape%rowtype;
 BEGIN
 select 
   * into v_etape
  from 
    etape
  where
    etape_num = n_etape
    AND tour_annee=ui_utils.getSelectedTour;
  return v_etape;
  END getEtape;
  
FUNCTION getEtapeCount(n_tour_annee tour.tour_annee%TYPE) return NUMBER IS
  v_num NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_num FROM etape WHERE tour_annee = n_tour_annee;
  return v_num;
 END getEtapeCount;

FUNCTION getPointPassageCount(n_tour_annee tour.tour_annee%TYPE, n_etape_num etape.etape_num%TYPE) return NUMBER IS
  v_num NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_num FROM point_passage WHERE tour_annee = n_tour_annee AND etape_num = n_etape_num;
  return v_num;
 END getPointPassageCount;

END DB_COURSE;
/
