--------------------------------------------------------
--  Fichier créé - lundi-juin-09-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure MAJ_SELECTED_TOUR
--------------------------------------------------------
--------------------------------------------------------
--  Fichier créé - lundi-juin-09-2014   
--------------------------------------------------------
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
--  DDL for Function RECUP_LEADER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_LEADER" (vmaillot porter.maillot_couleur%type)
return participant%rowtype IS
npart participant.part_num%type;
max_etape etape.etape_num%type;
vpart participant%rowtype;
begin
select max(po.etape_num) into max_etape from porter po where po.tour_annee=getselectedtour and po.maillot_couleur=vmaillot ;
select distinct pa.part_num into npart from participant pa inner join porter po on pa.part_num = po.part_num and po.tour_annee = pa.tour_annee
where po.etape_num = max_etape
and po.tour_annee=getselectedtour
and po.maillot_couleur = vmaillot ;

select * into vpart from participant pa where pa.part_num=npart and tour_annee=getselectedtour;
return vpart;

end recup_leader;

/

set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."MAJ_SELECTED_TOUR" (vtour varchar2,prev_url varchar2) is
begin
  owa_cookie.remove('Tour',null);
  owa_util.mime_header('text/html', FALSE);
  owa_cookie.send(
    name=>'Tour',
    value=>vtour
  );
    owa_util.redirect_url(prev_url);
    owa_util.http_header_close;

end;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_EQUI_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_EQUI_MIN" is
cursor cur_equi is select * from equipe where tour_annee=getselectedtour and equipe_class_gene < 6  order by equipe_class_gene;
first_tps equipe.equipe_tps_gene%type;
begin
 select equipe_tps_gene into first_tps from equipe where tour_annee=getselectedtour and equipe_class_gene=1;
htp.print('<h3>Classement par équipe</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Temps');
  htp.tableheader('Ecart');
	for recequi in cur_equi loop
		htp.tableRowOpen;
		htp.tableData(recequi.equipe_class_gene);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recequi.equipe_num,recequi.equipe_nom));
    htp.tableData(recequi.equipe_tps_gene);
    htp.tableData(first_tps-recequi.equipe_tps_gene);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_equipe_complet">Afficher classement complet</a></div>');
    exception
  when others then
    htp.print('<div class="row separation2"></div>');
  htp.print('Pas de classement par équipe disponible');
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_GENE_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_GENE_MIN" is
cursor cur_part is select * from participant where tour_annee=getselectedtour and part_class_gene < 6 order by part_class_gene;

begin
htp.print('<h3>Classement général</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Dossard');
  htp.tableheader('Equipe');
  htp.tableheader('Temps');
  htp.tableheader('Ecart');
	for recpart in cur_part loop
		htp.tableRowOpen;
		htp.tableData(recpart.part_class_gene);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom||'('||recpart.cycliste_pays||')'));
    htp.tableData(recpart.part_num);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.part_tps_gene);
    htp.tableData(recpart.part_tps_ecart);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_gene_complet">Afficher classement complet</a></div>');

end;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_JEUNE_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_JEUNE_MIN" is
cursor cur_part is select *
from (select * from participant order by part_class_gene asc)
where tour_annee=getselectedtour
and (getselectedtour-to_char(cycliste_daten,'YYYY'))<26
and rownum < 6;
rang number(3) := 1;
tps_first participant.part_tps_gene%type := 0;
begin
htp.print('<h3>Classement des jeunes</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Dossard');
  htp.tableheader('Equipe');
  htp.tableheader('Temps');
  htp.tableheader('Ecart');
	for recpart in cur_part loop
    if (rang=1) then
      tps_first:=recpart.part_tps_gene;
    end if;
    htp.tableRowOpen;
		htp.tableData(rang);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom||'('||recpart.cycliste_pays||')'));
    htp.tableData(recpart.part_num);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.part_tps_gene);
    htp.tableData(tps_first-recpart.part_tps_gene);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
    rang:=rang+1;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_jeune_complet">Afficher classement complet</a></div>');
  
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_MONT_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_MONT_MIN" is
cursor cur_part is select * from participant where tour_annee=getselectedtour and part_class_mont < 6 order by part_class_mont;

begin
htp.print('<h3>Classement du meilleur grimpeur</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Dossard');
  htp.tableheader('Equipe');
  htp.tableheader('Points');
	for recpart in cur_part loop
		htp.tableRowOpen;
		htp.tableData(recpart.part_class_mont);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom||'('||recpart.cycliste_pays||')'));
    htp.tableData(recpart.part_num);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.part_pts_mont);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_mont_complet">Afficher classement complet</a></div>');
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASS_SPRINT_MIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASS_SPRINT_MIN" is
cursor cur_part is select * from participant where tour_annee=getselectedtour and part_class_sprint < 6 order by part_class_sprint;

begin
htp.print('<h3>Classement par points</h3>');
htp.tableOpen();
	htp.tableheader('Rang');
	htp.tableheader('Nom');
	htp.tableheader('Dossard');
  htp.tableheader('Equipe');
  htp.tableheader('Points');
	for recpart in cur_part loop
		htp.tableRowOpen;
		htp.tableData(recpart.part_class_sprint);
		htp.tableData(htf.anchor ('ui_detail_participant?vnum_part=' || recpart.part_num,recpart.cycliste_nom ||' '||recpart.cycliste_prenom||'('||recpart.cycliste_pays||')'));
    htp.tableData(recpart.part_num);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || recpart.equipe_num,recpart.equipe_nom));
    htp.tableData(recpart.part_pts_sprint);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
  htp.print('<div class="w80 center txtright"><a href="ui_class_sprint_complet">Afficher classement complet</a></div>');
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_CLASSEMENTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASSEMENTS" is
begin
  ui_head;
  ui_header;
  ui_class_gene_min;
  ui_class_mont_min;
  ui_class_sprint_min;
  ui_class_jeune_min;
  ui_class_equi_min;
  ui_footer;
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_EQUIPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_EQUIPE" (nequi number default 1) is
vequi equipe%rowtype;
begin
  select * into vequi from equipe where equipe_num=nequi and tour_annee=getselectedtour;
  ui_head;
  ui_header;
  htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Web');
  htp.tableheader('Desc');
  htp.tableheader('Pays');
  htp.tableheader('Spon');
  htp.tableheader('Acro');
		htp.tableRowOpen;
		htp.tableData(vequi.equipe_num);
		htp.tableData(vequi.equipe_nom);
		htp.tableData(vequi.equipe_web);
    htp.tableData(vequi.equipe_desc);
    htp.tableData(vequi.equipe_pays);
    htp.tableData(vequi.spon_nom);
    htp.tableData(vequi.spon_acro);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
  htp.tableClose;

end;

/
--------------------------------------------------------
--  DDL for Procedure UI_DETAIL_PARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_DETAIL_PARTICIPANT" (vnum_part number default 1) is
vpart participant%rowtype;
begin
  select * into vpart from participant where part_num=vnum_part and tour_annee=getselectedtour;
  ui_head;
  ui_header;

  htp.tableOpen();
	htp.tableheader('Dossard');
	htp.tableheader('Nom');
	htp.tableheader('Prénom');
  htp.tableheader('Date de naissance');
  htp.tableheader('Pays');
  htp.tableheader('Poids');
  htp.tableheader('Taille');
	htp.tableheader('Equipe');
		htp.tableRowOpen;
		htp.tableData(vpart.part_num);
		htp.tableData(vpart.cycliste_nom);
		htp.tableData(vpart.cycliste_prenom);
    htp.tableData(vpart.cycliste_daten);
    htp.tableData(vpart.cycliste_pays);
    htp.tableData(vpart.part_poids);
    htp.tableData(vpart.part_taille);
    htp.tableData(htf.anchor ('ui_detail_equipe?nequi=' || vpart.equipe_num,vpart.equipe_nom));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
  htp.tableClose;

end;

/
--------------------------------------------------------
--  DDL for Procedure UI_FOOTER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_FOOTER" is
path_css varchar2(255) := '/public/css/';

begin
	htp.print('
  <div id="footer" role="contentinfo" class="line pam txtcenter">
    Tour de France
	</div>
  </body>
  </html>');
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_HEAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HEAD" is
path_css varchar2(255) := '/public/css/';
begin
htp.print('
<!doctype html>
<!--[if lte IE 7]> <html class="no-js ie67 ie678" lang="fr"> <![endif]-->
<!--[if IE 8]> <html class="no-js ie8 ie678" lang="fr"> <![endif]-->
<!--[if IE 9]> <html class="no-js ie9" lang="fr"> <![endif]-->
<!--[if gt IE 9]> <!--><html class="no-js" lang="fr"> <!--<![endif]-->
<head>
		<meta charset="UTF-8">
		<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
		<title>Tour de France ' || getselectedtour || '</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<!--[if lt IE 9]>
		<script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<link rel="stylesheet" href="' || path_css ||'knacss.css" media="all">
		<link rel="stylesheet" href="' || path_css ||'styles.css" media="all">
</head>
<body>');
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_HEADER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HEADER" is
path_css varchar2(255) := '/public/css/';
ftour tour%ROWTYPE;
begin
select * into ftour from tour where tour_annee=getselectedtour;
htp.print('
<header id="header" role="banner" class="line pam">
		<div class="autogrid3">
			<div><h1>Tour de France ' || getselectedtour || '</h1></div>
      <div>' || ftour.tour_edition || 'e édition </br> ' || ftour.tour_dated || ' - ' || ftour.tour_datef ||' </div>
      <div>');
      ui_select_tour(getselectedtour);
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
end;

/
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
--------------------------------------------------------
--  DDL for Procedure UI_LETAPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LETAPE" is
cursor cur_etape is select * from etape where tour_annee=getselectedtour order by etape_num;
begin

  ui_head;
  ui_header;

  htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Date');
	htp.tableheader('Distance');
	htp.tableheader('Type');
  htp.tableheader('Départ');
  htp.tableheader('Arrivée');
	for recetape in cur_etape loop
		htp.tableRowOpen;
		htp.tableData(recetape.etape_num);
    htp.tableData(htf.anchor ('ui_lpoint?numetape=' || recetape.etape_num,recetape.etape_nom));
    htp.tableData(recetape.etape_date);
    htp.tableData(recetape.etape_distance || ' km');
    htp.tableData(recetape.tetape_lib);
    htp.tableData(recetape.ville_nom_debuter);
    htp.tableData(recetape.ville_nom_finir);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;

end;

/
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
--------------------------------------------------------
--  DDL for Procedure UI_LPOINT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LPOINT" (numetape etape.etape_num%type) is
cursor cur_pp is select * from point_passage where tour_annee=getselectedtour and etape_num=numetape  order by pt_pass_num;
begin

  ui_head;
  ui_header;

  htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Ville');
	htp.tableheader('Km départ');
	htp.tableheader('Km arrivée');
  htp.tableheader('Altitude');
  htp.tableheader('Horaire prévu');
	for recpp in cur_pp loop
		htp.tableRowOpen;
		htp.tableData(recpp.pt_pass_num);
    htp.tableData(recpp.pt_pass_nom);
    htp.tableData(recpp.pt_pass_ville_nom);
    htp.tableData(recpp.pt_pass_km_dep);
    htp.tableData(recpp.pt_pass_km_arr);
    htp.tableData(recpp.pt_pass_alt);
    htp.tableData(recpp.pt_pass_horaire);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
	end loop;
  htp.tableClose;
end;

/
--------------------------------------------------------
--  DDL for Procedure UI_SELECT_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_SELECT_TOUR" (vtour varchar2 default 2013) is
cursor ltour is select tour_annee from tour order by 1;
ftour tour%ROWTYPE;
begin
  /*Formulaire de sélection du Tour*/
  htp.formopen(curl=>'maj_selected_tour', cmethod=>'POST');
	htp.print('Tour:');
  htp.formselectopen('vtour');
	for crec in ltour loop
    if (crec.tour_annee=vtour) then
      htp.formselectoption(crec.tour_annee,crec.tour_annee);
    else
      htp.formselectoption(crec.tour_annee);
    end if;
	end loop ;
  htp.formSelectClose;
  htp.formhidden('prev_url',owa_util.get_procedure);
	htp.formsubmit(cvalue=>'OK');
	htp.formclose;
  /*********************************/
end;
/
