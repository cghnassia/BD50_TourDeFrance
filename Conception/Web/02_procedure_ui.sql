create or replace 
FUNCTION getSelectedTour
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


create or replace 
procedure ui_head is
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

create or replace 
procedure ui_select_tour(vtour varchar2 default 2013) is
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


create or replace 
procedure ui_header is
path_css varchar2(255) := '/public/css/';
ftour tour%ROWTYPE;
begin
select * into ftour from tour where tour_annee=getselectedtour;
htp.print('
<header id="header" role="banner" class="line pam">
		<div class="row">
			<div class="col w30"><h1>Tour de France ' || getselectedtour || '</h1></div>
      <div class="col w40 right">' || ftour.tour_edition || 'e édition </br> ' || ftour.tour_dated || ' </br> ' || ftour.tour_datef ||' </div>
      <div class="col ">');
      select_tour(getselectedtour);
htp.print('</div>
		</div>
		<div id="navigation">
			<ul>
        <li class="pas inbl"><a href="ui_home">Accueil</a></li>
				<li class="pas inbl"><a href="ui_letape">Parcours</a></li>
				<li class="pas inbl"><a href="ui_lequipe">Equipes</a></li>
				<li class="pas inbl"><a href="ui_lparticipant">Coureurs</a></li>
				<li class="pas inbl"><a href="#">Classements</a></li>
			</ul>
		</div>
	</header>');
end;


create or replace 
procedure ui_home is
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
		<div class="line">
			<img class="left" src="'|| path_img || 'jaune.png" alt="Maillot Jaune">
			<div class="mod">11</br>Toto</br>RadioShack</br>Suisse</div>
		</div>
    <div class="row separation12"></div>
    <div class="line">
			<img class="left" src="'|| path_img || 'vert.png" alt="Maillot Jaune">
			<div class="mod">11</br>Toto</br>RadioShack</br>Suisse</div>
		</div>
	</div>');
	htp.bodyclose;
	htp.htmlclose;
end;


create or replace 
procedure ui_lparticipant is
cursor cur_part is select * from participant where tour_annee=getselectedtour order by part_num;
begin

  ui_head;
  ui_header;
  
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

create or replace 
procedure ui_lequipe is
cursor cur_part is select * from equipe where tour_annee=getselectedtour order by equipe_num;

begin
  ui_head;
  ui_header;

htp.tableOpen();
	htp.tableheader('Numéro');
	htp.tableheader('Nom');
	htp.tableheader('Web');
	htp.tableheader('Desc');
	htp.tableheader('Pays');
	for recequi in cur_part loop
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

create or replace 
procedure ui_letape is
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

create or replace 
procedure ui_lpoint (numetape etape.etape_num%type) is
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

create or replace 
procedure ui_detail_equipe(nequi number default 1) is
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

create or replace 
procedure ui_detail_participant(vnum_part number default 1) is
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
    htp.tableData(htf.anchor ('detail_equipe?nequi=' || vpart.equipe_num,vpart.equipe_nom));
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
  htp.tableClose;

end;


create or replace 
procedure maj_selected_tour(vtour varchar2,prev_url varchar2) is
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