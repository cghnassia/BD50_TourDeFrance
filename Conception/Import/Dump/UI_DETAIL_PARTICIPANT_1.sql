--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_PARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_PARTICIPANT" (vnum_part number default 1) is
vpart participant%rowtype;
begin
  select * into vpart from participant where part_num=vnum_part and tour_annee=getselectedtour;
  ui_head;
  ui_header;
  
  htp.tableOpen();
	htp.tableheader('Dossard');
	htp.tableheader('Nom');
	htp.tableheader('Prénom');
  htp.tableheader('Date de naissance');
  htp.tableheader('Pays');
  htp.tableheader('Poids');
  htp.tableheader('Taille');
	htp.tableheader('Equipe');
		htp.tableRowOpen;
		htp.tableData(vpart.part_num);
		htp.tableData(vpart.cycliste_nom);
		htp.tableData(vpart.cycliste_prenom);
    htp.tableData(vpart.cycliste_daten);
    htp.tableData(vpart.cycliste_pays);
    htp.tableData(vpart.part_poids);
    htp.tableData(vpart.part_taille);
    htp.tableData(htf.anchor ('detail_equipe?nequi=' || vpart.equipe_num,vpart.equipe_nom));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
  htp.tableClose;

end;

/
