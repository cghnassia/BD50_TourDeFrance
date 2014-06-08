--------------------------------------------------------
--  DDL for Procedure INSCIRE_EQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."INSCIRE_EQUIPE" (
	 tour_annee equipe.tour_annee%TYPE
	,equipe_nom equipe.equipe_nom%TYPE
	,equipe_web equipe.equipe_web%TYPE
	,equipe_desc equipe.equipe_desc%TYPE
	,spon_nom equipe.spon_nom%TYPE
	,spon_acro equipe.spon_acro%TYPE
	,pays_num equipe.part_num%TYPE
)
IS
	r_pays pays%ROWTYPE;
	v_equipe_num NUMBER;
BEGIN
	 SELECT * INTO r_pays FROM pays WHERE pays_num = pays_num;
	 SELECT COUNT(*) INTO v_equipe_num WHERE tour_annee = tour_annee GROUP BY tour_annee;
	 INSERT INTO equipe (tour_annee, equipe_num, equipe_nom, equipe_web, equipe_desc, equipe_pays, spon_nom, spon_acro, pays_num)
	 VALUES (tour_annee, v_equipe_num + 1, equipe_nom, equipe_web, equipe_desc, r_pays.pays_nom, spon_nom, spon_acro, pays_num);
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END inscrire_equipe;

/
