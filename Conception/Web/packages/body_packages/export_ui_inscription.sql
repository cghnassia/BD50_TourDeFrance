--------------------------------------------------------
--  Fichier créé - lundi-juin-16-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body UI_INSCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_INSCRIPTION" AS 

  PROCEDURE UI_LPARTICIPANT (crit_nom varchar2 default '%',crit_pnom varchar2 default '%') IS
  prev equipe.equipe_num%TYPE := 0;
  cpt number(3) := 0;
  parts db_param_commun.ref_cur;
  rec_part participant%rowtype;
  BEGIN
  UI_COMMUN.UI_HEAD;
  UI_COMMUN.UI_HEADER;
  UI_COMMUN.UI_MAIN_OPEN;
    htp.print('
		<div class="row">
			<div class="col">
				<h2>Participants</h2>
			</div>
			<div class="col">');
				htp.print('<div class="w90 txtleft">');
				htp.FORmopen(curl=>'ui_inscription.ui_lparticipant', cmethod=>'POST');
				htp.print('Nom:');
				htp.FORmtext('crit_nom');
				htp.print('Prénom:');
				htp.FORmtext('crit_pnom');
				htp.FORmsubmit(cvalue=>'OK');
				htp.FORmclose;
				htp.print('</div>');
     htp.print('</div>
		</div>
		<div class="row separation2"></div></br>');
		
  parts := db_inscription.getPartCrit(crit_nom,crit_pnom);
  fetch parts into rec_part;
	while(parts%found) loop
		cpt:=cpt+1;
		IF (rec_part.equipe_num!=prev AND prev=0) THEN
			htp.print('
			<div class="w80 center">'||htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || rec_part.equipe_num,rec_part.equipe_nom)||'</div>');
			
			htp.tableOpen(cattributes => 'class="normalTab"');
			htp.tableheader('',cattributes => 'class="col2"');
			htp.tableheader('');
			htp.tableheader('');
			htp.tableheader('');
			
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
    
			htp.tableData(rec_part.part_num);
			htp.tableData(htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom));
			htp.tableData(rec_part.cycliste_prenom);
			htp.tableData(rec_part.cycliste_pays);
			htp.tableRowClose;
    
			prev:=rec_part.equipe_num; 
    
		ELSIF(rec_part.equipe_num!=prev AND prev!=0) THEN
			htp.tableClose;
			htp.print('</br>
			<div class="w80 center">'||htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || rec_part.equipe_num,rec_part.equipe_nom)||'</div>');
			htp.tableOpen(cattributes => 'class="normalTab"');
			htp.tableheader('',cattributes => 'class="col2"');
			htp.tableheader('');
			htp.tableheader('');
			htp.tableheader('');
      
             IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
    
			htp.tableData(rec_part.part_num);
			htp.tableData(htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom));
			htp.tableData(rec_part.cycliste_prenom);
			htp.tableData(rec_part.cycliste_pays);
			htp.tableRowClose;
    
			prev:=rec_part.equipe_num;
			
		ELSE
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
			
			htp.tableData(rec_part.part_num);
			htp.tableData(htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom));
			htp.tableData(rec_part.cycliste_prenom);
			htp.tableData(rec_part.cycliste_pays);
			htp.tableRowClose;
		END IF;
    
  fetch parts into rec_part;  
	END LOOP;
  UI_COMMUN.UI_MAIN_CLOSE;
  
  END UI_LPARTICIPANT;
  
  PROCEDURE UI_LEQUIPE (crit_nom varchar2 default '%') IS
  equipes db_param_commun.ref_cur;
  rec_equipe equipe%rowtype;
	cpt number(3) :=0;
  BEGIN
  UI_COMMUN.UI_HEAD;
	UI_COMMUN.UI_HEADER;
	UI_COMMUN.UI_MAIN_OPEN;
		htp.print('
		<div class="row">
			<div class="col">
				<h2>Equipes</h2>
			</div>
			<div class="col">');
			htp.print('<div class="w80 txtleft">');
				htp.FORmopen(curl=>'ui_inscription.ui_lequipe', cmethod=>'POST');
				htp.print('Nom:');
				htp.FORmtext('crit_nom');
				htp.FORmsubmit(cvalue=>'OK');
				htp.FORmclose;
			htp.print('</div>');
		htp.print('</div>
		</div>
		<div class="row separation2"></div></br>');

	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Numéro',cattributes => 'class="col2"');
		htp.tableheader('Nom');
		htp.tableheader('Web');
		htp.tableheader('Pays');
		
    equipes := db_inscription.getEquipeCrit(crit_nom);
    fetch equipes into rec_equipe;
    while(equipes%found) loop
			cpt:=cpt+1;
      ui_utils.color_row_p(cpt);
			
			htp.tableData(rec_equipe.equipe_num);
			htp.tableData(htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || rec_equipe.equipe_num,rec_equipe.equipe_nom));
			htp.tableData(rec_equipe.equipe_web);
			htp.tableData(rec_equipe.equipe_pays);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
    fetch equipes into rec_equipe;
	END LOOP;
  htp.tableClose;
  UI_COMMUN.UI_MAIN_CLOSE;
  UI_COMMUN.UI_FOOTER;
END UI_LEQUIPE;

PROCEDURE UI_DETAIL_PARTICIPANT (n_part number default 1) IS
	v_part participant%ROWTYPE := db_inscription.getPart(n_part);
BEGIN
  UI_COMMUN.UI_HEAD;
	UI_COMMUN.UI_HEADER;
	UI_COMMUN.UI_MAIN_OPEN;
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
					htp.tableData(htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || v_part.equipe_num,v_part.equipe_nom));
				htp.tableRowClose;
				htp.tableRowOpen;
				htp.tableRowClose;
		htp.tableClose;
    UI_COMMUN.UI_MAIN_CLOSE;
  UI_COMMUN.UI_FOOTER;
END UI_DETAIL_PARTICIPANT; 

PROCEDURE UI_DETAIL_EQUIPE (n_equipe number default 1) IS
v_equipe equipe%ROWTYPE := db_inscription.getEquipe(n_equipe);
BEGIN
	
	UI_COMMUN.UI_HEAD;
	UI_COMMUN.UI_HEADER;
	UI_COMMUN.UI_MAIN_OPEN;
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
    UI_COMMUN.UI_MAIN_CLOSE;
  UI_COMMUN.UI_FOOTER;
END UI_DETAIL_EQUIPE;

END UI_INSCRIPTION;

/
