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
