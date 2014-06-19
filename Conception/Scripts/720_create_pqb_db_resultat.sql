--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body DB_RESULTAT
--------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."DB_RESULTAT" 
IS

FUNCTION getLeaderEtape(
    n_etape terminer_etape.etape_num%type)
  RETURN terminer_etape.part_num%type
IS
  n_part terminer_etape.part_num%type;
BEGIN
  SELECT part_num
  INTO n_part
  FROM terminer_etape
  WHERE tour_annee =ui_utils.getselectedtour
  AND etape_num    = n_etape
  AND etape_class  = 1;
  RETURN n_part;
    EXCEPTION WHEN OTHERS THEN
    return null;
END getLeaderEtape;


FUNCTION getPorteur(v_maillot porter.maillot_couleur%type,n_etape porter.etape_num%type)
  RETURN participant%rowtype
IS
  n_part porter.part_num%type;
BEGIN
  SELECT DISTINCT part_num
  INTO n_part
  FROM porter
  WHERE etape_num = n_etape
  AND tour_annee = ui_utils.getselectedtour
  AND maillot_couleur = v_maillot ;

  return db_inscription.getPart(n_part);
    EXCEPTION WHEN OTHERS THEN
    return null;
END getPorteur;


  FUNCTION getEquipeLeader(n_etape porter.etape_num%type)
  return equipe%rowtype IS
  n_equipe equipe.equipe_num%type;
  BEGIN
  
  select equipe_num into n_equipe
  from (select * from terminer_etape_equipe order by gene_equi_class asc)
  where tour_annee=ui_utils.getselectedtour
  and etape_num = n_etape
  and rownum = 1;
  
  return db_inscription.getEquipe(n_equipe);
    EXCEPTION WHEN OTHERS THEN
    return null;
  END getEquipeLeader;
  
  
   FUNCTION getEquipeRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur IS
   cur_equipe db_param_commun.ref_cur;
   BEGIN 
    OPEN cur_equipe for 
      SELECT 
          * 
      FROM 
        terminer_etape_equipe 
      WHERE 
          tour_annee=ui_utils.getselectedtour 
      AND gene_equi_class < nb_ligne 
      AND etape_num=n_etape 
      AND gene_equi_class!=0  
      ORDER BY gene_equi_class;
    return cur_equipe;
    EXCEPTION WHEN OTHERS THEN
    null;
   END getEquipeRanking;
   
   FUNCTION getTempsEquipeLeader(n_etape etape.etape_num%TYPE default db_commun.getLastEtape)
   return terminer_etape_equipe.gene_equi_tps%type IS
   tps terminer_etape_equipe.gene_equi_tps%type;
   BEGIN
     SELECT 
      gene_equi_tps INTO tps 
    FROM 
      terminer_etape_equipe 
    WHERE tour_annee=ui_utils.getselectedtour  
    AND etape_num=n_etape 
    AND gene_equi_class=1;
   return tps;
       EXCEPTION WHEN OTHERS THEN
    null;
   END getTempsEquipeLeader;
   
   FUNCTION getEtapeRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur IS
   cur_part db_param_commun.ref_cur;
   BEGIN 
    OPEN cur_part for 
     SELECT 
      * 
    FROM 
      terminer_etape 
    WHERE 
      tour_annee=ui_utils.getselectedtour 
    AND etape_class <= nb_ligne 
    AND etape_num=n_etape 
    AND etape_class != 0 
    ORDER BY etape_class;
    return cur_part;
        EXCEPTION WHEN OTHERS THEN
    null;
    END getEtapeRanking;
   
    FUNCTION getGeneRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape)
   return db_param_commun.ref_cur IS
   cur_part db_param_commun.ref_cur;
   BEGIN 
    OPEN cur_part for 
     SELECT 
      * 
    FROM 
      terminer_etape 
    WHERE 
      tour_annee=ui_utils.getselectedtour 
    AND gene_class <= nb_ligne 
    AND etape_num=n_etape 
    AND gene_class != 0 
    ORDER BY gene_class;
    return cur_part;
  END getGeneRanking;
  
    FUNCTION getJeuneRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur IS
   cur_part db_param_commun.ref_cur;
   BEGIN 
    OPEN cur_part for 
     SELECT 
      *
    FROM (
      SELECT * FROM terminer_etape
      WHERE tour_annee=ui_utils.getselectedtour 
      AND (ui_utils.getselectedtour -TO_CHAR(cycliste_daten,'YYYY')) < 26
      AND etape_num=n_etape
      ORDER BY gene_class asc
    )
    WHERE rownum <= nb_ligne;
    return cur_part;
        EXCEPTION WHEN OTHERS THEN
    null;
  END getJeuneRanking;

    FUNCTION getMontRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur IS
   cur_part db_param_commun.ref_cur;
   BEGIN 
    OPEN cur_part for 
     SELECT 
      * 
     FROM 
      terminer_etape 
     WHERE 
      tour_annee=ui_utils.getselectedtour 
     AND gene_class_mont <= nb_ligne 
     AND etape_num=n_etape 
     AND gene_class_mont!=0 
     ORDER BY gene_class_mont;
    return cur_part;
        EXCEPTION WHEN OTHERS THEN
    null;
  END getMontRanking;
  
  FUNCTION getSprintRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur IS
   cur_part db_param_commun.ref_cur;
   BEGIN 
    OPEN cur_part for 
     SELECT 
      * 
    FROM 
      terminer_etape 
    WHERE 
      tour_annee=ui_utils.getselectedtour 
    AND gene_class_sprint <= nb_ligne 
    AND gene_class_sprint!=0 
    AND etape_num=n_etape 
    ORDER BY gene_class_sprint;
    return cur_part;
        EXCEPTION WHEN OTHERS THEN
    null;
  END getSprintRanking;

  PROCEDURE update_classements (
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

   FUNCTION getCurVicEtape(n_part participant.part_num%TYPE)
   return number IS
   n_vic number(3);
   BEGIN
    select 
      count(part_num) into n_vic
    from
      terminer_etape
    where
      part_num=n_part
    and tour_annee=ui_utils.getSelectedTour
    and etape_class = 1;
    return n_vic;
    EXCEPTION WHEN OTHERS THEN
    return 0;
   END getCurVicEtape;
   
      FUNCTION getVicEtape(n_part participant.part_num%TYPE)
   return number IS
   n_vic number(3);
   BEGIN
    select 
      count(part_num) into n_vic
    from
      terminer_etape
    where
      part_num=n_part
    and etape_class = 1;
    return n_vic;
    EXCEPTION WHEN OTHERS THEN
    return 0;
   END getVicEtape;

FUNCTION getParticipantEtapeRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_etape_class VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT etape_class || '' INTO v_etape_class FROM terminer_etape WHERE  tour_annee = n_tour_annee AND etape_num = v_etape_num AND part_num = n_part_num;
    EXCEPTION 
      WHEN no_data_found THEN v_etape_class := '-'; 
    END;

    IF v_etape_class = '0' OR v_etape_class IS NULL THEN
      v_etape_class := '-';
    END IF;

    v_array_class(v_etape_num ) := v_etape_class;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getParticipantEtapeRanking;


FUNCTION getParticipantGeneRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_gene_class VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT gene_class || '' INTO v_gene_class FROM terminer_etape WHERE  tour_annee = n_tour_annee AND etape_num = v_etape_num AND part_num = n_part_num;
    EXCEPTION 
      WHEN no_data_found THEN v_gene_class := '-'; 
    END;

    IF v_gene_class = '0' OR v_gene_class IS NULL THEN
      v_gene_class := '-';
    END IF;

    v_array_class(v_etape_num) := v_gene_class;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getParticipantGeneRanking;


FUNCTION getParticipantMontRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_gene_class_mont VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT gene_class_mont || '' INTO v_gene_class_mont FROM terminer_etape WHERE  tour_annee = n_tour_annee AND etape_num = v_etape_num AND part_num = n_part_num;
    EXCEPTION 
      WHEN no_data_found THEN v_gene_class_mont := '-'; 
    END;

    IF v_gene_class_mont = '0' OR v_gene_class_mont IS NULL THEN
      v_gene_class_mont := '-';
    END IF;

    v_array_class(v_etape_num) := v_gene_class_mont;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getParticipantMontRanking;


FUNCTION getParticipantSprintRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_gene_class_sprint VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT gene_class_sprint || '' INTO v_gene_class_sprint FROM terminer_etape WHERE  tour_annee = n_tour_annee AND etape_num = v_etape_num AND part_num = n_part_num;
    EXCEPTION 
      WHEN no_data_found THEN v_gene_class_sprint := '-'; 
    END;

    IF v_gene_class_sprint = '0' OR v_gene_class_sprint IS NULL THEN
      v_gene_class_sprint := '-';
    END IF;

    v_array_class(v_etape_num) := v_gene_class_sprint;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getParticipantSprintRanking;


FUNCTION getParticipantJeuneRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_gene_class VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT class INTO v_gene_class FROM (
        SELECT part_num, rownum AS class FROM (  
          SELECT te.part_num FROM terminer_etape te INNER JOIN participant p
          ON te.tour_annee = p.tour_annee AND te.part_num = p.part_num
          WHERE te.tour_annee = n_tour_annee AND te.etape_num = v_etape_num
          AND (n_tour_annee - TO_CHAR(p.cycliste_daten,'YYYY')) < 26
          ORDER BY te.gene_class ASC
        )
      )
      WHERE part_num = n_part_num;

    EXCEPTION 
      WHEN no_data_found THEN v_gene_class := '-'; 
    END;

    IF v_gene_class = '0' OR v_gene_class IS NULL THEN
      v_gene_class := '-';
    END IF;

    v_array_class(v_etape_num) := v_gene_class;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getParticipantJeuneRanking;

FUNCTION getEquipeEtapeRanking(n_tour_annee tour.tour_annee%TYPE, n_equipe_num equipe.equipe_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_etape_class VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT etape_equi_class || '' INTO v_etape_class FROM terminer_etape_equipe WHERE  tour_annee = n_tour_annee AND etape_num = v_etape_num AND equipe_num = n_equipe_num;
    EXCEPTION 
      WHEN no_data_found THEN v_etape_class := '-'; 
    END;

    IF v_etape_class = '0' OR v_etape_class IS NULL THEN
      v_etape_class := '-';
    END IF;

    v_array_class(v_etape_num ) := v_etape_class;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getEquipeEtapeRanking;


FUNCTION getEquipeGeneRanking(n_tour_annee tour.tour_annee%TYPE, n_equipe_num equipe.equipe_num%TYPE)
return db_param_commun.array_class_t IS
  CURSOR c_etape IS SELECT etape_num FROM etape WHERE tour_annee = n_tour_annee ORDER BY etape_num ASC;
  v_gene_class VARCHAR2(3);
  v_etape_num etape.etape_num%TYPE;
  v_array_class db_param_commun.array_class_t;
BEGIN
  OPEN c_etape;
  LOOP
    FETCH c_etape INTO v_etape_num;
    EXIT WHEN c_etape%NOTFOUND;

    BEGIN
      SELECT gene_equi_class || '' INTO v_gene_class FROM terminer_etape_equipe WHERE  tour_annee = n_tour_annee AND etape_num = v_etape_num AND equipe_num = n_equipe_num;
    EXCEPTION 
      WHEN no_data_found THEN v_gene_class := '-'; 
    END;

    IF v_gene_class = '0' OR v_gene_class IS NULL THEN
      v_gene_class := '-';
    END IF;

    v_array_class(v_etape_num) := v_gene_class;

  END LOOP;
  CLOSE c_etape;

  return v_array_class;
END getEquipeGeneRanking;

END DB_RESULTAT;
/
