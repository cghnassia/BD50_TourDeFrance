CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_RESULTAT" 
IS
  TYPE array_class_t IS table of varchar2(3);

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

   FUNCTION getParticipantEtapeRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
   return db_param_commun.array_class_t;

   FUNCTION getParticipantGeneRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
   return db_param_commun.array_class_t;

   FUNCTION getParticipantMontRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
   return db_param_commun.array_class_t;

   FUNCTION getParticipantSprintRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
   return db_param_commun.array_class_t;

   FUNCTION getParticipantJeuneRanking(n_tour_annee tour.tour_annee%TYPE, n_part_num participant.part_num%TYPE)
   return db_param_commun.array_class_t;

   FUNCTION getEquipeEtapeRanking(n_tour_annee tour.tour_annee%TYPE, n_equipe_num equipe.equipe_num%TYPE)
   return db_param_commun.array_class_t;

   FUNCTION getEquipeGeneRanking(n_tour_annee tour.tour_annee%TYPE, n_equipe_num equipe.equipe_num%TYPE)
   return db_param_commun.array_class_t;
  
   PROCEDURE update_classements (v_tour_annee tour.tour_annee%TYPE ,v_etape_num etape.etape_num%TYPE);
   
      FUNCTION getCurVicEtape(n_part participant.part_num%TYPE)
   return number;
   
   FUNCTION getVicEtape(n_part participant.part_num%TYPE)
   return number;
   
END DB_RESULTAT;

/