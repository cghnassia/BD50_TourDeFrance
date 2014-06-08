--------------------------------------------------------
--  DDL for Procedure INSCRIRE_PARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."INSCRIRE_PARTICIPANT" (
   tour_annee tour.tour_annee%TYPE
  ,cycliste_num cycliste.cycliste_num%TYPE
  ,equipe_num equipe.equipe_num%TYPE
  ,part_poids participant.part_poids%TYPE
  ,part_taille participant.part_taille%TYPE
)
IS
  r_cycliste CYCLISTE%ROWTYPE;
  r_equipe equipe%ROWTYPE;
  r_pays pays%ROWTYPE;
  v_dossard NUMBER;
BEGIN
  SELECT * INTO r_cycliste FROM cycliste WHERE cycliste_num = cycliste_num;
  SELECT * INTO r_equipe FROM equipe WHERE equipe_num = equipe_num;
  SELECT * INTO r_pays FROM pays WHERE pays_num = r_cycliste.pays_num;
  SELECT COUNT(*) INTO v_dossard FROM participant WHERE equipe_num = equipe_num group by equipe_num;
  INSERT INTO participant (tour_annee, part_num, cycliste_nom, cycliste_prenom, cycliste_daten, cycliste_pays, part_poids, part_taille, equipe_nom, equipe_num, cycliste_num)
  VALUES (tour_annee, v_dossard + 1, r_cycliste.cycliste_nom, r_cycliste.cycliste_prenom, r_cycliste.cycliste_daten, r_pays.pays_nom, part_poids, part_taille, r_equipe.equipe_nom, r_equipe.equipe_num, cycliste_num);
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('Pas de ligne');
END inscrire_participant;

/
