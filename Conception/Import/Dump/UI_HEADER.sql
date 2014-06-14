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
