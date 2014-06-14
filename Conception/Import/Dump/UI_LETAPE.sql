--------------------------------------------------------
--  DDL for Procedure UI_LETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LETAPE" IS
CURSOR cur_etape IS SELECT * FROM etape WHERE tour_annee=GETSELECTEDTOUR ORDER BY etape_num;
BEGIN

  UI_HEAD;
  UI_HEADER;
  htp.print('<div id="main" role="main" class="line pam">
  <h2>Parcours</h2>
  <div class="row separation2"></div></br>');
  htp.tableOpen(cattributes => 'class="normalTab"');
	htp.tableheader('Etape',cattributes => 'class="col2"');
  htp.tableheader('Type');
  htp.tableheader('Date');
  htp.tableheader('Départ > Arrivée',cattributes => 'class="col4"');
  htp.tableheader('Distance');
  htp.tableheader('Détail');
	FOR recetape in cur_etape LOOP
		IF(mod(recetape.etape_num,2)=0) THEN
      htp.tableRowOpen(cattributes => 'class="rowP"');
    ELSE
       htp.tableRowOpen;
    END IF;
		htp.tableData(recetape.etape_num);
    htp.tableData(recetape.etape_date);
    htp.tableData(recetape.tetape_lib);
    htp.tableData(recetape.ville_nom_debuter||' > '||recetape.ville_nom_finir);
     htp.tableData(recetape.etape_dIStance || ' km');
    htp.tableData(htf.anchor ('ui_detail_etape?n_etape=' || recetape.etape_num,'Détails'));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	END LOOP;
  htp.tableClose;
  htp.print('</div>');
  UI_FOOTER;
END UI_LETAPE;

/
