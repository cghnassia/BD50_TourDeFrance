--------------------------------------------------------
--  DDL for Procedure AJOUTER_POINT_PASSAGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."AJOUTER_POINT_PASSAGE" (
	 tour_annee tour.tour_annee%TYPE
	,etape_num etape.etape_num%TYPE
	,pt_pass_nom point_passage.pt_pass_nom%TYPE
	,pt_pass_km_dep point_passage.pt_pass_km_dep%TYPE
	,pt_pass_alt point_passage.pt_pass_alt%TYPE
	,pt_pass_horaire point_passage.pt_pass_horaire%TYPE
	,ville_num ville.ville_num%TYPE DEFAULT NULL
	,cat_num categorie.cat_num%TYPE
  ,util_num utilisateur.util_num%TYPE DEFAULT NULL
)
IS
	v_pt_pass_num NUMBER;
	v_pt_pass_ville_nom ville.ville_nom%TYPE;
	v_etape_distance etape.etape_distance%TYPE;
BEGIN
	SELECT COUNT(*) INTO v_pt_pass_num FROM point_passage WHERE tour_annee = tour_annee and etape_num = etape_num;
	
	IF ville_num is NULL THEN
		v_pt_pass_ville_nom := NULL;
	ELSE
		SELECT ville_nom INTO v_pt_pass_ville_nom FROM ville WHERE ville_num = ville_num;
	END IF;
	
	INSERT INTO point_passage(tour_annee, etape_num, pt_pass_num, pt_pass_nom, pt_pass_ville_nom, pt_pass_km_dep, pt_pass_alt, pt_pass_horaire, ville_num, cat_num, util_num)
	VALUES (tour_annee, etape_num, v_pt_pass_num, pt_pass_nom, v_pt_pass_ville_nom, pt_pass_km_dep, pt_pass_alt, pt_pass_horaire, ville_num, cat_num, util_num);
	
	--Mettre à jour l'étape
	SELECT pt_pass_km_dep INTO v_etape_distance FROM point_passage WHERE tour_annee = tour_annee AND etape_num = etape_num AND pt_pass_num  = (SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = tour_annee AND etape_num = etape_num);
	
	UPDATE etape SET
		 etape_distance = v_etape_distance
		,ville_num_debuter = (SELECT ville_num FROM point_passage WHERE tour_annee = tour_annee AND etape_num = etape_num AND pt_pass_num = (SELECT MIN(pt_pass_num) FROM point_passage WHERE tour_annee = tour_annee AND etape_num = etape_num))
		,ville_num_finir = (SELECT ville_num FROM point_passage WHERE tour_annee = tour_annee AND etape_num = etape_num AND pt_pass_num = (SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = tour_annee AND etape_num = etape_num))
	WHERE
		tour_annee = tour_annee
		AND etape_num = etape_num;
		
	--Update tous les points de passage de l'étape (km arrivée) -- A voir si ne pas mettre quand on fait 'valider l'étape'
	UPDATE point_passage SET
		pt_pass_km_arr = v_etape_distance - pt_pass_km_dep
	WHERE
		tour_annee = tour_annee
		AND etape_num = etape_num;
		
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ajouter_point_passage;

/
