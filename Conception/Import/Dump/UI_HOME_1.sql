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

/
