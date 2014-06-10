--------------------------------------------------------
--  DDL for Procedure UI_LETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LETAPE" is
cursor cur_etape is select * from etape where tour_annee=getselectedtour order by etape_num;
begin

  ui_head;
  ui_header;

  htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Date');
	htp.tableheader('Distance');
	htp.tableheader('Type');
  htp.tableheader('Départ');
  htp.tableheader('Arrivée');
	for recetape in cur_etape loop
		htp.tableRowOpen;
		htp.tableData(recetape.etape_num);
    htp.tableData(htf.anchor ('ui_lpoint?numetape=' || recetape.etape_num,recetape.etape_nom));
    htp.tableData(recetape.etape_date);
    htp.tableData(recetape.etape_distance || ' km');
    htp.tableData(recetape.tetape_lib);
    htp.tableData(recetape.ville_nom_debuter);
    htp.tableData(recetape.ville_nom_finir);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;

end;

/
