-- -----------------------------------------------------------------------------
--       GESTION DES INSCRIPTIONS
-- -----------------------------------------------------------------------------


-- CYCLISTE --
create or replace trigger TI_CYCLISTE
before insert on CYCLISTE 
for each row
begin
	if inserting then
	select seq_cycliste.nextval into :new.cycliste_num from dual;
	end if; 
end;
/

-- PAYS --
create or replace trigger TI_PAYS
before insert on PAYS 
for each row
begin
	if inserting then
	select seq_pays.nextval into :new.pays_num from dual;
	end if; 
end;
/

-- DIRECTEUR_SPORTIF --
create or replace trigger TI_DIRS
before insert on DIRECTEUR_SPORTIF
for each row
begin
	if inserting then
	select seq_dirs.nextval into :new.dirs_num from dual;
	end if; 
end;
/


-- EQUIPE --
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
/

-- PARTICIPANT --
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
/

-- -----------------------------------------------------------------------------
--       GESTION DE LA COURSE
-- -----------------------------------------------------------------------------


-- VILLE --
create or replace trigger TI_VILLE
before insert on VILLE 
for each row
begin
	if inserting then
	select seq_ville.nextval into :new.ville_num from dual;
	end if; 
end;
/

-- ETAPE --
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
END ti_etape;
/

-- POINT_PASSAGE --
CREATE OR REPLACE TRIGGER ti_point_passage
BEFORE INSERT ON point_passage
FOR EACH ROW
DECLARE
	inconsistency_km EXCEPTION;
	v_pt_pass_km_dep_previous point_passage.pt_pass_km_dep%TYPE;
BEGIN
	SELECT COUNT(*) INTO :new.pt_pass_num FROM point_passage WHERE tour_annee = :new.tour_annee and etape_num = :new.etape_num;
	:new.pt_pass_num := :new.pt_pass_num + 1;
	--Si ce n'est pas le premier point de passage, on vérifie que le kilométrage est cohérent
	IF:new.pt_pass_num > 1 THEN
		SELECT pt_pass_km_dep INTO v_pt_pass_km_dep_previous FROM point_passage 
		WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num - 1;
    
		IF v_pt_pass_km_dep_previous > :new.pt_pass_km_dep THEN
			RAISE inconsistency_km;
		END IF;
	ELSIF :new.pt_pass_km_dep > 0 THEN
		RAISE inconsistency_km;
	END IF;
	
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
	WHEN no_data_found THEN dbms_output.put_line('Fatal erreur');
	WHEN inconsistency_km THEN 
		dbms_output.put_line('Erreur de cohérence: Vérifier que le kilométrage est supérieur au point de passage précédent');
		RAISE inconsistency_km;
END ti_point_passage;
/

-- -----------------------------------------------------------------------------
--       GESTION DU CLASSEMENT
-- -----------------------------------------------------------------------------


-- CATEGORIE --
create or replace trigger TI_CATEGORIE
before insert on CATEGORIE 
for each row
begin
	if inserting then
	select seq_categorie.nextval into :new.cat_num from dual;
	end if; 
end;
/

-- PASSER --
CREATE OR REPLACE TRIGGER ti_point_passage
BEFORE INSERT ON point_passage
FOR EACH ROW
DECLARE
	inconsistency_km EXCEPTION;
	v_pt_pass_km_dep_previous point_passage.pt_pass_km_dep%TYPE;
BEGIN
	SELECT COUNT(*) INTO :new.pt_pass_num FROM point_passage WHERE tour_annee = :new.tour_annee and etape_num = :new.etape_num;
	:new.pt_pass_num := :new.pt_pass_num + 1;
	--Si ce n'est pas le premier point de passage, on vérifie que le kilométrage est cohérent
	IF:new.pt_pass_num > 1 THEN
		SELECT pt_pass_km_dep INTO v_pt_pass_km_dep_previous FROM point_passage 
		WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num - 1;
    
		IF v_pt_pass_km_dep_previous > :new.pt_pass_km_dep THEN
			RAISE inconsistency_km;
		END IF;
	ELSIF :new.pt_pass_km_dep > 0 THEN
		RAISE inconsistency_km;
	END IF;
	
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
	WHEN no_data_found THEN dbms_output.put_line('Fatal erreur');
	WHEN inconsistency_km THEN
		dbms_output.put_line('Erreur de cohérence: Vérifier que le kilométrage est supérieur au point de passage précédent');
		RAISE inconsistency_km;
END ti_point_passage;
/

--AJOUTER ENREGISTREMENT DANS PASSER
CREATE OR REPLACE TRIGGER ti_passer_before
BEFORE INSERT ON passer
FOR EACH ROW
DECLARE
  v_cat_num categorie.cat_num%TYPE;
  v_maillot_couleur categorie.maillot_couleur%TYPE;
  v_bareme_pts bareme.bareme_pts%TYPE;
  v_part_tps_gene participant.part_tps_gene%TYPE;
  v_part_num participant.part_num%TYPE;
  inconstitency_passer EXCEPTION;
BEGIN
	SELECT COUNT(*) INTO :new.pass_class FROM passer WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num;
	:new.pass_class := :new.pass_class + 1;
	
	--On doit vérifier deux cohérences:
		-- Le participant est passé au point de passage précédent (ou à fini l'étape précédente si premier point de passage
		-- Le temps est supérieur ou égal au temps du précédent point de passage
	BEGIN
		IF :new.pt_pass_num > 1 THEN
				SELECT part_num INTO v_part_num FROM passer WHERE tour_annee =:new.tour_annee AND etape_num = :new.etape_num 
				AND pt_pass_num = :new.pt_pass_num - 1 AND part_num = :new.part_num AND pass_tps <= :new.pass_tps;
		ELSIF :new.etape_num  > 1 THEN
				SELECT part_num INTO v_part_num FROM terminer_etape WHERE tour_annee =:new.tour_annee AND etape_num = :new.etape_num - 1 AND part_num = :new.part_num
				AND pt_pass_num = (
					SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = :new.tour_annee AND etape_num =:new.etape_num - 1
        );
		END IF;
	EXCEPTION
		WHEN no_data_found THEN raise inconstitency_passer;
	END;
	
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
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Fatal error');
	WHEN inconstitency_passer THEN 
		dbms_output.put_line('Problème d''incohérence: vérifier que le coureur a passer les points de passage précédents et/ou que le temps est supérieur');
		raise inconstitency_passer;
END ti_passer_before;
/

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
  v_part_jaune participant.part_num%TYPE;
  v_part_vert participant.part_num%TYPE;
  v_part_pois participant.part_num%TYPE;
  v_part_blanc participant.part_num%TYPE;
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
  
  db_resultat.update_classements(:new.tour_annee, :new.etape_num);
  
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
	UPDATE participant SET
		 part_class_gene = NULL
		,part_class_mont = NULL
		,part_class_sprint = NULL
	WHERE tour_annee = :new.tour_annee;
	
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
    
	--Mis à jour de la table porter
    SELECT part_num INTO v_part_jaune FROM terminer_etape WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND gene_class = 1;
    
    SELECT part_num INTO v_part_vert FROM (
      SELECT part_num FROM terminer_etape 
      WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num 
      AND part_num NOT IN (v_part_jaune)
      ORDER BY gene_class_sprint ASC
    )
    WHERE rownum = 1;
      
    SELECT part_num INTO v_part_pois FROM (
      SELECT part_num FROM terminer_etape 
      WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num 
      AND  part_num NOT IN (v_part_jaune, v_part_vert)
      ORDER BY gene_class_mont ASC
    )
    WHERE rownum = 1;
    
    SELECT part_num INTO v_part_blanc FROM (
      SELECT te.part_num FROM terminer_etape te 
      INNER JOIN etape e ON te.tour_annee = e.tour_annee AND te.etape_num = e.etape_num 
      INNER JOIN participant p ON te.tour_annee = p.tour_annee AND te.part_num = p.part_num
      WHERE te.tour_annee = :new.tour_annee AND te.etape_num = :new.etape_num 
      AND te.part_num NOT IN (v_part_jaune, v_part_vert, v_part_pois)
      AND MONTHS_BETWEEN(p.cycliste_daten, e.etape_date) <= 300
      ORDER BY te.gene_class_sprint ASC
    ) 
    WHERE rownum = 1;
    
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (:new.tour_annee, :new.etape_num, 'jaune', v_part_jaune);
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (:new.tour_annee, :new.etape_num, 'pois', v_part_pois);
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (:new.tour_annee, :new.etape_num, 'vert', v_part_vert);
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (:new.tour_annee, :new.etape_num, 'blanc', v_part_blanc);
    
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
/

-- TERMINER_ETAPE --
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
/

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
/

-- -----------------------------------------------------------------------------
--       GESTION COMBATIF
-- -----------------------------------------------------------------------------

-- SPECIALISTE --
create or replace trigger TI_SPECIALISTE
before insert on SPECIALISTE 
for each row
begin
	if inserting then
	select seq_specialiste.nextval into :new.spe_num from dual;
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION DOPAGE
-- -----------------------------------------------------------------------------

-- CONTROLE --
create or replace trigger TI_CONTROLE
before insert on CONTROLE
for each row
begin
	if inserting then
	select seq_controle.nextval into :new.contr_num from dual;
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION DES UTILISATEURS
-- -----------------------------------------------------------------------------

-- UTILISATEUR --
create or replace trigger TI_UTILISATEUR
before insert on UTILISATEUR
for each row
begin
	if inserting then
	select seq_utilisateur.nextval into :new.util_num from dual;
	end if; 
end;
/



