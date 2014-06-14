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
