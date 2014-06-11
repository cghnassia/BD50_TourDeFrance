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
