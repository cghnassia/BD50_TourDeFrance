--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_PARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_PARTICIPANT" 
(n_part number default 1) IS
	v_part participant%ROWTYPE;
BEGIN
	SELECT 
		* INTO v_part 
	FROM 
		participant 
	WHERE 
		part_num=n_part 
	AND tour_annee=GETSELECTEDTOUR;
	
  UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print(' <h2>Détail de ' ||v_part.cycliste_nom||'</h2>');
		htp.tableOpen(cattributes => 'class="normalTab"');
			htp.tableheader('Dossard');
			htp.tableheader('Nom');
			htp.tableheader('Prénom');
			htp.tableheader('Date de naISsance');
			htp.tableheader('Pays');
			htp.tableheader('Poids');
			htp.tableheader('Taille');
			htp.tableheader('Equipe');
				htp.tableRowOpen;
					htp.tableData(v_part.part_num);
					htp.tableData(v_part.cycliste_nom);
					htp.tableData(v_part.cycliste_prenom);
					htp.tableData(v_part.cycliste_daten);
					htp.tableData(v_part.cycliste_pays);
					htp.tableData(v_part.part_poids);
					htp.tableData(v_part.part_taille);
					htp.tableData(htf.anchor ('ui_detail_equipe?n_equipe=' || v_part.equipe_num,v_part.equipe_nom));
				htp.tableRowClose;
				htp.tableRowOpen;
				htp.tableRowClose;
		htp.tableClose;
    UI_MAIN_CLOSE;
  UI_FOOTER;
END UI_DETAIL_PARTICIPANT;

/
