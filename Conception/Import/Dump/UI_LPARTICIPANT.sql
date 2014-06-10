--------------------------------------------------------
--  DDL for Procedure UI_LPARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LPARTICIPANT" (crit_nom varchar2 default '%',crit_pnom varchar2 default '%') is
cursor cur_part is 
select * 
from participant 
where tour_annee=getselectedtour 
and cycliste_nom like UPPER('%'||crit_nom||'%')
and cycliste_prenom like UPPER('%'||crit_pnom||'%')
order by part_num;
begin

  ui_head;
  ui_header;
  htp.print('<div class="w80 txtleft">');
  /*Formulaire*/
  htp.formopen(curl=>'ui_lparticipant', cmethod=>'POST');
	htp.print('Nom:');
  htp.formtext('crit_nom');
  htp.print('Prénom:');
  htp.formtext('crit_pnom');
	htp.formsubmit(cvalue=>'OK');
	htp.formclose;
  htp.print('</br></div>');
  /*********************************/
  
  htp.tableOpen();
	htp.tableheader('Dossard');
	htp.tableheader('Nom');
	htp.tableheader('Prénom');
	htp.tableheader('Equipe');
	htp.tableheader('Pays');
	for recpart in cur_part loop
		htp.tableRowOpen;
		htp.tableData(recpart.part_num);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom));
		htp.tableData(recpart.cycliste_prenom);
		htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.cycliste_pays);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
end;

/
