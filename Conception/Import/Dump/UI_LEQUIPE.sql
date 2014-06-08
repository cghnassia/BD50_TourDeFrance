--------------------------------------------------------
--  DDL for Procedure UI_LEQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LEQUIPE" is
cursor cur_part is select * from equipe where tour_annee=getselectedtour order by equipe_num;

begin
  ui_head;
  ui_header;

htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Web');
	htp.tableheader('Desc');
	htp.tableheader('Pays');
	for recequi in cur_part loop
		htp.tableRowOpen;
		htp.tableData(recequi.equipe_num);
		htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recequi.equipe_num,recequi.equipe_nom));
		htp.tableData(recequi.equipe_web);
		htp.tableData(recequi.equipe_desc);
    htp.tableData(recequi.equipe_pays);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
end;

/
