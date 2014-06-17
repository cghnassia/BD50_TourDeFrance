--------------------------------------------------------
--  DDL for Package Body UI_RESULTAT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_RESULTAT" AS 

  PROCEDURE UI_AFF_CLASS_EQUI (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
	equipes db_param_commun.ref_cur;
  rec_equipe terminer_etape_equipe%rowtype;
	first_tps equipe.equipe_tps_gene%TYPE := db_resultat.getTempsEquipeLeader(n_etape);
  cpt number(3) := 0;
BEGIN

	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
    equipes := db_resultat.getEquipeRanking(nb_ligne,n_etape);
   fetch equipes into rec_equipe;
	 while(equipes%found) loop
          cpt:=cpt+1;
          ui_utils.COLOR_ROW_P(cpt);
					htp.tableData(rec_equipe.gene_equi_class);
					htp.tableData(htf.anchor ('ui_inscription.ui_detail_equipe?n_equipe=' || rec_equipe.equipe_num,rec_equipe.equipe_nom));
					htp.tableData(ui_utils.formated_time(rec_equipe.gene_equi_tps));
          
					IF ( (rec_equipe.gene_equi_tps-first_tps) != 0) THEN
           htp.tableData('+ ' || ui_utils.formated_time(rec_equipe.gene_equi_tps-first_tps));
          ELSE
           htp.tableData('');
         END IF;
         
				htp.tableRowClose;
			htp.tableRowOpen;
			htp.tableRowClose;
      fetch equipes into rec_equipe;
			END LOOP;
	htp.tableClose;
	EXCEPTION
		when others THEN
			null;
END UI_AFF_CLASS_EQUI;


  PROCEDURE UI_AFF_CLASS_ETAPE (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape ) IS
  parts db_param_commun.ref_cur;
  rec_part terminer_etape%rowtype;
  cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
    
    parts := db_resultat.getEtapeRanking(nb_ligne,n_etape);
   fetch parts into rec_part;
	 while(parts%found) loop
        cpt:=cpt+1;
        ui_utils.COLOR_ROW_P(cpt);
				htp.tableData(rec_part.etape_class);
				htp.tableData(htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom ||' '||rec_part.cycliste_prenom)||' ('||db_commun.getAcroPays(rec_part.part_num)||')');
				htp.tableData(rec_part.part_num);
				htp.tableData(rec_part.equipe_nom);
        
        htp.tableData(ui_utils.formated_time(rec_part.etape_tps));
      
        IF rec_part.etape_tps_ecart != 0 THEN
          htp.tableData('+ ' || ui_utils.formated_time(rec_part.etape_tps_ecart));
        ELSE
          htp.tableData('');
        END IF;
      
				htp.tableRowClose;
        fetch parts into rec_part;
			END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
  END UI_AFF_CLASS_ETAPE; 
  
  
  PROCEDURE UI_AFF_CLASS_GENE (nb_ligne number default 999,n_etape porter.etape_num%TYPE default db_commun.getLastEtape) IS
  parts db_param_commun.ref_cur;
  rec_part terminer_etape%rowtype;
  cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
    
    parts := db_resultat.getGeneRanking(nb_ligne,n_etape);
   fetch parts into rec_part;
	 while(parts%found) loop
        cpt:=cpt+1;
        ui_utils.COLOR_ROW_P(cpt);
				htp.tableData(rec_part.gene_class);
				htp.tableData(htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom ||' '||rec_part.cycliste_prenom)||' ('||db_commun.getAcroPays(rec_part.part_num)||')');
				htp.tableData(rec_part.part_num);
				htp.tableData(rec_part.equipe_nom);
        
        htp.tableData(ui_utils.formated_time(rec_part.gene_tps));
      
        IF rec_part.etape_tps_ecart != 0 THEN
          htp.tableData('+ ' || ui_utils.formated_time(rec_part.gene_tps_ecart));
        ELSE
          htp.tableData('');
        END IF;
        
				htp.tableRowClose;
        fetch parts into rec_part;
			END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
  END UI_AFF_CLASS_GENE;
  
    PROCEDURE UI_AFF_CLASS_JEUNE (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
  parts db_param_commun.ref_cur;
  rec_part terminer_etape%rowtype;
  cpt number(3) := 0;
  rang number(3) := 1;
	tps_first participant.part_tps_gene%TYPE := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col3"');
		htp.tableheader('Temps');
		htp.tableheader('Ecart');
    
    parts := db_resultat.getJeuneRanking(nb_ligne,n_etape);
   fetch parts into rec_part;
	 while(parts%found) loop
      if (rang=1) then
        tps_first:=rec_part.gene_tps;
      end if;
        cpt:=cpt+1;
        ui_utils.COLOR_ROW_P(cpt);
				htp.tableData(rec_part.gene_class);
				htp.tableData(htf.anchor ('ui_inscription.ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom ||' '||rec_part.cycliste_prenom)||' ('||db_commun.getAcroPays(rec_part.part_num)||')');
				htp.tableData(rec_part.part_num);
				htp.tableData(rec_part.equipe_nom);
        
        htp.tableData(ui_utils.formated_time(rec_part.gene_tps));
      
        IF rec_part.etape_tps_ecart != 0 THEN
          htp.tableData('+ ' || ui_utils.formated_time(rec_part.gene_tps_ecart));
        ELSE
          htp.tableData('');
        END IF;
      
				htp.tableRowClose;
        fetch parts into rec_part;
			END LOOP;
	htp.tableClose;
	EXCEPTION
	when others THEN
		null;
  END UI_AFF_CLASS_JEUNE;
  
  
  PROCEDURE UI_AFF_CLASS_MONT (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
	parts db_param_commun.ref_cur;
  rec_part terminer_etape%rowtype;
	cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col4"');
		htp.tableheader('Points');
		
    parts := db_resultat.getMontRanking(nb_ligne,n_etape);
    fetch parts into rec_part;
    while(parts%found) loop
      cpt:=cpt+1;
      ui_utils.COLOR_ROW_P(cpt);
			htp.tableData(rec_part.gene_class_mont);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom ||' '||rec_part.cycliste_prenom)||' ('||db_commun.getAcroPays(rec_part.part_num)||')');
			htp.tableData(rec_part.part_num);
			htp.tableData(rec_part.equipe_nom);
			htp.tableData(rec_part.gene_pts_mont);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
     fetch parts into rec_part;
	END LOOP;
	htp.tableClose;
  EXCEPTION
  when others THEN
    null;
  END UI_AFF_CLASS_MONT;
  
    PROCEDURE UI_AFF_CLASS_SPRINT (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
	parts db_param_commun.ref_cur;
  rec_part terminer_etape%rowtype;
	cpt number(3) := 0;
BEGIN
	htp.tableOpen(cattributes => 'class="normalTab"');
		htp.tableheader('Rang',cattributes => 'class="col2"');
		htp.tableheader('Nom',cattributes => 'class="col4"');
		htp.tableheader('N°',cattributes => 'class="col2"');
		htp.tableheader('Equipe',cattributes => 'class="col4"');
		htp.tableheader('Points');
		
    parts := db_resultat.getSprintRanking(nb_ligne,n_etape);
    fetch parts into rec_part;
    while(parts%found) loop
      cpt:=cpt+1;
      ui_utils.COLOR_ROW_P(cpt);
			htp.tableData(rec_part.gene_class_sprint);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || rec_part.part_num,rec_part.cycliste_nom ||' '||rec_part.cycliste_prenom)||' ('||db_commun.getAcroPays(rec_part.part_num)||')');
			htp.tableData(rec_part.part_num);
			htp.tableData(rec_part.equipe_nom);
			htp.tableData(rec_part.gene_pts_sprint);
		htp.tableRowClose;
		htp.tableRowOpen;
		htp.tableRowClose;
    fetch parts into rec_part;
	END LOOP;
	htp.tableClose;
  EXCEPTION
  when others THEN
    null;
  END UI_AFF_CLASS_SPRINT;
  
  
  PROCEDURE UI_CLASSEMENTS IS
  BEGIN
  UI_COMMUN.UI_HEAD;
	UI_COMMUN.UI_HEADER;
	UI_COMMUN.UI_MAIN_OPEN;
		htp.print('<h3>Classement général</h3>');
		UI_RESULTAT.UI_AFF_CLASS_GENE(5,db_commun.getLastEtape);
		htp.print('<div class="w80 center txtright"><a href="ui_resultat.ui_class_gene_complet?n_etape='||db_commun.getLastEtape||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement du meilleur grimpeur</h3>');
		UI_RESULTAT.UI_AFF_CLASS_MONT(5,db_commun.getLastEtape);
		htp.print('<div class="w80 center txtright"><a href="ui_resultat.ui_class_mont_complet?n_etape='||db_commun.getLastEtape||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement du meilleur sprinteur</h3>');
		UI_RESULTAT.UI_AFF_CLASS_SPRINT(5,db_commun.getLastEtape);
		htp.print('<div class="w80 center txtright"><a href="ui_resultat.ui_class_sprint_complet?n_etape='||db_commun.getLastEtape||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement du meilleur jeune</h3>');
		UI_RESULTAT.UI_AFF_CLASS_JEUNE(5,db_commun.getLastEtape);
		htp.print('<div class="w80 center txtright"><a href="ui_resultat.ui_class_jeune_complet?n_etape='||db_commun.getLastEtape||'">Afficher classement complet</a></div>');
		htp.print('<h3>Classement équipe</h3>');
		UI_RESULTAT.UI_AFF_CLASS_EQUI(5,db_commun.getLastEtape);
		htp.print('<div class="w80 center txtright"><a href="ui_resultat.ui_class_equipe_complet?n_etape='||db_commun.getLastEtape||'">Afficher classement complet</a></div>');
    UI_COMMUN.UI_MAIN_CLOSE;
    UI_COMMUN.UI_FOOTER;
    	EXCEPTION
		when others THEN
			null;
  END UI_CLASSEMENTS;
  
  
  PROCEDURE UI_CLASS_EQUIPE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
  BEGIN
	UI_COMMUN.UI_HEAD;
		UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
			htp.print('<h3>Classement équipe à l''étape '||n_etape||'</h3>');
			UI_RESULTAT.UI_AFF_CLASS_EQUI(nb_ligne,n_etape);
		UI_COMMUN.UI_MAIN_CLOSE;
		UI_COMMUN.UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_EQUIPE_COMPLET;
  
    PROCEDURE UI_CLASS_ETAPE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default ui_utils.getSelectedEtape) IS
  BEGIN
	UI_COMMUN.UI_HEAD;
		UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
      htp.print('<div class="row">
      <div class="col"><h3>Classement de l''étape '||n_etape||'</h3></div>
      <div class="col w20">'); 
				UI_COMMUN.UI_SELECT_ETAPE(n_etape);       
      htp.print('</div></div>');
			UI_RESULTAT.UI_AFF_CLASS_ETAPE(nb_ligne,n_etape);
		UI_COMMUN.UI_MAIN_CLOSE;
		UI_COMMUN.UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_ETAPE_COMPLET;
  
      PROCEDURE UI_CLASS_GENE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
  BEGIN
	UI_COMMUN.UI_HEAD;
		UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
			htp.print('<h3>Classement général à l''étape ' ||n_etape||'</h3>');
			UI_RESULTAT.UI_AFF_CLASS_GENE(nb_ligne,n_etape);
		UI_COMMUN.UI_MAIN_CLOSE;
		UI_COMMUN.UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_GENE_COMPLET;
  
        PROCEDURE UI_CLASS_JEUNE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
  BEGIN
	UI_COMMUN.UI_HEAD;
		UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
			htp.print('<h3>Classement du meilleur jeune à l''étape '||n_etape||'</h3>');
			UI_RESULTAT.UI_AFF_CLASS_JEUNE(nb_ligne,n_etape);
		UI_COMMUN.UI_MAIN_CLOSE;
		UI_COMMUN.UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_JEUNE_COMPLET;

  
         PROCEDURE UI_CLASS_MONT_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
  BEGIN
	UI_COMMUN.UI_HEAD;
		UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
			htp.print('<h3>Classement du meilleur grimpeur à l''étape '||n_etape||'</h3>');
			UI_RESULTAT.UI_AFF_CLASS_MONT(nb_ligne,n_etape);
		UI_COMMUN.UI_MAIN_CLOSE;
		UI_COMMUN.UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_MONT_COMPLET;
  
    PROCEDURE UI_CLASS_SPRINT_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape) IS
    BEGIN
    UI_COMMUN.UI_HEAD;
		UI_COMMUN.UI_HEADER;
		UI_COMMUN.UI_MAIN_OPEN;
			htp.print('<h3>Classement du meilleur sprinteur à l''étape '||n_etape||'</h3>');
			UI_RESULTAT.UI_AFF_CLASS_SPRINT(nb_ligne,n_etape);
		UI_COMMUN.UI_MAIN_CLOSE;
		UI_COMMUN.UI_FOOTER;
	EXCEPTION
		when others THEN
		null;
END UI_CLASS_SPRINT_COMPLET;

END UI_RESULTAT;

/
