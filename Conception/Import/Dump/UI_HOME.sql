--------------------------------------------------------
--  DDL for Procedure UI_HOME
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HOME" is
ftour tour%ROWTYPE;
vtour varchar2(4);
path_img varchar2(255) := '/public/img/';
begin
  select * into ftour from tour where tour_annee=getselectedtour;

  
  ui_head;
  ui_header;
  htp.print('
  <div id="main" role="main" class="line pam">
		<h2>Leaders</h2>
		<div class="row separation1"></div>
		
    <div class="grid">
      <div class="grid2">
        <div>     
          <img class="left" src="'|| path_img || 'jaune.png" alt="Maillot Jaune">
          <div class="mod">N°'||recup_leader('jaune').part_num||
            '</br>'|| htf.anchor ('ui_detail_participant?vnum_part=' || recup_leader('jaune').part_num,recup_leader('jaune').cycliste_prenom||' '||recup_leader('jaune').cycliste_nom)||
            '</br>'|| htf.anchor ('ui_detail_equipe?nequi=' || recup_leader('jaune').equipe_num,recup_leader('jaune').equipe_nom)||
            '</br>'||recup_leader('jaune').cycliste_pays||'</div>
        </div>
        <div>     
          <img class="left" src="'|| path_img || 'vert.png" alt="Maillot Vert">
          <div class="mod">N°'||recup_leader('vert').part_num||
            '</br>'|| htf.anchor ('ui_detail_participant?vnum_part=' || recup_leader('vert').part_num,recup_leader('vert').cycliste_prenom||' '||recup_leader('vert').cycliste_nom)||
            '</br>'|| htf.anchor ('ui_detail_equipe?nequi=' || recup_leader('vert').equipe_num,recup_leader('vert').equipe_nom)||
            '</br>'||recup_leader('vert').cycliste_pays||'</div>
        </div>
      </div/>
    </div>
     <div class="row separation2"></div>
    <div class="grid"> 
      <div class="grid2">
        <div>     
          <img class="left" src="'|| path_img || 'pois.png" alt="Maillot à Pois">
          <div class="mod">N°'||recup_leader('pois').part_num||
            '</br>'|| htf.anchor ('ui_detail_participant?vnum_part=' || recup_leader('pois').part_num,recup_leader('pois').cycliste_prenom||' '||recup_leader('pois').cycliste_nom)||
            '</br>'|| htf.anchor ('ui_detail_equipe?nequi=' || recup_leader('pois').equipe_num,recup_leader('pois').equipe_nom)||
            '</br>'||recup_leader('pois').cycliste_pays||'</div>
        </div>
        <div>     
          <img class="left" src="'|| path_img || 'blanc.png" alt="Maillot blanc">
          <div class="mod">N°'||recup_leader('blanc').part_num||
            '</br>'|| htf.anchor ('ui_detail_participant?vnum_part=' || recup_leader('blanc').part_num,recup_leader('blanc').cycliste_prenom||' '||recup_leader('blanc').cycliste_nom)||
            '</br>'|| htf.anchor ('ui_detail_equipe?nequi=' || recup_leader('blanc').equipe_num,recup_leader('blanc').equipe_nom)||
            '</br>'||recup_leader('blanc').cycliste_pays||'</div>
        </div>
      </div/>
    </div> 

      
		</div>
	</div>');
  ui_footer;
end;

/
