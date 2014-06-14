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
