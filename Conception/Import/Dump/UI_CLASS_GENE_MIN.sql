--------------------------------------------------------
--  DDL for Procedure UI_CLASS_GENE_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_GENE_MIN" is
cursor cur_part is select * from participant where tour_annee=getselectedtour and part_class_gene < 6 order by part_class_gene;

begin
htp.print('<h3>Classement général</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Dossard');
  htp.tableheader('Equipe');
  htp.tableheader('Temps');
  htp.tableheader('Ecart');
	for recpart in cur_part loop
		htp.tableRowOpen;
		htp.tableData(recpart.part_class_gene);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom||'('||recpart.cycliste_pays||')'));
    htp.tableData(recpart.part_num);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.part_tps_gene);
    htp.tableData(recpart.part_tps_ecart);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_gene_complet">Afficher classement complet</a></div>');

end;

/
