--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_EQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_EQUIPE" 
(n_equipe number default 1) IS
v_equipe equipe%ROWTYPE;
BEGIN
	SELECT 
		* INTO v_equipe 
	FROM 
		equipe 
	WHERE 
		equipe_num=n_equipe 
	AND tour_annee=GETSELECTEDTOUR;
  
	UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('<h2>Détail de l''équipe ' ||v_equipe.equipe_nom||'</h2>');
		htp.tableOpen(cattributes => 'class="normalTab"');
			htp.tableheader('Numéro');
			htp.tableheader('Nom');
			htp.tableheader('Web');
			htp.tableheader('Desc');
			htp.tableheader('Pays');
			htp.tableheader('Spon');
			htp.tableheader('Acro');
				htp.tableRowOpen;
					htp.tableData(v_equipe.equipe_num);
					htp.tableData(v_equipe.equipe_nom);
					htp.tableData(v_equipe.equipe_web);
					htp.tableData(v_equipe.equipe_desc);
					htp.tableData(v_equipe.equipe_pays);
					htp.tableData(v_equipe.spon_nom);
					htp.tableData(v_equipe.spon_acro);
				htp.tableRowClose;
				htp.tableRowOpen;
				htp.tableRowClose;
		htp.tableClose;
    UI_MAIN_CLOSE;
  UI_FOOTER;
END UI_DETAIL_EQUIPE;

/
