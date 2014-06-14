--------------------------------------------------------
--  DDL for Trigger TI_PASSER_AFTER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_PASSER_AFTER" 
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
ALTER TRIGGER "G11_FLIGHT"."TI_PASSER_AFTER" ENABLE;
