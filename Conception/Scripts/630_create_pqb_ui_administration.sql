--------------------------------------------------------
--  Fichier créé - jeudi-juin-19-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body UI_ADMINISTRATION
--------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_ADMINISTRATION" AS

PROCEDURE UI_GESTION IS
  BEGIN
       UI_COMMUN.UI_HEAD;
       UI_ADMINISTRATION.UI_HEADER_ADMIN;
       UI_COMMUN.UI_MAIN_OPEN;

       IF(ui_utils.existCookie('profil')) THEN


       IF(ui_utils.getCookieValue('profil')='administrateur') THEN
          htp.anchor ('ui_administration.ui_form_passer','Gestion des points de passage');
        END IF;

        IF(ui_utils.getCookieValue('profil')='cpp') THEN
        htp.anchor ('#','Gestion point de passage');
        END IF;

        IF(ui_utils.getCookieValue('profil')='cc') THEN
        htp.anchor ('#','Gestion de la course');
        END IF;

        ELSE

        htp.print('Vous êtes arrivé ici par erreur.');
        htp.anchor ('ui_commun.ui_home','Accueil');

        END IF;
        UI_COMMUN.UI_MAIN_CLOSE;
        UI_COMMUN.UI_FOOTER;
  END UI_GESTION;

   PROCEDURE UI_HEADER_ADMIN  IS
  v_tour tour%ROWTYPE := db_commun.getTour(ui_utils.getSelectedTour);
  BEGIN
  UI_COMMUN.UI_MAIN_OPEN;
  htp.print('
    <div class="autogrid3">
      <div><h1>Administration du Tour de France ' || ui_utils.getSelectedTour || '</h1></div>
      <div>' || v_tour.tour_edition || 'e édition </br> ' || v_tour.tour_dated || ' - ' || v_tour.tour_datef ||' </div>
      <div>');
      UI_COMMUN.UI_SELECT_TOUR(ui_utils.getSelectedTour);
      ui_authentification.cadreAuth;
  htp.print('</div>
    </div>
    <div id="navigationAdmin">
      <ul>
        <li class="pas inbl"><a href="ui_commun.ui_home">Accueil</a></li>
        <li class="pas inbl"><a href="ui_administration.ui_form_passer">Saisie résultats</a></li>
      </ul>
    </div>
  </header>');
END UI_HEADER_ADMIN;

PROCEDURE              "UI_FORM_PASSER" (
v_etape_num etape.etape_num%TYPE default 1,
v_pt_pass_num point_passage.pt_pass_num%TYPE default 1,
v_part_num participant.part_num%TYPE default 0,
v_temps VARCHAR2 default '',
v_code NUMBER default 0,
v_message VARCHAR2 default NULL
) IS
BEGIN
  UI_COMMUN.UI_HEAD;
  UI_ADMINISTRATION.UI_HEADER_ADMIN;
  UI_COMMUN.UI_MAIN_OPEN;

  htp.print('<h1>Ajout d'' un résultat pour le tour ' || ui_utils.getSelectedTour || '</h1>');

  IF v_code = -1 THEN
    htp.print('Erreur : <ul>' || v_message || '</ul>');
  ELSIF v_code = 1 THEN
    htp.print(v_message);
  END IF;

  htp.formOpen(owa_util.get_owa_service_path || 'ui_administration.ui_execform_passer', 'GET', cattributes => 'id="form_passer"');
  ui_aff_select_etapes(v_etape_num);
  ui_aff_select_point_passages(v_etape_num, v_pt_pass_num);
  ui_aff_select_participants(v_etape_num, v_pt_pass_num, v_part_num);

  htp.print('
  <div>
    <input name="button_submit" type="submit" value="Envoyer">
  </div>
  ');
  htp.formClose;

  ui_administration.ui_aff_resultats_etape(v_etape_num, ui_administration.part_num_selected);

  UI_COMMUN.UI_MAIN_CLOSE;
  UI_COMMUN.UI_FOOTER;
EXCEPTION
  WHEN OTHERS THEN htp.print('Erreur');
END UI_FORM_PASSER;


PROCEDURE UI_EXECFORM_PASSER (
  select_etape etape.etape_num%TYPE default 1,
  select_passage point_passage.pt_pass_num%TYPE default 1,
  select_participant participant.part_num%TYPE default 0,
  text_temps VARCHAR2 DEFAULT '',
  button_submit VARCHAR2 DEFAULT NULL
) IS
v_code NUMBER := 0;
v_message VARCHAR2(255) := '';
BEGIN

  IF button_submit IS NOT NULL THEN
    IF select_etape = 0 THEN
      v_message  := v_message + '<li>Choisissez une étape</li>';
      v_code := -1;
    END IF;

    IF select_passage = 0 THEN
      v_message  := v_message + '<li>Choisissez un point de passage</li>';
      v_code := -1;
    END IF;

    IF to_number(text_temps) < 0 THEN
       v_message  := v_message + '<li>Saisissez un temps valide</li>';
       v_code := -1;
    END IF;

   IF v_code = 0 THEN
      BEGIN
        INSERT INTO passer(tour_annee, etape_num, pt_pass_num, part_num, pass_tps) VALUES (ui_utils.getSelectedTour, select_etape, select_passage, select_participant, text_temps);
        v_message := 'Les données ont été insérées avec succès';
        v_code := 1;
      EXCEPTION
        WHEN OTHERS THEN
          v_message := 'Erreur lors de l''insertion de données; vérifier la cohérence';
          v_code := -1;
      END;
    END IF;
  END IF;
  ui_administration.ui_form_passer(select_etape, select_passage, select_participant, text_temps, v_code, v_message);
EXCEPTION
  WHEN OTHERS THEN htp.print(sqlerrm);
END UI_EXECFORM_PASSER;


PROCEDURE              "UI_AFF_SELECT_POINT_PASSAGES" (
  v_etape_num etape.etape_num%TYPE default 1,
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 1
)
IS
CURSOR c_point_passage IS
SELECT * FROM point_passage WHERE tour_annee=ui_utils.getSelectedTour AND etape_num=v_etape_num ORDER BY pt_pass_num ASC;
r_point_passage c_point_passage%ROWTYPE;
BEGIN

  htp.print('</br><div class="line">
              <div class="inbl w20"> Point de passage</div>
              <div class="inbl"><select  name="select_passage" onchange="document.getElementById(''form_passer'').submit()" style="width:300px;"></div>
              </div>');
  OPEN c_point_passage;
  LOOP
    FETCH c_point_passage INTO r_point_passage;
    EXIT WHEN c_point_passage%NOTFOUND;

    htp.print('"<option value="' || r_point_passage.pt_pass_num || '"');

    IF r_point_passage.pt_pass_num = v_pt_pass_num THEN
      htp.print(' selected="selected"');
    END IF;

    htp.print('> Numéro ' || r_point_passage.pt_pass_num || ' (' || r_point_passage.pt_pass_nom ||')</option>');

  END LOOP;
  CLOSE c_point_passage;
  htp.print('</select></div>');
END UI_AFF_SELECT_POINT_PASSAGES;


PROCEDURE              "UI_AFF_SELECT_PARTICIPANTS" (
  v_etape_num etape.etape_num%TYPE default 1,
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 1,
  v_part_num participant.part_num%TYPE default 0
)
IS
  c_participant SYS_REFCURSOR;
  r_participant participant%ROWTYPE;
  v_temps NUMBER := 0;
  v_part_num_selected participant.part_num%TYPE := 0;
BEGIN
  htp.print('</br><div class="line">
              <div class="inbl w20"> Participant</div>
              <div class="inbl"><select name="select_participant" onchange="document.getElementById(''form_passer'').submit()" style="width:300px;"></div>
              </div>');
  IF v_pt_pass_num > 1 THEN
    OPEN c_participant FOR '
      SELECT pr.* FROM participant pr INNER JOIN PASSER ps
      ON pr.tour_annee = ps.tour_annee AND pr.part_num = ps.part_num
      WHERE pr.tour_annee= ' || ui_utils.getSelectedTour || ' AND ps.etape_num = ' || v_etape_num || '
      AND ps.pt_pass_num = ' || (v_pt_pass_num - 1) || '
      AND pr.etape_num IS NULL
      AND pr.part_num NOT IN (
        SELECT part_num FROM passer WHERE tour_annee = ' || ui_utils.getSelectedTour || ' AND etape_num = ' || v_etape_num || ' AND pt_pass_num =' || v_pt_pass_num || ')
      ORDER BY pr.part_num ASC';
   ELSIF v_etape_num > 1 THEN
    OPEN c_participant FOR
      'SELECT pr.* FROM participant pr INNER JOIN PASSER ps
      ON pr.tour_annee = ps.tour_annee AND pr.part_num = ps.part_num
      WHERE ps.tour_annee= ' || ui_utils.getSelectedTour || ' AND ps.etape_num= ' || (v_etape_num - 1) || '
      AND ps.pt_pass_num = (
        SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = ' || ui_utils.getSelectedTour || ' AND etape_num = ' || (v_etape_num - 1) || '
      )
      AND pr.etape_num IS NULL
      AND pr.part_num NOT IN (
        SELECT part_num FROM passer WHERE tour_annee = ' || ui_utils.getSelectedTour || ' AND etape_num = ' || v_etape_num || ' AND pt_pass_num =' || v_pt_pass_num || ')
      ORDER BY pr.part_num ASC';
  ELSE
    OPEN c_participant FOR
      'SELECT * FROM participant WHERE tour_annee= ' || ui_utils.getSelectedTour || ' AND etape_num IS NULL
      AND part_num NOT IN (
        SELECT part_num FROM passer WHERE tour_annee = ' || ui_utils.getSelectedTour || ' AND etape_num = ' || v_etape_num || ' AND pt_pass_num =' || v_pt_pass_num || ')
      ORDER BY part_num ASC';
  END IF;

  LOOP
    FETCH c_participant INTO r_participant;
    EXIT WHEN c_participant%NOTFOUND;

      htp.print('"<option value="' || r_participant.part_num || '"');

      IF v_part_num_selected = 0 THEN
        v_part_num_selected := r_participant.part_num;
        ui_administration.part_num_selected := v_part_num_selected;
      ELSIF v_part_num = r_participant.part_num THEN
        htp.print(' selected="selected"');
        ui_administration.part_num_selected := v_part_num_selected;
        v_part_num_selected := v_part_num;
      END IF;

      htp.print('> Dossard ' || r_participant.part_num || ' (' || r_participant.cycliste_prenom || ' ' || r_participant.cycliste_nom || ')</option>');

     END LOOP;
    CLOSE c_participant;
  htp.print('</select></div>');

  IF v_pt_pass_num > 1 AND v_part_num > 0 THEN
    BEGIN
      SELECT pass_tps INTO v_temps FROM passer WHERE tour_annee= ui_utils.getSelectedTour AND etape_num = v_etape_num AND pt_pass_num = (v_pt_pass_num - 1) AND part_num = v_part_num_selected;
    EXCEPTION
      WHEN OTHERS THEN
    v_temps := 0;
    END;
  END IF;

  htp.print('<div class="line">
              <div class="inbl w20">Temps</div>
              <div class="inbl"><input type="text" name="text_temps" value="' || v_temps || '" style="width:300px;" /></div>
              </div></br>');

END UI_AFF_SELECT_PARTICIPANTS;

PROCEDURE              "UI_AFF_SELECT_ETAPES" (
  v_etape_num etape.etape_num%TYPE default 1
) IS
CURSOR c_etape IS
SELECT * FROM etape WHERE tour_annee=ui_utils.getSelectedTour ORDER BY etape_num ASC;
r_etape c_etape%ROWTYPE;
BEGIN
  htp.print('<div class="line">
                <div class="inbl w20">Etape</div>
                <div class="inbl"><select name="select_etape" onchange="document.getElementById(''form_passer'').submit()" style="width:300px;"></div>
                </div>');

  OPEN c_etape;
  LOOP
    FETCH c_etape INTO r_etape;
    EXIT WHEN c_etape%NOTFOUND;

    htp.print('"<option value="' || r_etape.etape_num || '"');

    IF v_etape_num = r_etape.etape_num THEN
      htp.print(' selected="selected"');
    END IF;

    htp.print('> Etape ' || r_etape.etape_num || ' (' || r_etape.etape_nom ||')</option>');

  END LOOP;
  CLOSE c_etape;
  htp.print('</select></div>');

END UI_AFF_SELECT_ETAPES;

PROCEDURE  UI_AFF_RESULTATS_ETAPE(
  n_etape_num etape.etape_num%TYPE, 
  n_part_num participant.part_num%TYPE
) IS
  c_participant db_param_commun.ref_cur;
  r_participant participant%ROWTYPE;
  v_array_class db_param_commun.array_class_t;
  v_array_temps db_param_commun.array_temps_t;
  v_temps_wrapped VARCHAR(50);
  pointPassageCount NUMBER;
BEGIN
  htp.tableOpen(cattributes => 'class="normalTab"');
  htp.tableCaption('Résultats par point de passage');

  htp.tableRowOpen;
  htp.tableHeader('N°');
  htp.tableHeader('S');


  pointPassageCount := db_course.getPointPassageCount(ui_utils.getselectedtour, n_etape_num);

  FOR i in 1 .. pointPassageCount LOOP
    htp.tableHeader(i);
  END LOOP;
  htp.tableRowClose;

  c_participant := db_inscription.getPartAll(ui_utils.getselectedtour);
  LOOP
    FETCH c_participant INTO r_participant;
    EXIT WHEN c_participant%NOTFOUND;

    v_array_class := db_resultat.getClassPointsPassage(ui_utils.getselectedtour, n_etape_num, r_participant.part_num);
    v_array_temps := db_resultat.getTempsPointsPassage(ui_utils.getselectedtour, n_etape_num, r_participant.part_num);

    IF n_part_num = r_participant.part_num THEN
      htp.tableRowOpen(cattributes => 'class="rowP"');
    ELSE
      htp.tableRowOpen;
    END IF;

      htp.tableData(r_participant.part_num);


    IF r_participant.etape_num IS NOT NULL THEN
      htp.tableData('Abn');
    ELSIF v_array_class(pointPassageCount) != '-' THEN
      htp.tableData('Arr');
    ELSE
      htp.tableData('Cou');
    END IF;

      FOR i in 1 .. pointPassageCount LOOP

        v_temps_wrapped := '<div class="tiny">' || v_array_temps(i) ||  '</div>';

        htp.tableData(v_array_class(i) || ' ' || v_temps_wrapped);
      END LOOP;

    htp.tableRowClose;

  END LOOP;

  htp.tableClose;

END UI_AFF_RESULTATS_ETAPE;


END UI_ADMINISTRATION;

/
