
--INSCRIRE UNE EQUIPE A UN TOUR
CREATE OR REPLACE TRIGGER ti_equipe
BEFORE INSERT ON equipe
FOR EACH ROW
BEGIN
	 SELECT pays_nom INTO :new.equipe_pays FROM pays WHERE pays_num = pays_num;
	 SELECT COUNT(*) INTO :new.equipe_num FROM EQUIPE WHERE tour_annee = tour_annee;
	 
	:new.equipe_num := :new.equipe_num + 1;
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_equipe;

--INSCRIRE UN PARTICIPANT A UN TOUR
CREATE OR REPLACE TRIGGER ti_participant
BEFORE INSERT ON participant
FOR EACH ROW
DECLARE
	r_cycliste cycliste%ROWTYPE;
BEGIN
	SELECT * INTO r_cycliste FROM cycliste WHERE cycliste_num = cycliste_num;
	:new.cycliste_nom = r_cycliste.cycliste_nom;
	:new.cycliste_prenom = r_cycliste.cycliste_prenom;
	:new.cycliste_daten = r_cycliste.cycliste_daten
	
	SELECT equipe_nom INTO :new.equipe_nom FROM equipe WHERE tour_annee = tour_annee AND equipe_num = equipe_num;
	SELECT pays_nom INTO :new.cycliste_pays FROM pays WHERE pays_num = r_cycliste.pays_num;
	
	SELECT COUNT(*) INTO :new.part_num FROM participant WHERE equipe_num = equipe_num;
	:new.part_num := (:new.equipe_num - 1) * 10 + :new.part_num;

	EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_participant;

--AJOUTER UNE ETAPE
CREATE OR REPLACE TRIGGER ti_etape
BEFORE INSERT ON etape
FOR EACH ROW
BEGIN
	SELECT COUNT(*) INTO :new.etape_num FROM etape WHERE tour_annee = tour_annee;
	:new.etape_num := :new.etape_num + 1;
	
	IF :new.etape_num = 1 THEN
		UPDATE tour SET tour_dated = :new.etape_date WHERE tour_annee = tour_annee;
	END IF;
	
	UPDATE tour SET tour_datef = :new.etape_date WHERE tour_annee = tour_annee;
EXCEPTION
		WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ajouter_etape;

--AJOUTER POINT_PASSAGE
CREATE OR REPLACE TRIGGER ti_point_passage
BEFORE INSERT ON point_passage
FOR EACH ROW
BEGIN
	SELECT COUNT(*) INTO :new.pt_pass_num FROM point_passage WHERE tour_annee = tour_annee and etape_num = etape_num;
	:new.pt_pass_num := :new.pt_pass_num + 1;
	
	IF :new.ville_num is NOT NULL THEN
		SELECT ville_nom INTO :new.pt_pass_ville_nom FROM ville WHERE ville_num = :new.ville_num;
		IF :new.pt_pass_num = 1 THEN
			UPDATE etape SET 
				 ville_num_debuter = :new.ville_num
				,ville_nom_debuter = :new.pt_pass_ville_nom
			WHERE 
				tour_annee = :new.tour_annee
				AND etape_num = :new.etape_num;
		END IF;
		UPDATE etape SET
			 ville_num_finir = :new.ville_num
			,ville_nom_finir = :new.pt_pass_ville_nom
		WHERE
			tour_annee = :new.tour_annee
			AND etape_num = :new.etape_num;
	END IF;
	
	--Mettre à jour l'étape
	UPDATE etape SET
		etape_distance = :new.pt_pass_km_dep
	WHERE
		tour_annee = :new.tour_annee
		AND etape_num = :new.etape_num;
		
	--Update tous les points de passage de l'étape (km arrivée) (!!! A voir si ne pas mettre quand on 'valide l'étape!!!)
	UPDATE point_passage SET
		pt_pass_km_arr = :new.pt_pass_km_dep - pt_pass_km_dep
	WHERE
		tour_annee = tour_annee
		AND etape_num = :new.etape_num;
		
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_point_passage;

--AJOUTER ENREGISTREMENT DANS PASSER
CREATE OR REPLACE TRIGGER ti_passer
BEFORE INSERT ON passer
FOR EACH ROW
DECLARE
	v_point_last point_passage.pt_pass_num%TYPE;
BEGIN
	SELECT COUNT(*) INTO :new.pass_class FROM passer WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num;
	:new.pass_class := :new.pass_class + 1;

	--Si c'est le dernier point de passage, il faut insérer l'info dans la table terminer
	SELECT MAX(pt_pass_num) INTO v_point_last FROM POINT_PASSAGE WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num;
	IF v_point_last = :new.pt_pass_num THEN
		INSERT INTO terminer_etape (tour_annee, part_num, etape_num, etape_tps, etape_class)
		VALUES (:new.tour_annee, :new.part_num, :new.etape_num, :new.pass_tps, :new.pass_class);
	END IF;
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_passer;

	
--AJOUTER ENREGISTREMENT DANS TERMINER_ETAPE
CREATE OR REPLACE TRIGGER ti_terminer_etape
BEFORE INSERT ON terminer_etape
FOR EACH ROW
DECLARE
	v_points_mont NUMBER := 0;
	v_points_sprint NUMBER := 0;
	v_bareme_pts bareme.bareme_pts%TYPE;
	v_maillot_couleur categorie.maillot_couleur%TYPE;
	r_participant participant%ROWTYPE;
  
  CURSOR c_passer_point IS
	SELECT * FROM passer pa INNER JOIN point_passage po ON pa.pt_pass_num = po.pt_pass_num WHERE pa.tour_annee = :new.tour_annee AND pa.etape_num = :new.etape_num AND pa.part_num = :new.part_num ORDER BY pa.pt_pass_num;
  r_passer_point c_passer_point%ROWTYPE;

BEGIN
	SELECT * INTO r_participant FROM participant WHERE part_num = :new.part_num;
	:new.cycliste_nom := r_participant.cycliste_nom;
	:new.cycliste_prenom := r_participant.cycliste_prenom;
	:new.cycliste_pays := r_participant.cycliste_pays;
	:new.cycliste_daten := r_participant.cycliste_daten;
	:new.equipe_nom := r_participant.equipe_nom;
  
	OPEN c_passer_point;
	LOOP
		FETCH c_passer_point INTO r_passer_point;
		EXIT WHEN c_passer_point%NOTFOUND;
		IF r_passer_point.cat_num IS NOT NULL THEN
       
      BEGIN
				SELECT c.maillot_couleur, b.bareme_pts INTO v_maillot_couleur, v_bareme_pts FROM bareme b INNER JOIN categorie c ON b.cat_num = c.cat_num WHERE b.cat_num = r_passer_point.cat_num AND b.bareme_place = r_passer_point.pass_class;
      EXCEPTION
    			WHEN no_data_found THEN 
    				v_maillot_couleur := NULL;
         		v_bareme_pts := 0;
      END;
  
			IF v_maillot_couleur = 'pois' THEN
				v_points_mont := v_points_mont + v_bareme_pts;
    	ELSIF v_maillot_couleur = 'vert' THEN
				v_points_sprint := v_points_sprint + v_bareme_pts;
			END IF;
      
		END IF;
    
	END LOOP;
	CLOSE c_passer_point;
  
  :new.etape_pts_mont := v_points_mont;
  :new.etape_pts_sprint := v_points_sprint;
  
  :new.gene_tps := r_participant.gene_tps + :new.etape_tps;
  :new.gene_pts_mont := :r_participant.gene_pts_mont  + :new.etape_pts_mont;
  :new.gene_pts_mont := :r_participant.gene_pts_mont  + :new.etape_pts_sprint;
  
  --On doit mettre à jour les classements : appel d'une procédure  
  
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('Erreur');
END terminer_etape;

CREATE OR REPLACE PROCEDURE maj_classement (	--Mettre à jour les données dans la table participant par rapport aux résultats courants
   v_tour_annee tour.tour_annee%TYPE
  ,v_etape_num etape.etape_num%TYPE
  ,v_maillot_couleur categorie.maillot_couleur%TYPE
) AS
type ref_cursor is REF CURSOR;
c_terminer_etape ref_cursor;
r_part_num participant.part_num%TYPE;
v_etape_max_num etape.etape_num%TYPE;
v_index NUMBER := 1;
BEGIN
  --Are We updating the current stage
    SELECT MAX(etape_num) INTO v_etape_max_num FROM terminer_etape WHERE tour_annee = v_tour_annee;

  --We first get the right cursor depending on which ranking we want
  IF v_maillot_couleur = 'jaune' THEN
     OPEN c_terminer_etape FOR
     SELECT part_num FROM terminer_etape WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num ORDER BY gene_tps ASC;
	 IF v_etape_num = v_etape_max_num THEN
		UPDATE participant SET part_class_gene = NULL WHERE tour_annee = v_tour_annee;
	 END IF;
   ELSIF v_maillot_couleur = 'pois' THEN
     OPEN c_terminer_etape FOR
     SELECT part_num FROM participant WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num ORDER BY part_pts_mont DESC;
   ELSIF v_maillot_couleur = 'vert' THEN
     OPEN c_terminer_etape FOR
     SELECT part_num FROM participant WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num ORDER BY part_pts_sprint DESC;
   END IF;	
  
  LOOP
    FETCH c_terminer_etape INTO r_part_num;
    EXIT WHEN c_terminer_etape%NOTFOUND;
    
    IF v_maillot_couleur = 'jaune' THEN
      UPDATE terminer_etape SET gene_class = v_index WHERE tour_annee = v_tour_annee AND part_num = r_part_num AND etape_num = v_etape_num;
      IF v_etape_num = v_etape_max_num THEN
        UPDATE participant SET part_class_gene = v_index WHERE tour_annee = v_tour_annee AND part_num = r_part_num;
      END IF;
    ELSIF v_maillot_couleur = 'pois' THEN
      UPDATE terminer_etape SET gene_class_mont = v_index WHERE tour_annee = v_tour_annee AND part_num = r_part_num AND etape_num = v_etape_num;
      IF v_etape_num = v_etape_max_num THEN
        UPDATE participant SET part_class_mont = v_index WHERE tour_annee = v_tour_annee AND part_num = r_part_num;
      END IF;
    ELSIF v_maillot_couleur = 'vert' THEN
      UPDATE terminer_etape SET gene_class_sprint = v_index WHERE tour_annee = v_tour_annee AND part_num = r_part_num AND etape_num = v_etape_num;
      IF v_etape_num = v_etape_max_num THEN
        UPDATE participant SET part_class_sprint = v_index WHERE tour_annee = v_tour_annee AND part_num = r_part_num;
      END IF;
    END IF;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_terminer_etape;
  
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END maj_classement;

--AJOUTER ENREGISTREMENT DANS PORTER



