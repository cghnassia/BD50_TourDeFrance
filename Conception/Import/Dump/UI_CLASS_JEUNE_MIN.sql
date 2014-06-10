--------------------------------------------------------
--  DDL for Procedure UI_CLASS_JEUNE_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_JEUNE_MIN" is
cursor cur_part is select *
from (select * from participant order by part_class_gene asc)
where tour_annee=getselectedtour
and (getselectedtour-to_char(cycliste_daten,'YYYY'))<26
and rownum < 6;
rang number(3) := 1;
tps_first participant.part_tps_gene%type := 0;
begin
htp.print('<h3>Classement des jeunes</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Dossard');
  htp.tableheader('Equipe');
  htp.tableheader('Temps');
  htp.tableheader('Ecart');
	for recpart in cur_part loop
    if (rang=1) then
      tps_first:=recpart.part_tps_gene;
    end if;
    htp.tableRowOpen;
		htp.tableData(rang);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom||'('||recpart.cycliste_pays||')'));
    htp.tableData(recpart.part_num);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.part_tps_gene);
    htp.tableData(tps_first-recpart.part_tps_gene);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
    rang:=rang+1;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_jeune_complet">Afficher classement complet</a></div>');
  
end;

/
