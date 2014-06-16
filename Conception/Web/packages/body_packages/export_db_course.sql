--------------------------------------------------------
--  Fichier créé - lundi-juin-16-2014   
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
END DB_COURSE;

/
