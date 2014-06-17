--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_ETAPE" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			terminer_etape 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND etape_class <= nb_ligne 
		AND etape_num=n_etape 
		AND etape_class != 0 
		ORDER BY etape_class;
		
	cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
			FOR recpart in cur_part LOOP
				cpt:=cpt+1;
        IF(mod(cpt,2)=0) THEN
				  htp.tableRowOpen(cattributes => 'class="rowP"');
			  ELSE
			   htp.tableRowOpen;
			  END IF;
				htp.tableData(recpart.etape_class);
				htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
				htp.tableData(recpart.part_num);
				htp.tableData(recpart.equipe_nom);
        
        htp.tableData(formated_time(recpart.etape_tps));
      
        IF recpart.etape_tps_ecart != 0 THEN
          htp.tableData('+ ' || formated_time(recpart.etape_tps_ecart));
        ELSE
          htp.tableData('');
        END IF;
      
				htp.tableRowClose;
			END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
END UI_AFF_CLASS_ETAPE;

/