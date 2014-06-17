--------------------------------------------------------
--  DDL for Package DB_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_COMMUN" AS 

  FUNCTION getAllTour return db_param_commun.ref_cur;
  
  
  FUNCTION getLastTour return tour.tour_annee%type;
  
  FUNCTION getLastEtape return etape.etape_num%type;
  
  FUNCTION getTour(a_tour varchar2) return tour%rowtype;
  
  FUNCTION getAcroPays(n_part participant.part_num%TYPE ) RETURN pays.pays_acro%TYPE;
END DB_COMMUN;

/
