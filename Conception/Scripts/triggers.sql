
--INSCRIRE UNE EQUIPE A UN TOUR
CREATE OR REPLACE TRIGGER ti_equipe
BEFORE INSERT ON equipe
FOR EACH ROW
BEGIN
	 SELECT pays_nom INTO :new.equipe_pays FROM pays WHERE pays_num = :new.pays_num;
	 SELECT COUNT(*) INTO :new.equipe_num FROM EQUIPE WHERE tour_annee = :new.tour_annee;
	 
	:new.equipe_num := :new.equipe_num + 1;
	:new.equipe_tps_gene := 0;
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
	SELECT * INTO r_cycliste FROM cycliste WHERE cycliste_num = :new.cycliste_num;
	:new.cycliste_nom := r_cycliste.cycliste_nom;
	:new.cycliste_prenom := r_cycliste.cycliste_prenom;
	:new.cycliste_daten := r_cycliste.cycliste_daten;
	:new.part_tps_gene := 0;
	:new.part_pts_mont := 0;
	:new.part_pts_sprint := 0;
	
	SELECT equipe_nom INTO :new.equipe_nom FROM equipe WHERE tour_annee = :new.tour_annee AND equipe_num = :new.equipe_num;
	SELECT pays_nom INTO :new.cycliste_pays FROM pays WHERE pays_num = r_cycliste.pays_num;
	
	SELECT COUNT(*) INTO :new.part_num FROM participant WHERE tour_annee = :new.tour_annee AND equipe_num = :new.equipe_num;
	:new.part_num := (:new.equipe_num - 1) * 10 + :new.part_num + 1;

	EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_participant;


--AJOUTER UNE ETAPE
CREATE OR REPLACE TRIGGER ti_etape
BEFORE INSERT ON etape
FOR EACH ROW
BEGIN
	SELECT COUNT(*) INTO :new.etape_num FROM etape WHERE tour_annee = :new.tour_annee;
	:new.etape_num := :new.etape_num + 1;
	
	IF :new.ville_num_debuter IS NOT NULL THEN
		SELECT ville_nom INTO :new.ville_nom_debuter FROM ville WHERE ville_num = :new.ville_num_debuter;
	END IF;
	
	IF :new.ville_num_finir IS NOT NULL THEN
		SELECT ville_nom INTO :new.ville_nom_finir FROM ville WHERE ville_num = :new.ville_num_finir;
	END IF;
	
	IF :new.etape_num = 1 THEN
		UPDATE tour SET tour_dated = :new.etape_date WHERE tour_annee = :new.tour_annee;
	END IF;
	
	UPDATE tour SET tour_datef = :new.etape_date WHERE tour_annee = :new.tour_annee;
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
		tour_annee = :new.tour_annee
		AND etape_num = :new.etape_num;
		
	:new.pt_pass_km_arr := 0;
		
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END ti_point_passage;


--AJOUTER ENREGISTREMENT DANS PASSER
CREATE OR REPLACE TRIGGER ti_passer_before
BEFORE INSERT ON passer
FOR EACH ROW
DECLARE
  v_cat_num categorie.cat_num%TYPE;
  v_maillot_couleur categorie.maillot_couleur%TYPE;
  v_bareme_pts bareme.bareme_pts%TYPE;
  v_part_tps_gene participant.part_tps_gene%TYPE;
BEGIN
	SELECT COUNT(*) INTO :new.pass_class FROM passer WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num;
	:new.pass_class := :new.pass_class + 1;
	
	SELECT part_tps_gene INTO v_part_tps_gene FROM participant WHERE tour_annee = :new.tour_annee AND part_num = :new.part_num;
  
  --On récupere la catégorie du point de passage
  SELECT p.cat_num INTO v_cat_num FROM point_passage p WHERE p.tour_annee = :new.tour_annee AND p.etape_num = :new.etape_num AND p.pt_pass_num = :new.pt_pass_num;
  
  IF :new.pt_pass_num = 1 THEN
    INSERT INTO terminer_etape (tour_annee, part_num, etape_num, etape_class, etape_tps, etape_pts_mont, etape_pts_sprint, pt_pass_num)
    VALUES (:new.tour_annee, :new.part_num, :new.etape_num, :new.pass_class, :new.pass_tps, 0, 0, :new.pt_pass_num);
  ELSE
	UPDATE terminer_etape SET etape_class = :new.pass_class, etape_tps = :new.pass_tps, gene_tps = v_part_tps_gene + :new.pass_tps, pt_pass_num = :new.pt_pass_num
	WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND part_num = :new.part_num;
  END IF;

  --On récupère les points et la couleur du maillot pour mettre à jour terminer etape
  IF v_cat_num IS NOT NULL THEN
    BEGIN
      SELECT c.maillot_couleur, b.bareme_pts 
      INTO v_maillot_couleur ,v_bareme_pts
      FROM categorie c inner join bareme b ON c.cat_num = b.cat_num
      WHERE c.cat_num = v_cat_num AND b.bareme_place = :new.pass_class;
    EXCEPTION
      WHEN no_data_found THEN 
        v_maillot_couleur := NULL;
    END;
      
    IF v_maillot_couleur = 'pois' THEN
      UPDATE TERMINER_ETAPE SET etape_pts_mont = etape_pts_mont + v_bareme_pts, gene_pts_mont = gene_pts_mont + v_bareme_pts
      WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND part_num = :new.part_num;
    ELSIF v_maillot_couleur = 'vert' THEN
      UPDATE TERMINER_ETAPE SET etape_pts_sprint = etape_pts_sprint + v_bareme_pts, gene_pts_sprint = gene_pts_sprint + v_bareme_pts
      WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND part_num = :new.part_num;
    END IF;
  END IF;
END ti_passer_before;

--

CREATE OR REPLACE TRIGGER ti_passer_after
AFTER INSERT ON passer
FOR EACH ROW
DECLARE
  v_pt_pass_num_last point_passage.pt_pass_num%TYPE;
  v_num_part_equipe NUMBER;
  v_etape_equi_tps NUMBER;
  v_equipe_num equipe.equipe_num%TYPE;
  v_still_running NUMBER;
  CURSOR c_terminer_etape IS
  SELECT * FROM terminer_etape WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num;
  r_terminer_etape c_terminer_etape%ROWTYPE;
  CURSOR c_terminer_etape_equipe IS
  SELECT * FROM terminer_etape_equipe WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num;
  r_terminer_etape_equipe c_terminer_etape_equipe%ROWTYPE;
BEGIN
	
	--Si le participant est arrivé
	SELECT MAX(pt_pass_num) INTO v_pt_pass_num_last FROM point_passage WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num;
	IF :new.pt_pass_num = v_pt_pass_num_last THEN
		--et qu'il sont exactement trois de la même équipe a avoir passé la ligne, on peut mettre à jour le temps équipe
		SELECT pa.equipe_num, COUNT(*), SUM(te.etape_tps) INTO v_equipe_num, v_num_part_equipe, v_etape_equi_tps FROM terminer_etape te INNER JOIN participant pa ON te.tour_annee = pa.tour_annee AND te.part_num = pa.part_num
		WHERE te.tour_annee = :new.tour_annee AND te.etape_num = :new.etape_num
		AND te.pt_pass_num = v_pt_pass_num_last AND pa.equipe_num = (
			SELECT equipe_num FROM participant WHERE tour_annee = :new.tour_annee AND part_num = :new.part_num
		)
		GROUP BY pa.equipe_num;
		--On insère dans la table terminer_etape_equipe
		IF v_num_part_equipe = 3 THEN
			INSERT INTO terminer_etape_equipe (tour_annee, equipe_num, etape_num, etape_equi_tps)
			VALUES (:new.tour_annee, v_equipe_num, :new.etape_num, v_etape_equi_tps);
		END IF;
  END IF;
  
  update_classements(:new.tour_annee, :new.etape_num);
  
  --Si tous les participants au départ de l'étape n'ont pas abandonné, on met à jour les données dans participant
  SELECT COUNT(te.part_num) INTO v_still_running
  FROM terminer_etape te INNER JOIN participant p
  ON te.tour_annee = p.tour_annee AND te.part_num = p.part_num
  WHERE te.pt_pass_num < (
	SELECT MAX(pt_pass_num) 
	FROM point_passage
	WHERE tour_annee = :new.tour_annee
	AND etape_num = :new.etape_num
  )
  AND (p.etape_num IS NULL OR p.etape_num <= 1)    --on enlève ceux qui sont déja éliminés
  AND te.tour_annee = :new.tour_annee
  AND te.etape_num = :new.etape_num;
  
  IF v_still_running = 0 THEN
    --Mise à jour des écart
    UPDATE terminer_etape SET 
       etape_tps_ecart = etape_tps - (SELECT MIN(etape_tps) FROM terminer_etape WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num)
      ,gene_tps_ecart = gene_tps - (SELECT MIN(gene_tps) FROM terminer_etape WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num)
    WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num;
    
    OPEN c_terminer_etape;
    LOOP
      FETCH c_terminer_etape INTO r_terminer_etape;
      EXIT WHEN c_terminer_etape%NOTFOUND;
        
      UPDATE participant SET 
         part_tps_gene = r_terminer_etape.gene_tps
        ,part_class_gene = r_terminer_etape.gene_class
        ,part_pts_mont = r_terminer_etape.gene_pts_mont
        ,part_class_mont = r_terminer_etape.gene_class_mont
        ,part_pts_sprint = r_terminer_etape.gene_pts_sprint
        ,part_class_sprint = r_terminer_etape.gene_class_sprint
        ,part_tps_ecart = r_terminer_etape.gene_tps_ecart
      WHERE tour_annee = :new.tour_annee
      AND part_num = r_terminer_etape.part_num;
    END LOOP;
    CLOSE c_terminer_etape;
    
    OPEN c_terminer_etape_equipe;
    UPDATE equipe SET equipe_class_gene = NULL WHERE tour_annee = :new.tour_annee;
    LOOP
      FETCH c_terminer_etape_equipe INTO r_terminer_etape_equipe;
      EXIT WHEN c_terminer_etape_equipe%NOTFOUND;
      
      UPDATE equipe SET
         equipe_tps_gene = r_terminer_etape_equipe.gene_equi_tps
        ,equipe_class_gene = r_terminer_etape_equipe.gene_equi_class
      WHERE
        tour_annee = r_terminer_etape_equipe.tour_annee
        AND equipe_num = r_terminer_etape_equipe.equipe_num;
    END LOOP;
  END IF;
END ti_passer_after;


--METTRE A JOUR LES CLASSEMENTS DANS TERMINER_ETAPE
CREATE OR REPLACE PROCEDURE update_classements (
   v_tour_annee tour.tour_annee%TYPE
  ,v_etape_num etape.etape_num%TYPE
) IS
  CURSOR c_etape_tps IS
    SELECT part_num
    FROM terminer_etape
    WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num
    ORDER BY pt_pass_num DESC, etape_tps ASC;
    
  CURSOR c_gene_tps IS
    SELECT part_num 
    FROM terminer_etape 
    WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num
    ORDER BY gene_tps;

  CURSOR c_gene_mont IS
    SELECT part_num
    FROM terminer_etape
    WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num
    ORDER BY gene_pts_mont DESC;
    
  CURSOR c_gene_sprint IS
    SELECT part_num
    FROM terminer_etape
    WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num
    ORDER BY gene_pts_sprint DESC;
	
  CURSOR c_etape_equi_tps IS
	SELECT equipe_num
	FROM terminer_etape_equipe
	WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num
    ORDER BY etape_equi_tps ASC;
	
  CURSOR c_gene_equi_tps IS
	SELECT equipe_num
	FROM terminer_etape_equipe
	WHERE tour_annee = v_tour_annee AND etape_num = v_etape_num
    ORDER BY gene_equi_tps ASC;
    
  v_part_num participant.part_num%TYPE;
  v_equipe_num equipe.equipe_num%TYPE;
  v_index NUMBER;
BEGIN
  --Classement étape
  v_index := 1;
  OPEN c_etape_tps;
  LOOP
    FETCH c_etape_tps INTO v_part_num;
    EXIT WHEN c_etape_tps%NOTFOUND;
    
    UPDATE terminer_etape SET etape_class = v_index WHERE tour_annee = v_tour_annee AND part_num = v_part_num AND etape_num = v_etape_num;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_etape_tps;
  
  --Classement général
  v_index := 1;
  OPEN c_gene_tps;
  LOOP
    FETCH c_gene_tps INTO v_part_num;
    EXIT WHEN c_gene_tps%NOTFOUND;
    
    UPDATE terminer_etape SET gene_class = v_index WHERE tour_annee = v_tour_annee AND part_num = v_part_num AND etape_num = v_etape_num;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_gene_tps;
  
  --Classement montagne
  v_index := 1;
  OPEN c_gene_mont;
  LOOP
    FETCH c_gene_mont INTO v_part_num;
    EXIT WHEN c_gene_mont%NOTFOUND;
    
    UPDATE terminer_etape SET gene_class_mont = v_index WHERE tour_annee = v_tour_annee AND part_num = v_part_num AND etape_num = v_etape_num;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_gene_mont;

  --Classement sprint
  v_index := 1;
  OPEN c_gene_sprint;
  LOOP
    FETCH c_gene_sprint INTO v_part_num;
    EXIT WHEN c_gene_sprint%NOTFOUND;
    
    UPDATE terminer_etape SET gene_class_sprint = v_index WHERE tour_annee = v_tour_annee AND part_num = v_part_num AND etape_num = v_etape_num;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_gene_sprint;
  
   --Classement equipe étape
  v_index := 1;
  OPEN c_etape_equi_tps;
  LOOP
    FETCH c_etape_equi_tps INTO v_equipe_num;
    EXIT WHEN c_etape_equi_tps%NOTFOUND;
    
    UPDATE terminer_etape_equipe SET etape_equi_class = v_index WHERE tour_annee = v_tour_annee AND equipe_num = v_equipe_num AND etape_num = v_etape_num;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_etape_equi_tps;
  
  --Classement equipe général
  v_index := 1;
  OPEN c_gene_equi_tps;
  LOOP
    FETCH c_gene_equi_tps INTO v_equipe_num;
    EXIT WHEN c_gene_equi_tps%NOTFOUND;
    
    UPDATE terminer_etape_equipe SET gene_equi_class = v_index WHERE tour_annee = v_tour_annee AND equipe_num = v_equipe_num AND etape_num = v_etape_num;
    v_index := v_index + 1;
  END LOOP;
  CLOSE c_gene_equi_tps;
  
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Erreur');
END update_classements;


--AJOUTER ENREGISTREMENT DANS TERMINER_ETAPE
CREATE OR REPLACE TRIGGER ti_terminer_etape
BEFORE INSERT ON terminer_etape
FOR EACH ROW
DECLARE
	r_participant participant%ROWTYPE;

BEGIN
	SELECT * INTO r_participant FROM participant WHERE tour_annee = :new.tour_annee AND part_num = :new.part_num;
  
	:new.cycliste_nom := r_participant.cycliste_nom;
	:new.cycliste_prenom := r_participant.cycliste_prenom;
	:new.cycliste_pays := r_participant.cycliste_pays;
	:new.cycliste_daten := r_participant.cycliste_daten;
	:new.equipe_nom := r_participant.equipe_nom;
	:new.gene_tps := r_participant.part_tps_gene;
	:new.gene_pts_mont := r_participant.part_pts_mont;
	:new.gene_pts_sprint := r_participant.part_pts_sprint;
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('Erreur');
END terminer_etape;


--AJOUTER ENREGISTREMENT DANS TERMINER_ETAPE_EQUIPE
CREATE OR REPLACE TRIGGER ti_terminer_etape_equipe
BEFORE INSERT ON terminer_etape_equipe
FOR EACH ROW
DECLARE
	r_equipe equipe%ROWTYPE;

BEGIN
	SELECT * INTO r_equipe FROM equipe WHERE tour_annee = :new.tour_annee AND equipe_num = :new.equipe_num;
	
	:new.equipe_nom := r_equipe.equipe_nom;
	:new.equipe_pays := r_equipe.equipe_pays;
	:new.gene_equi_tps := r_equipe.equipe_tps_gene + :new.etape_equi_tps;
EXCEPTION
  WHEN no_data_found THEN dbms_output.put_line('Erreur');
END terminer_etape_equipe;
	