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
    null;
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
    null;
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
    null;
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
  
END DB_RESULTAT;

/
