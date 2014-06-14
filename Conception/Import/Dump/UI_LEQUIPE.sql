--------------------------------------------------------
--  DDL for Procedure UI_LEQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LEQUIPE" 
  (crit_nom varchar2 default '%') IS
	CURSOR cur_equi IS 
		SELECT 
			* 
		FROM 
			equipe 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND equipe_nom like UPPER('%'||crit_nom||'%')
		ORDER BY equipe_num;

	cpt number(3) :=0;
BEGIN
  UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('
		<div class="row">
			<div class="col">
				<h2>Equipes</h2>
			</div>
			<div class="col">');
			htp.print('<div class="w80 txtleft">');
				htp.FORmopen(curl=>'ui_lequipe', cmethod=>'POST');
				htp.print('Nom:');
				htp.FORmtext('crit_nom');
				htp.FORmsubmit(cvalue=>'OK');
				htp.FORmclose;
			htp.print('</div>');
		htp.print('</div>
		</div>
		<div class="row separation2"></div></br>');

	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Numéro',cattributes => 'class="col2"');
		htp.tableheader('Nom');
		htp.tableheader('Web');
		htp.tableheader('Pays');
		
		FOR recequi in cur_equi LOOP
			cpt:=cpt+1;
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
			htp.tableRowOpen;
			END IF;
			
			htp.tableData(recequi.equipe_num);
			htp.tableData(htf.anchor ('ui_detail_equipe?n_equipe=' || recequi.equipe_num,recequi.equipe_nom));
			htp.tableData(recequi.equipe_web);
			htp.tableData(recequi.equipe_pays);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	END LOOP;
  htp.tableClose;
  UI_MAIN_CLOSE;
  UI_FOOTER;
END;

/
