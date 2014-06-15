--------------------------------------------------------
--  Fichier créé - dimanche-juin-15-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure COLOR_ROW_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."COLOR_ROW_P" (cpt number default 0) IS
BEGIN
	IF(mod(cpt,2)=0) THEN
				  htp.tableRowOpen(cattributes => 'class="rowP"');
			  ELSE
			   htp.tableRowOpen;
			  END IF;
END COLOR_ROW_P;

/
--------------------------------------------------------
--  DDL for Procedure MAJ_SELECTED_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."MAJ_SELECTED_ETAPE" 
(n_etape varchar2,prev_url varchar2) IS
BEGIN
	owa_cookie.remove('Etape',null);
	owa_util.mime_header('text/html', FALSE);
	owa_cookie.send(
		name=>'Etape',
		value=>n_etape
	);
	owa_util.redirect_url(prev_url);
	owa_util.http_header_close;
END MAJ_SELECTED_ETAPE;

/
--------------------------------------------------------
--  DDL for Procedure MAJ_SELECTED_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."MAJ_SELECTED_TOUR" 
(v_tour varchar2,prev_url varchar2) IS
BEGIN
	owa_cookie.remove('Tour',null);
	owa_util.mime_header('text/html', FALSE);
	owa_cookie.send(
		name=>'Tour',
		value=>v_tour
	);
	owa_util.redirect_url(prev_url);
    owa_util.http_header_close;
END MAJ_SELECTED_TOUR;

/
--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_EQUI
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_EQUI" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1) IS
	CURSOR cur_equi IS 
		SELECT 
			* 
		FROM 
			terminer_etape_equipe 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND gene_equi_class < nb_ligne 
		AND etape_num=n_etape 
		AND gene_equi_class!=0  
		ORDER BY gene_equi_class;
	
	first_tps equipe.equipe_tps_gene%TYPE;
  cpt number(3) := 0;
BEGIN
	SELECT 
		gene_equi_tps INTO first_tps 
	FROM 
		terminer_etape_equipe 
	WHERE tour_annee=GETSELECTEDTOUR 
	AND etape_num=n_etape 
	AND gene_equi_class=1;
	
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
			FOR recequi in cur_equi LOOP
          cpt:=cpt+1;
          COLOR_ROW_P(cpt);
					htp.tableData(recequi.gene_equi_class);
					htp.tableData(htf.anchor ('ui_detail_equipe?n_equipe=' || recequi.equipe_num,recequi.equipe_nom));
					htp.tableData(formated_time(recequi.gene_equi_tps));
          
					IF recequi.gene_equi_tps-first_tps != 0 THEN
           htp.tableData('+ ' || formated_time(recequi.gene_equi_tps-first_tps));
          ELSE
           htp.tableData('');
         END IF;
         
				htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
			END LOOP;
	htp.tableClose;
    
	EXCEPTION
		when others THEN
			null;
END UI_AFF_CLASS_EQUI;

/
--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_ETAPE" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			terminer_etape 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND etape_class <= nb_ligne 
		AND etape_num=n_etape 
		AND etape_class != 0 
		ORDER BY etape_class;
		
	cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
			FOR recpart in cur_part LOOP
        cpt:=cpt+1;
        COLOR_ROW_P(cpt);
				htp.tableData(recpart.etape_class);
				htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
				htp.tableData(recpart.part_num);
				htp.tableData(recpart.equipe_nom);
        
        htp.tableData(formated_time(recpart.etape_tps));
      
        IF recpart.etape_tps_ecart != 0 THEN
          htp.tableData('+ ' || formated_time(recpart.etape_tps_ecart));
        ELSE
          htp.tableData('');
        END IF;
      
				htp.tableRowClose;
			END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
END UI_AFF_CLASS_ETAPE;

/
--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_GENE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_GENE" (nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			terminer_etape 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND gene_class <= nb_ligne 
		AND etape_num=n_etape 
		AND gene_class != 0 
		ORDER BY gene_class;

	cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
		
		FOR recpart in cur_part LOOP
			cpt:=cpt+1;
      COLOR_ROW_P(cpt);
			htp.tableData(recpart.gene_class);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
			htp.tableData(recpart.part_num);
			htp.tableData(recpart.equipe_nom);
			htp.tableData(formated_time(recpart.gene_tps));
      
      IF recpart.gene_tps_ecart != 0 THEN
        htp.tableData('+ ' || formated_time(recpart.gene_tps_ecart));
      ELSE
        htp.tableData('');
      END IF;
      
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
		END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
end UI_AFF_CLASS_GENE;

/
--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_JEUNE
--------------------------------------------------------
set define off;

CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_JEUNE" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			*
		FROM (
			SELECT * FROM terminer_etape
			WHERE tour_annee=GETSELECTEDTOUR
			AND (GETSELECTEDTOUR-TO_CHAR(cycliste_daten,'YYYY')) < 26
			AND etape_num=n_etape
			ORDER BY gene_class asc
		)
		WHERE rownum <= nb_ligne;
	
	rang number(3) := 1;
	tps_first participant.part_tps_gene%TYPE := 0;
	cpt number(3) := 0;
BEGIN

	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
		
		FOR recpart in cur_part LOOP
			if (rang=1) then
      tps_first:=recpart.gene_tps;
    end if;
        cpt:=cpt+1;
        COLOR_ROW_P(cpt);
				htp.tableData(rang);
				htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
				htp.tableData(recpart.part_num);
				htp.tableData(recpart.equipe_nom);
				htp.tableData(formated_time(recpart.gene_tps));
        
				IF recpart.gene_tps-tps_first != 0 THEN
					htp.tableData('++ ' || formated_time(recpart.gene_tps-tps_first));
				  ELSE
					htp.tableData('');
				 END IF;
        
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
			
			rang:=rang+1;
		END LOOP;
	htp.tableClose;
  	EXCEPTION
	when others THEN
		null;
END UI_AFF_CLASS_JEUNE;

/
--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_MONT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_MONT" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			terminer_etape 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND gene_class_mont <= nb_ligne 
		AND etape_num=n_etape 
		AND gene_class_mont!=0 
		ORDER BY gene_class_mont;
	
	cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col4"');
		htp.tableheader('Points');
		
	FOR recpart in cur_part LOOP
      cpt:=cpt+1;
      COLOR_ROW_P(cpt);
			htp.tableData(recpart.gene_class_mont);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
			htp.tableData(recpart.part_num);
			htp.tableData(recpart.equipe_nom);
			htp.tableData(recpart.gene_pts_mont);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	END LOOP;
	htp.tableClose;
  EXCEPTION
  when others THEN
    null;
END UI_AFF_CLASS_MONT;

/
--------------------------------------------------------
--  DDL for Procedure UI_AFF_CLASS_SPRINT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_CLASS_SPRINT" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			terminer_etape 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND gene_class_sprint <= nb_ligne 
		AND gene_class_sprint!=0 
		AND etape_num=n_etape 
		ORDER BY gene_class_sprint;
    
	cpt number(3) := 0;	
	
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col4"');
		htp.tableheader('Points');
		
		FOR recpart in cur_part LOOP
        cpt:=cpt+1;
        COLOR_ROW_P(cpt);
				htp.tableData(recpart.gene_class_sprint);
				htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom)||' ('||RECUP_ACRO_PAYS(recpart.part_num)||')');
				htp.tableData(recpart.part_num);
				htp.tableData(recpart.equipe_nom);
				htp.tableData(recpart.gene_pts_sprint);
			htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
		END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
END UI_AFF_CLASS_SPRINT;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_EQUIPE_COMPLET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_EQUIPE_COMPLET" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
BEGIN
	UI_HEAD;
		UI_HEADER;
		UI_MAIN_OPEN;
			htp.print('<h3>Classement équipe à l''étape '||n_etape||'</h3>');
			UI_AFF_CLASS_EQUI(nb_ligne,n_etape);
		UI_MAIN_CLOSE;
		UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_EQUIPE_COMPLET;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_ETAPE_COMPLET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_ETAPE_COMPLET" 
  (nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
BEGIN
  UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('<h3>Classement de l''étape '||n_etape||'</h3>');
		UI_AFF_CLASS_ETAPE(nb_ligne,n_etape);
	UI_MAIN_CLOSE;
	UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_ETAPE_COMPLET;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_GENE_COMPLET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_GENE_COMPLET" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
BEGIN
  UI_HEAD;
	UI_HEADER;
		UI_MAIN_OPEN;
			htp.print('<h3>Classement général à l''étape ' ||n_etape||'</h3>');
			UI_AFF_CLASS_GENE(nb_ligne,n_etape);
		UI_MAIN_CLOSE;
	UI_FOOTER;
  EXCEPTION
  when others THEN
    null;
END UI_CLASS_GENE_COMPLET;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_JEUNE_COMPLET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_JEUNE_COMPLET" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
BEGIN
  UI_HEAD;
	UI_HEADER;
		UI_MAIN_OPEN;
			htp.print('<h3>Classement du meilleur jeune à l''étape '||n_etape||'</h3>');
			UI_AFF_CLASS_JEUNE(nb_ligne,n_etape);
		UI_MAIN_CLOSE;
	UI_FOOTER;
END UI_CLASS_JEUNE_COMPLET;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_MONT_COMPLET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_MONT_COMPLET" 
(nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
BEGIN
  UI_HEAD;
  UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('<h3>Classement du meilleur grimpeur à l''étape '||n_etape||'</h3>');
		UI_AFF_CLASS_MONT(nb_ligne,n_etape);
	UI_MAIN_CLOSE;
  UI_FOOTER;
END UI_CLASS_MONT_COMPLET;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_SPRINT_COMPLET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_SPRINT_COMPLET" 
  (nb_ligne number default 999,n_etape etape.etape_num%TYPE) IS
BEGIN
  UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('<h3>Classement du meilleur sprinteur à l''étape '||n_etape||'</h3>');
		UI_AFF_CLASS_SPRINT(nb_ligne,n_etape);
	UI_MAIN_CLOSE;
  UI_FOOTER;
END UI_CLASS_SPRINT_COMPLET;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASSEMENTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASSEMENTS" IS
BEGIN
UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('<h3>Classement général</h3>');
		UI_AFF_CLASS_GENE(5,RECUP_MAX_ETAPE);
		htp.print('<div class="w80 center txtright"><a href="ui_class_gene_complet?n_etape='||RECUP_MAX_ETAPE||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement du meilleur grimpeur</h3>');
		UI_AFF_CLASS_MONT(5,RECUP_MAX_ETAPE);
		htp.print('<div class="w80 center txtright"><a href="ui_class_mont_complet?n_etape='||RECUP_MAX_ETAPE||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement du meilleur sprinteur</h3>');
		UI_AFF_CLASS_SPRINT(5,RECUP_MAX_ETAPE);
		htp.print('<div class="w80 center txtright"><a href="ui_class_sprint_complet?n_etape='||RECUP_MAX_ETAPE||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement du meilleur jeune</h3>');
		UI_AFF_CLASS_JEUNE(5,RECUP_MAX_ETAPE);
		htp.print('<div class="w80 center txtright"><a href="ui_class_jeune_complet?n_etape='||RECUP_MAX_ETAPE||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement équipe</h3>');
		UI_AFF_CLASS_EQUI(5,RECUP_MAX_ETAPE);
		htp.print('<div class="w80 center txtright"><a href="ui_class_equipe_complet?n_etape='||RECUP_MAX_ETAPE||'">Afficher classement complet</a></div>');
	UI_MAIN_CLOSE;
	UI_FOOTER;
END UI_CLASSEMENTS;

/
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
--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_ETAPE" 
(n_etape etape.etape_num%TYPE default GETSELECTEDETAPE) IS
	CURSOR cur_pp IS 
		SELECT 
			* 
		FROM 
			point_passage 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND etape_num=n_etape  
		ORDER BY pt_pass_num;
		
	v_etape etape%ROWTYPE;
	path_img varchar2(255) := '/public/img/';
	cpt number(3) := 0;
BEGIN
	SELECT 
		* INTO v_etape 
	FROM 
		etape 
	WHERE 
		etape_num=n_etape 
	AND tour_annee = GETSELECTEDTOUR;
	
	UI_HEAD;
	UI_HEADER;
		UI_MAIN_OPEN;
			htp.print('
			<div class="row">
				<div class="col"><h2>'||v_etape.etape_date||' - Etape '|| n_etape|| '</h2></div>
				<div class="col w20">'); 
				UI_SELECT_ETAPE(n_etape); 
				htp.print('</div>
			</div>');
  
			htp.print('
			<div class="row h2-like greyFrame">  '||v_etape.ville_nom_debuter|| ' / '||v_etape.ville_nom_finir|| '</div>
				<div class="row h3-like greyFrame">'||v_etape.etape_distance||' km - TYPE :  '||v_etape.tetape_lib||'</div>
				</br>
			<div class="row h4-like">Porteurs de maillot à l''issue de l''étape '||n_etape||'</div>
			<div class="row separation1"></div>
			<div class="row">
				<div class="grid">
					<div class="grid6"> <!--ClassementG-->
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| path_img || 'jaune_min.png" alt="Maillot Jaune"></div>
								<div class="inbl">Maillot Jaune</div>
							</div>  
							<div class="line">
								<div class="inbl">'||recup_porteur('jaune',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_class_gene_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| path_img || 'vert_min.png" alt="Maillot Vert"></div>
								<div class="inbl">Maillot Vert</div>
							</div>  
							<div class="line">
								<div class="inbl">'||recup_porteur('vert',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_class_sprint_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| path_img || 'pois_min.png" alt="Maillot à pois"></div>
								<div class="inbl">Maillot à pois</div>
							</div>  
							<div class="line">
								<div class="inbl">'||recup_porteur('pois',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_class_mont_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| path_img || 'blanc_min.png" alt="Maillot blanc"></div>
								<div class="inbl">Maillot blanc</div>
							</div>  
							<div class="line">
								<div class="inbl">'||recup_porteur('blanc',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_class_jeune_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| path_img || 'vainqueur_jour_min.png" alt="Vainqueur du jour"></div>
								<div class="inbl">Vainqueur de l''étape</div>
							</div>  
							<div class="line">
								<div class="inbl">'||recup_porteur('etape',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_class_etape_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| path_img || 'equipe_min.png" alt="Leader équipe"></div>
								<div class="inbl">Equipe leader</div>
							</div>  
							<div class="line">
								<div class="inbl">'||recup_leader_equipe(n_etape).equipe_nom||'</div>
							</div>
							<div><a href="ui_class_equipe_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
					</div>
				</div>
			</div>
			</br>   
			<div class="row separation2"></div>
			<div class="w80 center"><h3>Itinéraire horaire</h3></div>
			</br>
			');
			htp.tableOpen(cattributes => 'class="normalTab"');
				htp.tableheader('Numéro',cattributes => 'class="col2"');
				htp.tableheader('Nom',cattributes => 'class="col4"');
				htp.tableheader('Ville',cattributes => 'class="col3"');
				htp.tableheader('Km départ');
				htp.tableheader('Km arrivée');
				htp.tableheader('Altitude',cattributes => 'class="col2"');
				htp.tableheader('Horaire',cattributes => 'class="col2"');
				
				FOR recpp in cur_pp LOOP
					cpt:=cpt+1;
					IF(mod(cpt,2)=0) THEN
						htp.tableRowOpen(cattributes => 'class="rowP"');
					ELSE
						htp.tableRowOpen;
					END IF;
					
					htp.tableData(recpp.pt_pass_num);
					htp.tableData(recpp.pt_pass_nom);
					IF (recpp.pt_pass_ville_nom = 'NULL') THEN
            htp.tableData('&nbsp;');
          ELSE
            htp.tableData(recpp.pt_pass_ville_nom);
          END IF;
					htp.tableData(recpp.pt_pass_km_dep);
					htp.tableData(recpp.pt_pass_km_arr);
					htp.tableData(recpp.pt_pass_alt);
					htp.tableData(recpp.pt_pass_horaire);
				htp.tableRowClose;
				htp.tableRowOpen;
				htp.tableRowClose;
				END LOOP;
	htp.tableClose;
  UI_MAIN_CLOSE;
  UI_FOOTER;
END UI_DETAIL_ETAPE;

/
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
--------------------------------------------------------
--  DDL for Procedure UI_FOOTER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_FOOTER" IS
	path_css varchar2(255) := '/public/css/';
BEGIN
	htp.print('
		<div id="footer" role="contentinfo" class="line pam txtcenter">
			Tour de France
		</div>
	</body>
	</html>');
END UI_FOOTER;

/
--------------------------------------------------------
--  DDL for Procedure UI_HEAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HEAD" IS
	path_css varchar2(255) := '/public/css/';
BEGIN
	htp.print('
		<!docTYPE html>
		<!--[IF lte IE 7]> <html class="no-js ie67 ie678" lang="fr"> <![endIF]-->
		<!--[IF IE 8]> <html class="no-js ie8 ie678" lang="fr"> <![endIF]-->
		<!--[IF IE 9]> <html class="no-js ie9" lang="fr"> <![endIF]-->
		<!--[IF gt IE 9]> <!--><html class="no-js" lang="fr"> <!--<![endIF]-->
		<head>
			<meta charset="UTF-8">
			<!--[IF IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endIF]-->
			<title>Tour de France ' || GETSELECTEDTOUR || '</title>
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<!--[IF lt IE 9]>
			<script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
			<![endIF]-->
			<link rel="stylesheet" href="' || path_css ||'knacss.css" media="all">
			<link rel="stylesheet" href="' || path_css ||'styles.css" media="all">
		</head>
		<body>');
END UI_HEAD;

/
--------------------------------------------------------
--  DDL for Procedure UI_HEADER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HEADER" IS
	path_css varchar2(255) := '/public/css/';
	v_tour tour%ROWTYPE;
BEGIN
	SELECT 
		* INTO v_tour 
	FROM 
		tour 
	WHERE tour_annee=GETSELECTEDTOUR;
	
	UI_MAIN_OPEN;
	htp.print('
		<div class="autogrid3">
			<div><h1>Tour de France ' || GETSELECTEDTOUR || '</h1></div>
			<div>' || v_tour.tour_edition || 'e édition </br> ' || v_tour.tour_dated || ' - ' || v_tour.tour_datef ||' </div>
			<div>');
      UI_SELECT_TOUR(GETSELECTEDTOUR);
	htp.print('</div>
		</div>
		<div id="navigation">
			<ul>
				<li class="pas inbl"><a href="ui_home">Accueil</a></li>
				<li class="pas inbl"><a href="ui_letape">Parcours</a></li>
				<li class="pas inbl"><a href="ui_lequipe">Equipes</a></li>
				<li class="pas inbl"><a href="ui_lparticipant">Coureurs</a></li>
				<li class="pas inbl"><a href="ui_classements">Classements</a></li>
			</ul>
		</div>
	</header>');
END UI_HEADER;

/
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
--------------------------------------------------------
--  DDL for Procedure UI_LEQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LEQUIPE" 
  (crit_nom varchar2 default '%') IS
	CURSOR cur_equi IS 
		SELECT 
			* 
		FROM 
			equipe 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND equipe_nom like UPPER('%'||crit_nom||'%')
		ORDER BY equipe_num;

	cpt number(3) :=0;
BEGIN
  UI_HEAD;
	UI_HEADER;
	UI_MAIN_OPEN;
		htp.print('
		<div class="row">
			<div class="col">
				<h2>Equipes</h2>
			</div>
			<div class="col">');
			htp.print('<div class="w80 txtleft">');
				htp.FORmopen(curl=>'ui_lequipe', cmethod=>'POST');
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
		
		FOR recequi in cur_equi LOOP
			cpt:=cpt+1;
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
			htp.tableRowOpen;
			END IF;
			
			htp.tableData(recequi.equipe_num);
			htp.tableData(htf.anchor ('ui_detail_equipe?n_equipe=' || recequi.equipe_num,recequi.equipe_nom));
			htp.tableData(recequi.equipe_web);
			htp.tableData(recequi.equipe_pays);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	END LOOP;
  htp.tableClose;
  UI_MAIN_CLOSE;
  UI_FOOTER;
END;

/
--------------------------------------------------------
--  DDL for Procedure UI_LETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LETAPE" IS
CURSOR cur_etape IS SELECT * FROM etape WHERE tour_annee=GETSELECTEDTOUR ORDER BY etape_num;
BEGIN

  UI_HEAD;
  UI_HEADER;
  htp.print('<div id="main" role="main" class="line pam">
  <h2>Parcours</h2>
  <div class="row separation2"></div></br>');
  htp.tableOpen(cattributes => 'class="normalTab"');
	htp.tableheader('Etape',cattributes => 'class="col2"');
  htp.tableheader('Type');
  htp.tableheader('Date');
  htp.tableheader('Départ > Arrivée',cattributes => 'class="col4"');
  htp.tableheader('Distance');
  htp.tableheader('Détail');
	FOR recetape in cur_etape LOOP
		IF(mod(recetape.etape_num,2)=0) THEN
      htp.tableRowOpen(cattributes => 'class="rowP"');
    ELSE
       htp.tableRowOpen;
    END IF;
		htp.tableData(recetape.etape_num);
    htp.tableData(recetape.etape_date);
    htp.tableData(recetape.tetape_lib);
    htp.tableData(recetape.ville_nom_debuter||' > '||recetape.ville_nom_finir);
     htp.tableData(recetape.etape_dIStance || ' km');
    htp.tableData(htf.anchor ('ui_detail_etape?n_etape=' || recetape.etape_num,'Détails'));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	END LOOP;
  htp.tableClose;
  htp.print('</div>');
  UI_FOOTER;
END UI_LETAPE;

/
--------------------------------------------------------
--  DDL for Procedure UI_LPARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LPARTICIPANT" 
  (crit_nom varchar2 default '%',crit_pnom varchar2 default '%') IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			participant 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND UPPER(cycliste_nom) like UPPER('%'||crit_nom||'%')
		AND UPPER(cycliste_prenom) like UPPER('%'||crit_pnom||'%')
		ORDER BY part_num;

	cpt number(3) := 0;
	prev equipe.equipe_num%TYPE := 0;
BEGIN
  UI_HEAD;
  UI_HEADER;
  UI_MAIN_OPEN;
    htp.print('
		<div class="row">
			<div class="col">
				<h2>Participants</h2>
			</div>
			<div class="col">');
				htp.print('<div class="w90 txtleft">');
				htp.FORmopen(curl=>'ui_lparticipant', cmethod=>'POST');
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
		
	FOR recpart in cur_part LOOP
		cpt:=cpt+1;
		IF (recpart.equipe_num!=prev AND prev=0) THEN
			htp.print('
			<div class="w80 center">'||htf.anchor ('ui_detail_equipe?n_equipe=' || recpart.equipe_num,recpart.equipe_nom)||'</div>');
			
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
    
			htp.tableData(recpart.part_num);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom));
			htp.tableData(recpart.cycliste_prenom);
			htp.tableData(recpart.cycliste_pays);
			htp.tableRowClose;
    
			prev:=recpart.equipe_num; 
    
		ELSIF(recpart.equipe_num!=prev AND prev!=0) THEN
			htp.tableClose;
			htp.print('</br>
			<div class="w80 center">'||htf.anchor ('ui_detail_equipe?n_equipe=' || recpart.equipe_num,recpart.equipe_nom)||'</div>');
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
    
			htp.tableData(recpart.part_num);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom));
			htp.tableData(recpart.cycliste_prenom);
			htp.tableData(recpart.cycliste_pays);
			htp.tableRowClose;
    
			prev:=recpart.equipe_num;
			
		ELSE
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
			
			htp.tableData(recpart.part_num);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom));
			htp.tableData(recpart.cycliste_prenom);
			htp.tableData(recpart.cycliste_pays);
			htp.tableRowClose;
		END IF;
	END LOOP;
  UI_MAIN_CLOSE;
END UI_LPARTICIPANT;

/
--------------------------------------------------------
--  DDL for Procedure UI_MAIN_CLOSE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_MAIN_CLOSE" is
begin
  htp.print('</div>');
end UI_MAIN_CLOSE;

/
--------------------------------------------------------
--  DDL for Procedure UI_MAIN_OPEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_MAIN_OPEN" is
begin
	htp.print('<div id="main" role="main" class="line pam">');
end UI_MAIN_OPEN;

/
--------------------------------------------------------
--  DDL for Procedure UI_SELECT_ETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_SELECT_ETAPE" 
(n_etape varchar2 default GETSELECTEDETAPE) IS
	CURSOR letape IS 
		SELECT 
			* 
		FROM 
			etape 
		WHERE 
			tour_annee = GETSELECTEDTOUR 
		ORDER BY 1;
BEGIN
	htp.FORmopen(curl=>'maj_selected_etape', cmethod=>'GET');
	htp.print('Etape:');
	htp.FORmSELECTopen('n_etape');
	FOR crec in letape LOOP
		IF (crec.etape_num=n_etape) THEN
			htp.FORmSELECToption(crec.etape_num,crec.etape_num);
		ELSE
			htp.FORmSELECToption(crec.etape_num);
		END IF;
	END LOOP ;
	htp.FORmSELECTClose;
	htp.FORmhidden('prev_url',owa_util.get_procedure);
	htp.FORmsubmit(cvalue=>'OK');
	htp.FORmclose;
END UI_SELECT_ETAPE;

/
--------------------------------------------------------
--  DDL for Procedure UI_SELECT_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_SELECT_TOUR" 
(v_tour varchar2 default 2013) IS
CURSOR l_tour IS 
	SELECT 
		tour_annee 
	FROM 
		tour 
	ORDER BY 1;
BEGIN
	htp.FORmopen(curl=>'maj_selected_tour', cmethod=>'POST');
	htp.print('Tour:');
	htp.FORmSELECTopen('v_tour');
	FOR crec in l_tour LOOP
    IF (crec.tour_annee=v_tour) THEN
      htp.FORmSELECToption(crec.tour_annee,crec.tour_annee);
    ELSE
      htp.FORmSELECToption(crec.tour_annee);
    END IF;
	END LOOP ;
	htp.FORmSELECTClose;
	htp.FORmhidden('prev_url',owa_util.get_procedure);
	htp.FORmsubmit(cvalue=>'OK');
	htp.FORmclose;

END UI_SELECT_TOUR;

/

--------------------------------------------------------
--  Fichier créé - dimanche-juin-15-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FORMATED_TIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."FORMATED_TIME" (
      time_number NUMBER)
RETURN VARCHAR2 IS
v_formated_time VARCHAR2(20);
v_time  NUMBER(10, 0);
v_tenths NUMBER(2, 0);
v_seconds NUMBER(2, 0);
v_minuts NUMBER(2, 0);
v_hours NUMBER(3, 0);
BEGIN
  v_time := time_number;
  
	v_tenths := MOD(v_time, 10);
  
  v_time := FLOOR(v_time / 10);
  v_seconds := MOD(v_time, 60);
    
  v_time := FLOOR(v_time / 60);
  v_minuts := MOD(v_time, 60);

  v_hours := FLOOR(v_time / 60);
  
  IF v_hours != 0 THEN
    v_formated_time := v_hours || 'h ';
  END IF;
  
  IF v_hours != 0 AND v_minuts < 10 THEN
    v_formated_time := v_formated_time || '0';
  END IF;
  
  IF v_hours != 0 OR v_minuts != 0 THEN
    v_formated_time := v_formated_time || v_minuts || ''' ';
  END IF;
  
  IF (v_hours != 0 OR v_minuts != 0) AND v_seconds < 10 THEN
    v_formated_time := v_formated_time || '0';
  END IF;
  
  IF v_hours != 0 OR v_minuts != 0 OR v_seconds != 0 THEN
    v_formated_time := v_formated_time || v_seconds || ''''' ';
  END IF;
  
  RETURN v_formated_time;
--EXCEPTION
--  WHEN OTHERS THEN dbms_output.put_line('Erreur');
END FORMATED_TIME;

/
--------------------------------------------------------
--  DDL for Function GETSELECTEDETAPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."GETSELECTEDETAPE" 
RETURN varchar2 IS
getape varchar2(50);
cookie OWA_COOKIE.COOKIE;
BEGIN
	 cookie := OWA_COOKIE.GET('Etape');
   if(cookie.num_vals > 0) then
     getape  := cookie.VALS(1);
  else
     select max(etape_num) into getape from terminer_etape where tour_annee=getselectedtour;
  end if;
   RETURN getape;
END GETSELECTEDETAPE;

/
--------------------------------------------------------
--  DDL for Function GETSELECTEDTOUR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."GETSELECTEDTOUR" 
RETURN varchar2 IS
gtour varchar2(50);
cookie OWA_COOKIE.COOKIE;
BEGIN
	 cookie := OWA_COOKIE.GET('Tour');
   if(cookie.num_vals > 0) then
     gtour  := cookie.VALS(1);
  else
     select max(tour_annee) into gtour from tour;
  end if;
   RETURN gtour;
END getSelectedTour;

/
--------------------------------------------------------
--  DDL for Function RECUP_ACRO_PAYS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_ACRO_PAYS" 
(n_part participant.part_num%TYPE )
RETURN pays.pays_acro%TYPE IS
   v_acro pays.pays_acro%TYPE;
BEGIN
   SELECT DISTINCT 
		pays_acro INTO v_acro 
	FROM pays 
	INNER JOIN cycliste cy 
		ON pays.pays_num=cy.pays_num 
	INNER JOIN participant pa 
		ON cy.cycliste_num=pa.cycliste_num 
	WHERE pa.part_num=n_part 
	AND pa.tour_annee=GETSELECTEDTOUR ;
	return v_acro;
END RECUP_ACRO_PAYS;

/
--------------------------------------------------------
--  DDL for Function RECUP_LEADER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_LEADER" (
      vmaillot porter.maillot_couleur%type,
      numetape porter.etape_num%type )
    RETURN participant%rowtype
  IS
    npart participant.part_num%type;
    vpart participant%rowtype;
  BEGIN
    IF (vmaillot='etape') THEN
      SELECT part_num
      INTO npart
      FROM terminer_etape
      WHERE tour_annee =getselectedtour
      AND etape_num    = numetape
      AND etape_class  = 1;
    ELSE
      SELECT DISTINCT po.part_num
      INTO npart
      FROM porter po
      INNER JOIN participant pa
      ON po.part_num         = pa.part_num
      WHERE po.etape_num     = numetape
      AND po.tour_annee      =getselectedtour
      AND po.maillot_couleur = vmaillot ;
    END IF;
    SELECT *
    INTO vpart
    FROM participant pa
    WHERE pa.part_num=npart
    AND tour_annee   =getselectedtour;
    RETURN vpart;
  EXCEPTION
  WHEN OTHERS THEN
    --htp.print('Aucun porteur de maillot pour cette étape');
    RETURN NULL;
  END recup_leader;

/
--------------------------------------------------------
--  DDL for Function RECUP_LEADER_EQUIPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_LEADER_EQUIPE" (numetape porter.etape_num%type )
return equipe%rowtype IS
nequipe equipe.equipe_num%type;
vequipe equipe%rowtype;
begin

  select equipe_num into nequipe
  from (select * from terminer_etape_equipe order by gene_equi_class asc)
  where tour_annee=getselectedtour
  and etape_num = numetape
  and rownum = 1;
  
  
select * into vequipe from equipe eq where eq.equipe_num=nequipe and tour_annee=getselectedtour;
return vequipe;

exception
  when others then
   --htp.print('Aucun porteur de maillot pour cette étape');
   return null;


end recup_leader_equipe;

/
--------------------------------------------------------
--  DDL for Function RECUP_MAX_ETAPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_MAX_ETAPE" 
RETURN etape.etape_num%TYPE IS
n_etape etape.etape_num%TYPE;
BEGIN
	SELECT max(etape_num) INTO n_etape FROM terminer_etape WHERE tour_annee=GETSELECTEDTOUR;
     return n_etape;
END RECUP_MAX_ETAPE;

/
--------------------------------------------------------
--  DDL for Function RECUP_PORTEUR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_PORTEUR" (
      vmaillot porter.maillot_couleur%type,
      numetape porter.etape_num%type )
    RETURN participant%rowtype
  IS
    npart participant.part_num%type;
    vpart participant%rowtype;
  BEGIN
    IF (vmaillot='etape') THEN
      SELECT part_num
      INTO npart
      FROM terminer_etape
      WHERE tour_annee =getselectedtour
      AND etape_num    = numetape
      AND etape_class  = 1;
    ELSE
      SELECT DISTINCT po.part_num
      INTO npart
      FROM porter po
      INNER JOIN participant pa
      ON po.part_num         = pa.part_num
      WHERE po.etape_num     = numetape
      AND po.tour_annee      =getselectedtour
      AND po.maillot_couleur = vmaillot ;
    END IF;
    
    SELECT *
    INTO vpart
    FROM participant pa
    WHERE pa.part_num=npart
    AND tour_annee   =getselectedtour;
    RETURN vpart;
  EXCEPTION
  WHEN OTHERS THEN
    --htp.print('Aucun porteur de maillot pour cette étape');
    RETURN NULL;
  END recup_porteur;
  

/
