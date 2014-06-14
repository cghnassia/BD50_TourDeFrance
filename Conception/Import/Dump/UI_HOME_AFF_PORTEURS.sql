--------------------------------------------------------
--  DDL for Procedure UI_HOME_AFF_PORTEURS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HOME_AFF_PORTEURS" 
(	v_maillot porter.maillot_couleur%TYPE, n_etape porter.etape_num%TYPE) AS 
path_img varchar2(255) := '/public/img/';
BEGIN
  htp.print ('
          <div>     
          <img class="left" src="'|| path_img||v_maillot||'.png" alt="Maillot '||v_maillot||'">
          <div class="mod">N°'||recup_porteur(v_maillot,n_etape).part_num||
            '</br>'|| htf.anchor ('ui_detail_participant?n_part=' || recup_porteur(v_maillot,n_etape).part_num,recup_porteur(v_maillot,n_etape).cycliste_prenom||' '||recup_porteur(v_maillot,n_etape).cycliste_nom)||
            '</br>'|| htf.anchor ('ui_detail_equipe?n_equipe=' || recup_porteur(v_maillot,n_etape).equipe_num,recup_porteur(v_maillot,n_etape).equipe_nom)||
            '</br>'||recup_porteur(v_maillot,n_etape).cycliste_pays||'</div>
        </div>
  ');
END UI_HOME_AFF_PORTEURS;

/
