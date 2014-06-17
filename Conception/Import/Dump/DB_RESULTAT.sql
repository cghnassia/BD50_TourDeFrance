--------------------------------------------------------
--  DDL for Package DB_RESULTAT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_RESULTAT" 
IS

  FUNCTION getLeaderEtape(n_etape terminer_etape.etape_num%type)
  RETURN terminer_etape.part_num%type;
  
  FUNCTION getPorteur(v_maillot porter.maillot_couleur%type,n_etape porter.etape_num%type)
  return participant%rowtype;
  
   FUNCTION getEquipeLeader(n_etape porter.etape_num%type)
   return equipe%rowtype;
   
   FUNCTION getEquipeRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur;
   
   FUNCTION getTempsEquipeLeader(n_etape etape.etape_num%TYPE default db_commun.getLastEtape)
   return terminer_etape_equipe.gene_equi_tps%type;
   
   FUNCTION getEtapeRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur;
  
   FUNCTION getGeneRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape)
   return db_param_commun.ref_cur;
   
   FUNCTION getJeuneRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur;
   
   FUNCTION getMontRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur;

   FUNCTION getSprintRanking(nb_ligne number default 999,n_etape etape.etape_num%TYPE default 1)
   return db_param_commun.ref_cur;
  
END DB_RESULTAT;

/
