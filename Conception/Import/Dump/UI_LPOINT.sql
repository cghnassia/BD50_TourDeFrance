--------------------------------------------------------
--  DDL for Procedure UI_LPOINT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LPOINT" (numetape etape.etape_num%type) is
cursor cur_pp is select * from point_passage where tour_annee=getselectedtour and etape_num=numetape  order by pt_pass_num;
begin

  ui_head;
  ui_header;

  htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Ville');
	htp.tableheader('Km départ');
	htp.tableheader('Km arrivée');
  htp.tableheader('Altitude');
  htp.tableheader('Horaire prévu');
	for recpp in cur_pp loop
		htp.tableRowOpen;
		htp.tableData(recpp.pt_pass_num);
    htp.tableData(recpp.pt_pass_nom);
    htp.tableData(recpp.pt_pass_ville_nom);
    htp.tableData(recpp.pt_pass_km_dep);
    htp.tableData(recpp.pt_pass_km_arr);
    htp.tableData(recpp.pt_pass_alt);
    htp.tableData(recpp.pt_pass_horaire);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
end;

/
