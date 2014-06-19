-------------------------------------------------------
--  DDL for Package UI_RESULTAT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_RESULTAT" AS 

  PROCEDURE UI_AFF_CLASS_EQUI (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_AFF_CLASS_ETAPE (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);

  PROCEDURE UI_AFF_CLASS_GENE (nb_ligne number default 999,n_etape porter.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_AFF_CLASS_JEUNE (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_AFF_CLASS_MONT (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_AFF_CLASS_SPRINT (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_CLASSEMENTS;
  
  PROCEDURE UI_CLASS_EQUIPE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_CLASS_ETAPE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default ui_utils.getSelectedEtape);
  
  PROCEDURE UI_CLASS_GENE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_CLASS_JEUNE_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_CLASS_MONT_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);
  
  PROCEDURE UI_CLASS_SPRINT_COMPLET (nb_ligne number default 999,n_etape etape.etape_num%TYPE default db_commun.getLastEtape);

END UI_RESULTAT;

/