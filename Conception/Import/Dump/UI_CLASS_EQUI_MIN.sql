--------------------------------------------------------
--  DDL for Procedure UI_CLASS_EQUI_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_EQUI_MIN" is
cursor cur_equi is select * from equipe where tour_annee=getselectedtour and equipe_class_gene < 6  order by equipe_class_gene;
first_tps equipe.equipe_tps_gene%type;
begin
 select equipe_tps_gene into first_tps from equipe where tour_annee=getselectedtour and equipe_class_gene=1;
htp.print('<h3>Classement par équipe</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Temps');
  htp.tableheader('Ecart');
	for recequi in cur_equi loop
		htp.tableRowOpen;
		htp.tableData(recequi.equipe_class_gene);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recequi.equipe_num,recequi.equipe_nom));
    htp.tableData(recequi.equipe_tps_gene);
    htp.tableData(first_tps-recequi.equipe_tps_gene);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_equipe_complet">Afficher classement complet</a></div>');
    exception
  when others then
    htp.print('<div class="row separation2"></div>');
  htp.print('Pas de classement par équipe disponible');
end;

/
