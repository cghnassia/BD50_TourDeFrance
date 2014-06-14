--------------------------------------------------------
--  DDL for Procedure UI_HOME
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HOME" IS
	path_img varchar2(255) := '/public/img/';
BEGIN
  UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('
		<h2>Leaders</h2>
		<div class="row separation1"></div>
		    <div class="grid">
				<div class="grid2">');
					UI_HOME_AFF_PORTEURS('jaune',RECUP_MAX_ETAPE);
					UI_HOME_AFF_PORTEURS('pois',RECUP_MAX_ETAPE);
		htp.print('</div/>
		</div>
		<div class="row separation2"></div>
			<div class="grid"> 
				<div class="grid2">');
					UI_HOME_AFF_PORTEURS('vert',RECUP_MAX_ETAPE);
					UI_HOME_AFF_PORTEURS('blanc',RECUP_MAX_ETAPE);  
		htp.print('</div/>
		</div>  
		<div class="row separation2"></div>
		<div class="grid"> 
			<div class="grid2">');
				UI_HOME_AFF_PORTEURS('rouge',RECUP_MAX_ETAPE); 
		htp.print('<div>     
					<img class="left" src="'|| path_img||'equipe.png" alt="Maillot equipe">
					<div class="mod">N°'||recup_leader_equipe(RECUP_MAX_ETAPE).equipe_num||
					'</br>'|| htf.anchor ('ui_detail_equipe?n_equipe=' || recup_leader_equipe(RECUP_MAX_ETAPE).equipe_num,recup_leader_equipe(RECUP_MAX_ETAPE).equipe_nom)||
					'</br>'||recup_leader_equipe(RECUP_MAX_ETAPE).equipe_pays||'</div>
					</div>');
		htp.print('</div/>
		</div> 
		</div>');
	UI_MAIN_CLOSE;
  UI_FOOTER;
END UI_HOME;

/
