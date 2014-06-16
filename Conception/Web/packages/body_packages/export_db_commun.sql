--------------------------------------------------------
--  Fichier créé - lundi-juin-16-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body DB_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."DB_COMMUN" AS 

  FUNCTION getAllTour return db_param_commun.ref_cur IS
   cur_tour db_param_commun.ref_cur;
  BEGIN
   OPEN cur_tour for 
    select 
      * 
    from 
       tour
    order by tour_annee;
    return cur_tour;
  END getAllTour;
  
  
  
  FUNCTION getLastTour return tour.tour_annee%type IS
   a_tour tour.tour_annee%type;
   BEGIN
    SELECT max(tour_annee) into a_tour from tour;
    return a_tour;
  END getLastTour;
  
  FUNCTION getLastEtape RETURN etape.etape_num%TYPE IS
   n_etape etape.etape_num%TYPE;
   BEGIN
	  SELECT max(etape_num) INTO n_etape FROM terminer_etape WHERE tour_annee=ui_utils.getSelectedTour;
     return n_etape;
   END getLastEtape;
   
   
   FUNCTION getTour(a_tour varchar2) return tour%rowtype IS
   v_tour tour%rowtype;
   BEGIN
    select * into v_tour from tour where tour_annee = ui_utils.getSelectedTour;
    return v_tour;
  END getTour;
  
  FUNCTION getAcroPays (n_part participant.part_num%TYPE )
  RETURN pays.pays_acro%TYPE IS
   v_acro pays.pays_acro%TYPE;
  BEGIN
  
  SELECT DISTINCT 
		pays_acro INTO v_acro 
	FROM pays 
	INNER JOIN cycliste cy 
		ON pays.pays_num=cy.pays_num 
	INNER JOIN participant pa 
		ON cy.cycliste_num=pa.cycliste_num 
	WHERE pa.part_num=n_part 
	AND pa.tour_annee=ui_utils.getSelectedTour  ;
	return v_acro;
END getAcroPays;

END DB_COMMUN;

/
