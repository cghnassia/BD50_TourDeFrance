--------------------------------------------------------
--  DDL for Procedure UI_LEQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LEQUIPE" (crit_nom varchar2 default '%') is
cursor cur_equi is 
select * 
from equipe 
where tour_annee=getselectedtour 
and equipe_nom like UPPER('%'||crit_nom||'%')
order by equipe_num;

begin
  ui_head;
  ui_header;
  
  
  /*Formulaire*/
  htp.print('<div class="w80 txtleft">');
  htp.formopen(curl=>'ui_lequipe', cmethod=>'POST');
	htp.print('Nom:');
  htp.formtext('crit_nom');
	htp.formsubmit(cvalue=>'OK');
	htp.formclose;
  htp.print('</br></div>');
  /*********************************/
  
htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Web');
	htp.tableheader('Desc');
	htp.tableheader('Pays');
	for recequi in cur_equi loop
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
