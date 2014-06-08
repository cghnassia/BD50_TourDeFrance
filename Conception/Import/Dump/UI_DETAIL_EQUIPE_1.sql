--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_EQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_EQUIPE" (nequi number default 1) is
vequi equipe%rowtype;
begin
  select * into vequi from equipe where equipe_num=nequi and tour_annee=getselectedtour;
  ui_head;
  ui_header;
  htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Web');
  htp.tableheader('Desc');
  htp.tableheader('Pays');
  htp.tableheader('Spon');
  htp.tableheader('Acro');
		htp.tableRowOpen;
		htp.tableData(vequi.equipe_num);
		htp.tableData(vequi.equipe_nom);
		htp.tableData(vequi.equipe_web);
    htp.tableData(vequi.equipe_desc);
    htp.tableData(vequi.equipe_pays);
    htp.tableData(vequi.spon_nom);
    htp.tableData(vequi.spon_acro);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
  htp.tableClose;
  
end;

/
