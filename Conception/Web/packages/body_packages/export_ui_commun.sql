--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body UI_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_COMMUN" AS 

PROCEDURE "UI_HEAD" IS
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
			<title>Tour de France ' || ui_utils.getSelectedTour || '</title>
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<!--[IF lt IE 9]>
			<script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
			<![endIF]-->
			<link rel="stylesheet" href="' || ui_param_commun.path_css ||'knacss.css" media="all">
			<link rel="stylesheet" href="' || ui_param_commun.path_css ||'styles.css" media="all">
		</head>
		<body>');
END UI_HEAD;


PROCEDURE              "UI_HEADER" IS
	v_tour tour%ROWTYPE := db_commun.getTour(ui_utils.getSelectedTour);
BEGIN
	UI_MAIN_OPEN;
	htp.print('
		<div class="autogrid3">
			<div><h1>Tour de France ' || ui_utils.getSelectedTour || '</h1></div>
			<div>' || v_tour.tour_edition || 'e édition </br> ' || v_tour.tour_dated || ' - ' || v_tour.tour_datef ||' </div>
			<div>');
      UI_SELECT_TOUR(ui_utils.getSelectedTour);
      ui_authentification.cadreAuth;
	htp.print('</div>
		</div>
		<div id="navigation">
			<ul>
				<li class="pas inbl"><a href="ui_commun.ui_home">Accueil</a></li>
				<li class="pas inbl"><a href="ui_course.ui_letape">Parcours</a></li>
				<li class="pas inbl"><a href="ui_inscription.ui_lequipe">Equipes</a></li>
				<li class="pas inbl"><a href="ui_inscription.ui_lparticipant">Coureurs</a></li>
				<li class="pas inbl"><a href="ui_resultat.ui_classements">Classements</a></li>
			</ul>
		</div>
	</header>');
END UI_HEADER;
  
PROCEDURE              "UI_MAIN_OPEN" is
begin
	htp.print('<div id="main" role="main" class="line pam">');
end UI_MAIN_OPEN;


PROCEDURE              "UI_MAIN_CLOSE" is
begin
  htp.print('</div>');
end UI_MAIN_CLOSE;

  
PROCEDURE              "UI_FOOTER" IS
BEGIN
	htp.print('
		<div id="footer" role="contentinfo" class="line pam txtcenter">
			Tour de France
		</div>
	</body>
	</html>');
END UI_FOOTER;

PROCEDURE              "UI_SELECT_TOUR" 
(a_tour varchar2 default ui_utils.getSelectedTour) IS
tours db_param_commun.ref_cur;
rec_tour tour%rowtype;
BEGIN
	htp.FORmopen(curl=>'ui_utils.maj_selected_tour', cmethod=>'POST');
	htp.print('Tour:');
	htp.FORmSELECTopen('v_tour');
  tours := db_commun.getAllTour;
  fetch tours into rec_tour;
	while(tours%found) loop
    IF (rec_tour.tour_annee=a_tour) THEN
      htp.FORmSELECToption(rec_tour.tour_annee,rec_tour.tour_annee);
    ELSE
      htp.FORmSELECToption(rec_tour.tour_annee);
    END IF;
  fetch tours into rec_tour;
	END LOOP ;
	htp.FORmSELECTClose;
	htp.FORmhidden('prev_url',owa_util.get_procedure);
	htp.FORmsubmit(cvalue=>'OK');
	htp.FORmclose;

END UI_SELECT_TOUR;

PROCEDURE  "UI_HOME" IS
BEGIN
  UI_COMMUN.UI_HEAD;
	UI_COMMUN.UI_HEADER;
	UI_COMMUN.UI_MAIN_OPEN;
		htp.print('
		<h2>Leaders</h2>
		<div class="row separation1"></div>
		    <div class="grid">
				<div class="grid2">');
					UI_COMMUN.UI_HOME_AFF_PORTEURS('jaune',db_commun.getLastEtape);
					UI_COMMUN.UI_HOME_AFF_PORTEURS('pois',db_commun.getLastEtape);
		htp.print('</div/>
		</div>
		<div class="row separation2"></div>
			<div class="grid"> 
				<div class="grid2">');
					UI_COMMUN.UI_HOME_AFF_PORTEURS('vert',db_commun.getLastEtape);
					UI_COMMUN.UI_HOME_AFF_PORTEURS('blanc',db_commun.getLastEtape);  
		htp.print('</div/>
		</div>  
		<div class="row separation2"></div>
		<div class="grid"> 
			<div class="grid2">');
				UI_COMMUN.UI_HOME_AFF_PORTEURS('rouge',db_commun.getLastEtape); 
		htp.print('<div>     
					<img class="left" src="'|| ui_param_commun.path_img||'equipe.png" alt="Maillot equipe">
					<div class="mod">N°'||db_resultat.getEquipeLeader(db_commun.getLastEtape).equipe_num||
					'</br>'|| htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || db_resultat.getEquipeLeader(db_commun.getLastEtape).equipe_num,db_resultat.getEquipeLeader(db_commun.getLastEtape).equipe_nom)||
					'</br>'||db_resultat.getEquipeLeader(db_commun.getLastEtape).equipe_pays||'</div>
					</div>');
		htp.print('</div/>
		</div> 
		</div>');
	UI_COMMUN.UI_MAIN_CLOSE;
  UI_COMMUN.UI_FOOTER;
  EXCEPTION WHEN OTHERS THEN
    null;
END UI_HOME;
 
PROCEDURE UI_HOME_AFF_PORTEURS (v_maillot porter.maillot_couleur%TYPE, n_etape porter.etape_num%TYPE) AS 
BEGIN
  htp.print ('
          <div>     
          <img class="left" src="'|| ui_param_commun.path_img||v_maillot||'.png" alt="Maillot '||v_maillot||'">
          <div class="mod">N°'||db_resultat.getPorteur(v_maillot,n_etape).part_num||
            '</br>'|| htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || db_resultat.getPorteur(v_maillot,n_etape).part_num,db_resultat.getPorteur(v_maillot,n_etape).cycliste_prenom||' '||db_resultat.getPorteur(v_maillot,n_etape).cycliste_nom)||
            '</br>'|| htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || db_resultat.getPorteur(v_maillot,n_etape).equipe_num,db_resultat.getPorteur(v_maillot,n_etape).equipe_nom)||
            '</br>'||db_resultat.getPorteur(v_maillot,n_etape).cycliste_pays||'</div>
        </div>
  ');
     
END UI_HOME_AFF_PORTEURS;

  PROCEDURE UI_SELECT_ETAPE (n_etape varchar2 default ui_utils.getSelectedEtape) IS
	etapes db_param_commun.ref_cur;
  rec_etape etape%rowtype;
  BEGIN
	htp.FORmopen(curl=>'ui_utils.maj_selected_etape', cmethod=>'GET');
	htp.print('Etape:');
	htp.FORmSELECTopen('n_etape');
	etapes := db_course.getAllEtape;
  fetch etapes into rec_etape;
	while(etapes%found) loop
		IF (rec_etape.etape_num=n_etape) THEN
			htp.FORmSELECToption(rec_etape.etape_num,rec_etape.etape_num);
		ELSE
			htp.FORmSELECToption(rec_etape.etape_num);
		END IF;
  fetch etapes into rec_etape;
	END LOOP ;
	htp.FORmSELECTClose;
	htp.FORmhidden('prev_url',owa_util.get_procedure);
	htp.FORmsubmit(cvalue=>'OK');
	htp.FORmclose;
  END UI_SELECT_ETAPE;
  
END UI_COMMUN;

/
