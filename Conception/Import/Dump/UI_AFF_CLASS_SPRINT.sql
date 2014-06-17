--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_SPRINT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_SPRINT" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			terminer_etape 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND gene_class_sprint <= nb_ligne 
		AND gene_class_sprint!=0 
		AND etape_num=n_etape 
		ORDER BY gene_class_sprint;
		
	
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col4"');
		htp.tableheader('Points');
		
		FOR recpart in cur_part LOOP
			htp.tableRowOpen;
				htp.tableData(recpart.gene_class_sprint);
				htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
				htp.tableData(recpart.part_num);
				htp.tableData(recpart.equipe_nom);
				htp.tableData(recpart.gene_pts_sprint);
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
		END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
END UI_AFF_CLASS_SPRINT;

/