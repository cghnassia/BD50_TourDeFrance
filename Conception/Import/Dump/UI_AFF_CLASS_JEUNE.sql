--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_JEUNE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_JEUNE" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			*
		FROM 
			(SELECT * FROM terminer_etape ORDER BY gene_class asc)
		WHERE 
			tour_annee=GETSELECTEDTOUR
		AND (GETSELECTEDTOUR-TO_CHAR(cycliste_daten,'YYYY'))<26
		AND etape_num=n_etape
		AND rownum <= nb_ligne;
	
	rang number(3) := 1;
	tps_first participant.part_tps_gene%TYPE := 0;
	
BEGIN

	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col4"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
		
		FOR recpart in cur_part LOOP
			if (rang=1) then
      tps_first:=recpart.gene_tps;
    end if;
      htp.tableRowOpen;
				htp.tableData(rang);
				htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
				htp.tableData(recpart.part_num);
				htp.tableData(recpart.equipe_nom);
				htp.tableData(formated_time(recpart.gene_tps));
        
				IF recpart.gene_tps_ecart != 0 THEN
        htp.tableData('+ ' || formated_time(recpart.gene_tps-tps_first));
      ELSE
        htp.tableData('');
      END IF;
        
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
			
			rang:=rang+1;
		END LOOP;
	htp.tableClose;
  	EXCEPTION
	when others THEN
		null;
END UI_AFF_CLASS_JEUNE;

/
