--------------------------------------------------------
--  DDL for Package DB_COURSE
--------------------------------------------------------

CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_COURSE" AS 

 FUNCTION getEtapeCount(n_tour_annee tour.tour_annee%TYPE) RETURN NUMBER;

 FUNCTION getPointPassageCount(n_tour_annee tour.tour_annee%TYPE, n_etape_num etape.etape_num%TYPE) RETURN NUMBER;

 FUNCTION getAllEtape return db_param_commun.ref_cur;
 
 FUNCTION getEtape(n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) return etape%rowtype;
 
 FUNCTION getAllPdP (n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) return db_param_commun.ref_cur;
 
END DB_COURSE;

/