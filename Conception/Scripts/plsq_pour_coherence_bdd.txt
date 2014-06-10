--Mettre à jour terminer_etape
DECLARE
  CURSOR c_terminer_etape IS
  SELECT * FROM terminer_etape WHERE tour_annee = 2013;
  r_terminer_etape c_terminer_etape%ROWTYPE;
BEGIN
  OPEN c_terminer_etape;
  LOOP
    FETCH c_terminer_etape INTO r_terminer_etape;
    EXIT WHEN c_terminer_etape%NOTFOUND;
    
    UPDATE terminer_etape SET
       cycliste_nom = (SELECT cycliste_nom FROM participant WHERE tour_annee = 2013 AND part_num = r_terminer_etape.part_num)
      ,cycliste_prenom = (SELECT cycliste_prenom FROM participant WHERE tour_annee = 2013 AND part_num = r_terminer_etape.part_num)
      ,cycliste_pays = (SELECT cycliste_pays FROM participant WHERE tour_annee = 2013 AND part_num = r_terminer_etape.part_num)
      ,cycliste_daten = (SELECT cycliste_daten FROM participant WHERE tour_annee = 2013 AND part_num = r_terminer_etape.part_num)
      ,equipe_nom = (SELECT equipe_nom FROM participant WHERE tour_annee = 2013 AND part_num = r_terminer_etape.part_num)
      ,etape_tps_ecart = etape_tps - (SELECT MIN(etape_tps) FROM terminer_etape WHERE tour_annee = 2013 and etape_num = r_terminer_etape.etape_num)
      ,gene_tps_ecart = gene_tps - (SELECT MIN(gene_tps) FROM terminer_etape WHERE tour_annee = 2013 and etape_num = r_terminer_etape.etape_num)
      ,pt_pass_num = (SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = 2013 AND etape_num = r_terminer_etape.etape_num)
    WHERE tour_annee = 2013 AND etape_num = r_terminer_etape.etape_num AND part_num = r_terminer_etape.part_num;
  END LOOP;
END;

SELECT * FROM ETAPE;

DECLARE
  CURSOR c_terminer_etape IS
  SELECT te1.part_num, te2.gene_tps - te2.etape_tps - te1.gene_tps AS etape_tps_4, te2.gene_tps - te2.etape_tps AS gene_tps_4 FROM terminer_etape te1 INNER JOIN terminer_etape te2 ON te1.part_num = te2.part_num
  WHERE te1.etape_num = 3 AND te2.etape_num = 5;
  r_terminer_etape c_terminer_etape%ROWTYPE;
BEGIN
  OPEN c_terminer_etape;
  LOOP
    FETCH c_terminer_etape INTO r_terminer_etape;
    EXIT WHEN c_terminer_etape%NOTFOUND;
    
    UPDATE terminer_etape SET
       etape_tps = r_terminer_etape.etape_tps_4
      ,gene_tps = r_terminer_etape.gene_tps_4
    WHERE tour_annee = 2013 AND etape_num = 4 AND part_num = r_terminer_etape.part_num;
  END LOOP;
END;
    
DECLARE
  CURSOR c_terminer_etape IS
  SELECT part_num FROM terminer_etape
  WHERE tour_annee = 2013 AND etape_num = 4
  ORDER BY etape_tps ASC;
  r_terminer_etape c_terminer_etape%ROWTYPE;
  v_index NUMBER := 1;
BEGIN
  OPEN c_terminer_etape;
  LOOP
    FETCH c_terminer_etape INTO r_terminer_etape;
    EXIT WHEN c_terminer_etape%NOTFOUND;
    
    UPDATE terminer_etape SET
       etape_class = v_index
      ,etape_tps_ecart = etape_tps - 15560
    WHERE tour_annee = 2013 AND etape_num = 4 AND part_num = r_terminer_etape.part_num;
    v_index := v_index + 1;
  END LOOP;
END;  
    
    
--Mettre à jour terminer_equipe et equipe
SET serveroutput on;

DECLARE
  CURSOR c_etape IS
  SELECT etape_num FROM etape WHERE tour_annee = 2013 ORDER BY etape_num ASC;
  CURSOR c_equipe IS
  SELECT * FROM equipe WHERE tour_annee = 2013 ORDER BY equipe_num;
  v_etape_num etape.etape_num%TYPE;
  r_equipe c_equipe%ROWTYPE;
  v_equipe_etape_tps terminer_etape_equipe.etape_equi_tps%TYPE;
  v_equipe_gene_tps terminer_etape_equipe.gene_equi_tps%TYPE;
BEGIN

  DELETE FROM TERMINER_ETAPE_EQUIPE WHERE TOUR_ANNEE = 2013;

  OPEN c_equipe;
  LOOP
    FETCH c_equipe INTO r_equipe;
    EXIT WHEN c_equipe%NOTFOUND;
    v_equipe_gene_tps := 0;
    OPEN c_etape;
    LOOP
      FETCH c_etape INTO v_etape_num;
      EXIT WHEN c_etape%NOTFOUND;
      SELECT SUM(etape_tps) INTO v_equipe_etape_tps FROM (
        SELECT te.etape_tps
        FROM terminer_etape te INNER JOIN participant p ON te.tour_annee = p.tour_annee AND te.part_num = p.part_num
        WHERE te.tour_annee = 2013 AND te.etape_num = v_etape_num AND p.equipe_num = r_equipe.equipe_num
        ORDER BY te.etape_class ASC
      )
      WHERE rownum < 4;
      
      v_equipe_gene_tps := v_equipe_gene_tps + v_equipe_etape_tps;
      dbms_output.put_line('tps gene :' || (v_equipe_gene_tps));
      
      INSERT INTO terminer_etape_equipe (tour_annee, equipe_num, etape_num, equipe_nom, equipe_pays, etape_equi_tps, gene_equi_tps)
      VALUES(r_equipe.tour_annee, r_equipe.equipe_num, v_etape_num, r_equipe.equipe_nom, r_equipe.equipe_pays, v_equipe_etape_tps, v_equipe_gene_tps);
      
      IF v_etape_num = 21 THEN
        UPDATE equipe SET equipe_tps_gene = v_equipe_gene_tps WHERE tour_annee = 2013 AND equipe_num = r_equipe.equipe_num;
      END IF;
      
    END LOOP;
    CLOSE c_etape;
  END LOOP;
  CLOSE c_equipe;
END;
/

--Mettre à jour les classements
DECLARE
  CURSOR c_etape IS
  SELECT etape_num FROM etape WHERE tour_annee = 2013 ORDER BY etape_num ASC;
  r_terminer_etape_equipe terminer_etape%ROWTYPE;
  v_index NUMBER;
  v_etape_num etape.etape_num%TYPE;
BEGIN

  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;
  
     v_index := 1;
     FOR r_terminer_etape_equipe IN (SELECT * FROM terminer_etape_equipe WHERE etape_num = v_etape_num ORDER BY etape_equi_tps ASC) LOOP
        UPDATE terminer_etape_equipe SET etape_equi_class = v_index WHERE tour_annee = 2013 AND etape_num = v_etape_num AND equipe_num = r_terminer_etape_equipe.equipe_num;
        v_index := v_index + 1;
     END LOOP;
      
     v_index := 1;
     FOR r_terminer_etape_equipe IN (SELECT * FROM terminer_etape_equipe WHERE etape_num = v_etape_num ORDER BY gene_equi_tps ASC) LOOP
        UPDATE terminer_etape_equipe SET gene_equi_class = v_index WHERE tour_annee = 2013 AND etape_num = v_etape_num AND equipe_num = r_terminer_etape_equipe.equipe_num;
        
        IF v_etape_num = 21 THEN
          UPDATE equipe SET equipe_class_gene = v_index WHERE tour_annee = 2013 AND equipe_num = r_terminer_etape_equipe.equipe_num;
        END IF;
          
        v_index := v_index + 1;
     END LOOP;
  END LOOP;
  CLOSE c_etape;
END;
/



COMMIT;
SELECT * FROM TERMINER_ETAPE_EQUIPE;
DELETE FROM TERMINER_ETAPE_EQUIPE WHERE TOUR_ANNEE = 2013;

SELECT * FROM EQUIPE;

UPDATE terminer_etape SET
  
WHERE part_num IN (SELECT part_num FROM participant WHERE equipe_num = 1);
AND tour_annee = 2013 AND etape_num = 4;

SELECt * FROM TERMINER_ETAPE WHERE ETAPE_NUM = 5 AND TOUR_ANNEE = 2013 AND PART_NUM = 1;

COMMIT;


--Mettre à jour la table porter pour le tour 2013
SET serveroutput ON
DECLARE
  CURSOR c_terminer_etape IS
    select distinct etape_num from terminer_etape where tour_annee = 2013 order by etape_num  ASC;
    v_etape_num etape.etape_num%TYPE;
    v_part_jaune participant.part_num%TYPE;
    v_part_pois participant.part_num%TYPE;
    v_part_vert participant.part_num%TYPE;
    v_part_blanc participant.part_num%TYPE;
    
BEGIN

  DELETE FROM porter WHERE tour_annee = 2013;
  OPEN c_terminer_etape;
  LOOP
    FETCH c_terminer_etape INTO v_etape_num;
    EXIT WHEN c_terminer_etape%NOTFOUND;
    
    SELECT part_num INTO v_part_jaune FROM terminer_etape WHERE tour_annee = 2013 AND etape_num = v_etape_num AND gene_class = 1;
    
    SELECT part_num INTO v_part_vert FROM (
      SELECT part_num FROM terminer_etape 
      WHERE tour_annee = 2013 AND etape_num = v_etape_num 
      AND part_num NOT IN (v_part_jaune)
      ORDER BY gene_class_sprint ASC
    )
    WHERE rownum = 1;
      
    SELECT part_num INTO v_part_pois FROM (
      SELECT part_num FROM terminer_etape 
      WHERE tour_annee = 2013 AND etape_num = v_etape_num 
      AND  part_num NOT IN (v_part_jaune, v_part_vert)
      ORDER BY gene_class_mont ASC
    )
    WHERE rownum = 1;
    
    SELECT part_num INTO v_part_blanc FROM (
      SELECT te.part_num FROM terminer_etape te 
      INNER JOIN etape e ON te.tour_annee = e.tour_annee AND te.etape_num = e.etape_num 
      INNER JOIN participant p ON te.tour_annee = p.tour_annee AND te.part_num = p.part_num
      WHERE te.tour_annee = 2013 AND te.etape_num = v_etape_num
      AND te.part_num NOT IN (v_part_jaune, v_part_vert, v_part_pois)
      AND MONTHS_BETWEEN(p.cycliste_daten, e.etape_date) <= 300
      ORDER BY te.gene_class_sprint ASC
    ) 
    WHERE rownum = 1;
    
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (2013, v_etape_num, 'jaune', v_part_jaune);
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (2013, v_etape_num, 'pois', v_part_pois);
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (2013, v_etape_num, 'vert', v_part_vert);
    INSERT INTO porter (tour_annee, etape_num, maillot_couleur, part_num) VALUES (2013, v_etape_num, 'blanc', v_part_blanc);
   END LOOP;
   
   CLOSE c_terminer_etape;
END;
