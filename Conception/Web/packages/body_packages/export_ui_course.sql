--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body UI_COURSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_COURSE" AS 

   PROCEDURE UI_LETAPE IS
   etapes db_param_commun.ref_cur;
   rec_etape etape%rowtype;
  BEGIN
  
  UI_COMMUN.UI_HEAD;
  UI_COMMUN.UI_HEADER;
  UI_COMMUN.UI_MAIN_OPEN;
  htp.print('
  <h2>Parcours</h2>
  <div class="row separation2"></div></br>');
  htp.tableOpen(cattributes => 'class="normalTab"');
	htp.tableheader('Etape',cattributes => 'class="col2"');
  htp.tableheader('Type');
  htp.tableheader('Date');
  htp.tableheader('Départ > Arrivée',cattributes => 'class="col4"');
  htp.tableheader('Distance');
  htp.tableheader('Détail');
	etapes := db_course.getAllEtape;
  fetch etapes into rec_etape;
	while(etapes%found) loop
  
		IF(mod(rec_etape.etape_num,2)=0) THEN
      htp.tableRowOpen(cattributes => 'class="rowP"');
    ELSE
       htp.tableRowOpen;
    END IF;
		htp.tableData(rec_etape.etape_num);
    htp.tableData(rec_etape.etape_date);
    htp.tableData(rec_etape.tetape_lib);
    htp.tableData(rec_etape.ville_nom_debuter||' > '||rec_etape.ville_nom_finir);
     htp.tableData(rec_etape.etape_distance || ' km');
    htp.tableData(htf.anchor ('ui_course.ui_detail_etape?n_etape=' || rec_etape.etape_num,'Détails'));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	  fetch etapes into rec_etape;
	  END LOOP ;
    htp.tableClose;
    UI_COMMUN.UI_MAIN_OPEN;
    UI_COMMUN.UI_FOOTER;
  END UI_LETAPE;
  
  PROCEDURE UI_DETAIL_ETAPE (n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) IS
  pps db_param_commun.ref_cur;
  rec_pp point_passage%rowtype;
	v_etape etape%ROWTYPE := db_course.getEtape(n_etape);
	cpt number(3) := 0;
BEGIN

	
	UI_COMMUN.UI_HEAD;
	UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
			htp.print('
			<div class="row">
				<div class="col"><h2>'||v_etape.etape_date||' - Etape '|| n_etape|| '</h2></div>
				<div class="col w20">'); 
				UI_COMMUN.UI_SELECT_ETAPE(n_etape); 
				htp.print('</div>
			</div>');
			htp.print('
			<div class="row h2-like greyFrame">  '||v_etape.ville_nom_debuter|| ' / '||v_etape.ville_nom_finir|| '</div>
				<div class="row h3-like greyFrame">'||v_etape.etape_distance||' km - TYPE :  '||v_etape.tetape_lib||'</div>
				</br>');
      htp.print('
			<div class="row h4-like">Porteurs de maillot à l''issue de l''étape '||n_etape||'</div>
			<div class="row separation1"></div>
			<div class="row">
				<div class="grid">
					<div class="grid6"> <!--ClassementG-->
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| ui_param_commun.path_img || 'jaune_min.png" alt="Maillot Jaune"></div>
								<div class="inbl">Maillot Jaune</div>
							</div>
							<div class="line">
								<div class="inbl">'||db_resultat.getPorteur('jaune',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_resultat.ui_class_gene_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| ui_param_commun.path_img || 'vert_min.png" alt="Maillot Vert"></div>
								<div class="inbl">Maillot Vert</div>
							</div>  
							<div class="line">
								<div class="inbl">'||db_resultat.getPorteur('vert',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_resultat.ui_class_sprint_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| ui_param_commun.path_img || 'pois_min.png" alt="Maillot à pois"></div>
								<div class="inbl">Maillot à pois</div>
							</div>  
							<div class="line">
								<div class="inbl">'||db_resultat.getPorteur('pois',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_resultat.ui_class_mont_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| ui_param_commun.path_img || 'blanc_min.png" alt="Maillot blanc"></div>
								<div class="inbl">Maillot blanc</div>
							</div>  
							<div class="line">
								<div class="inbl">'||db_resultat.getPorteur('blanc',n_etape).cycliste_nom||'</div>
							</div>
							<div><a href="ui_resultat.ui_class_jeune_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| ui_param_commun.path_img || 'vainqueur_jour_min.png" alt="Vainqueur du jour"></div>
								<div class="inbl">Vainqueur de l''étape</div>
							</div>  
							<div class="line">
								<div class="inbl">'||db_inscription.getPart(db_resultat.getLeaderEtape(n_etape)).cycliste_nom||'</div>
							</div>
							<div><a href="ui_resultat.ui_class_etape_complet?n_etape='||n_etape||'">Détail</a></div>
						</div>
						<div>
							<div class="line">
								<div class="inbl"><img src="'|| ui_param_commun.path_img || 'equipe_min.png" alt="Leader équipe"></div>
								<div class="inbl">Equipe leader</div>
							</div>  
							<div class="line">
								<div class="inbl">'||db_resultat.getEquipeLeader(n_etape).equipe_nom||'</div>
							</div>
							<div><a href="ui_resultat.ui_class_equipe_complet?n_etape='||n_etape||'">Détail</a></div>
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
				
				pps := db_course.getAllPdP;
        fetch pps into rec_pp;
        while(pps%found) loop
					cpt:=cpt+1;
					ui_utils.color_row_p(cpt);
					
					htp.tableData(rec_pp.pt_pass_num);
					htp.tableData(rec_pp.pt_pass_nom);
					IF (rec_pp.pt_pass_ville_nom = 'NULL') THEN
            htp.tableData('&nbsp;');
          ELSE
            htp.tableData(rec_pp.pt_pass_ville_nom);
          END IF;
					htp.tableData(rec_pp.pt_pass_km_dep);
					htp.tableData(rec_pp.pt_pass_km_arr);
					htp.tableData(rec_pp.pt_pass_alt);
					htp.tableData(rec_pp.pt_pass_horaire);
				htp.tableRowClose;
				htp.tableRowOpen;
				htp.tableRowClose;
        fetch pps into rec_pp;
				END LOOP;
	htp.tableClose;
  UI_COMMUN.UI_MAIN_CLOSE;
  UI_COMMUN.UI_FOOTER;
END UI_DETAIL_ETAPE;
  
END UI_COURSE;

/
