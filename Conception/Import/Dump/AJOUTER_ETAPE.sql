--------------------------------------------------------
--  DDL for Procedure AJOUTER_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."AJOUTER_ETAPE" (
	 tour_annee tour.tour_annee%TYPE
	,etape_nom etape.etape_nom%TYPE
    ,etape_date etape.etape_date%TYPE
    ,tetape_lib etape.tetape_lib%TYPE
)
IS
	v_etape_num NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_etape_num FROM etape WHERE tour_annee = tour_annee group by tour_annee;

	INSERT INTO etape (tour_annee, etape_num, etape_nom, etape_date, tetape_lib)
	VALUES (tour_annee, v_etape_num + 1, etape_nom, etape_date, tetape_lib);
	
	UPDATE tour SET 
		 tour_dated = (SELECT MIN(etape_date) FROM etape WHERE tour_annee = tour_annee)
		,tour_datef = (SELECT MAX(etape_date) FROM etape WHERE tour_annee = tour_annee)
	WHERE tour_annee = tour_annee;
EXCEPTION
		WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ajouter_etape;

/
