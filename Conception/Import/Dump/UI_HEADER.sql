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
		<div class="row">
			<div class="col w30"><h1>Tour de France ' || getselectedtour || '</h1></div>
      <div class="col w40 right">' || ftour.tour_edition || 'e édition </br> ' || ftour.tour_dated || ' </br> ' || ftour.tour_datef ||' </div>
      <div class="col ">');
      ui_select_tour(getselectedtour);
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

/