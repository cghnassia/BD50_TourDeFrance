--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_EQUI
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_EQUI" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1) IS
	CURSOR cur_equi IS 
		SELECT 
			* 
		FROM 
			terminer_etape_equipe 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND gene_equi_class < nb_ligne 
		AND etape_num=n_etape 
		AND gene_equi_class!=0  
		ORDER BY gene_equi_class;
	
	first_tps equipe.equipe_tps_gene%TYPE;
BEGIN
	SELECT 
		gene_equi_tps INTO first_tps 
	FROM 
		terminer_etape_equipe 
	WHERE tour_annee=GETSELECTEDTOUR 
	AND etape_num=n_etape 
	AND gene_equi_class=1;
	
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
			FOR recequi in cur_equi LOOP
				htp.tableRowOpen;
					htp.tableData(recequi.gene_equi_class);
					htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recequi.equipe_num,recequi.equipe_nom));
					htp.tableData(formated_time(recequi.gene_equi_tps));
          
					IF recequi.gene_equi_tps-first_tps != 0 THEN
           htp.tableData('+ ' || formated_time(recequi.gene_equi_tps-first_tps));
          ELSE
           htp.tableData('');
         END IF;
         
				htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
			END LOOP;
	htp.tableClose;
    
	EXCEPTION
		when others THEN
			null;
END UI_AFF_CLASS_EQUI;

/
