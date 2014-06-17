--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package DB_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_COMMUN" AS 

  FUNCTION getAllTour return db_param_commun.ref_cur;
  
  
  FUNCTION getLastTour return tour.tour_annee%type;
  
  FUNCTION getLastEtape return etape.etape_num%type;
  
  FUNCTION getTour(a_tour varchar2) return tour%rowtype;
  
  FUNCTION getAcroPays(n_part participant.part_num%TYPE ) RETURN pays.pays_acro%TYPE;
END DB_COMMUN;

/
--------------------------------------------------------
--  DDL for Package DB_COURSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_COURSE" AS 

 FUNCTION getAllEtape return db_param_commun.ref_cur;
 
 FUNCTION getEtape(n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) return etape%rowtype;
 
 FUNCTION getAllPdP (n_etape etape.etape_num%TYPE default ui_utils.getselectedetape) return db_param_commun.ref_cur;
END DB_COURSE;

/
--------------------------------------------------------
--  DDL for Package DB_INSCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_INSCRIPTION" AS 

  FUNCTION getPart(n_part varchar2) return participant%rowtype;
  
  FUNCTION getEquipe(n_equipe varchar2) return equipe%rowtype;

  FUNCTION getCycliste(n_cycliste varchar2) return cycliste%rowtype;
  
  FUNCTION getPartCrit(crit_nom varchar2 default '%',crit_pnom varchar2 default '%') return db_param_commun.ref_cur;
  
  FUNCTION getEquipeCrit(crit_nom varchar2 default '%') return db_param_commun.ref_cur;
  

END DB_INSCRIPTION;

/
--------------------------------------------------------
--  DDL for Package DB_PARAM_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_PARAM_COMMUN" AS 

  TYPE ref_cur IS REF CURSOR;

END DB_PARAM_COMMUN;

/
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
--------------------------------------------------------
--  DDL for Package UI_ADMINISTRATION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_ADMINISTRATION" AS 

 PROCEDURE gestion;
 
 PROCEDURE header_admin;
 
 PROCEDURE UI_FORM_PASSER (
  v_etape_num etape.etape_num%TYPE default 1, 
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 0,
  v_part_num participant.part_num%TYPE default 0,
  v_temps VARCHAR2 default '',
  v_code NUMBER default 0,
  v_message VARCHAR2 default NULL);
  
  PROCEDURE              UI_EXECFORM_PASSER (
	select_etape etape.etape_num%TYPE default 0,
	select_passage point_passage.pt_pass_num%TYPE default 0,
	select_participant participant.part_num%TYPE default 0,
  text_temps VARCHAR2 DEFAULT '',
  button_submit VARCHAR2 DEFAULT NULL);


PROCEDURE              UI_AFF_SELECT_POINT_PASSAGES (
	v_etape_num etape.etape_num%TYPE default 0,
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 0);
  
  PROCEDURE              UI_AFF_SELECT_PARTICIPANTS (
	v_etape_num etape.etape_num%TYPE default 0,
	v_pt_pass_num point_passage.pt_pass_num%TYPE default 0,
  v_part_num participant.part_num%TYPE default 0);
  
  PROCEDURE              UI_AFF_SELECT_ETAPES (
  v_etape_num etape.etape_num%TYPE default 0);
  
END UI_ADMINISTRATION;

/
--------------------------------------------------------
--  DDL for Package UI_AUTHENTIFICATION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_AUTHENTIFICATION" AS 

  --Affiche le formulaire de login
  PROCEDURE formLogin;
  
  --Cadre affiché si utilisateur loggé
  PROCEDURE formLogged(login varchar2 default'') ;
  
  --Verificiation si utilisateur existe dans la base
  FUNCTION userExist(login varchar2, pass varchar2) return boolean;
  
  --Retourne les infos de l'utilisateur
  FUNCTION getUser(login varchar2) return utilisateur%rowtype;
  
  --Procédure de traitement pour l'authentification
  PROCEDURE verifAuth(login varchar2, pass varchar2, prev_url varchar2);

  --Cadre contenant une erreur d'authentification
  PROCEDURE formError ;
  
  --Cadre d'authentification
  PROCEDURE cadreAuth ;
  
    --Déconnexion
  PROCEDURE logOut ;
  
 
        --Page de login
  PROCEDURE login ;

END UI_AUTHENTIFICATION;

/
--------------------------------------------------------
--  DDL for Package UI_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_COMMUN" AS 

  PROCEDURE UI_HEAD;
  PROCEDURE UI_HEADER;
  
  PROCEDURE UI_MAIN_OPEN;
  PROCEDURE UI_MAIN_CLOSE;
  
  PROCEDURE UI_FOOTER;
  
  PROCEDURE UI_SELECT_TOUR (a_tour varchar2 default ui_utils.getSelectedTour);
  
  PROCEDURE UI_SELECT_ETAPE (n_etape varchar2 default ui_utils.getSelectedEtape);
  
  PROCEDURE UI_HOME;
  
  PROCEDURE UI_HOME_AFF_PORTEURS (v_maillot porter.maillot_couleur%TYPE, n_etape porter.etape_num%TYPE);
  
  
END UI_COMMUN;

/
--------------------------------------------------------
--  DDL for Package UI_COURSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_COURSE" AS 

  PROCEDURE UI_LETAPE;
  
  PROCEDURE UI_DETAIL_ETAPE (n_etape etape.etape_num%TYPE default ui_utils.getselectedetape);
END UI_COURSE;

/
--------------------------------------------------------
--  DDL for Package UI_INSCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_INSCRIPTION" AS 

  PROCEDURE UI_LPARTICIPANT (crit_nom varchar2 default '%',crit_pnom varchar2 default '%');

  PROCEDURE UI_LEQUIPE (crit_nom varchar2 default '%');
  
  PROCEDURE UI_DETAIL_EQUIPE (n_equipe number default 1);
  
  PROCEDURE UI_DETAIL_PARTICIPANT (n_part number default 1);
  
END UI_INSCRIPTION;

/
--------------------------------------------------------
--  DDL for Package UI_PARAM_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_PARAM_COMMUN" AS 

  path_img varchar2(255) := '/public/img/';
  path_css varchar2(255) := '/public/css/';
  

END UI_PARAM_COMMUN;

/
--------------------------------------------------------
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
--------------------------------------------------------
--  DDL for Package UI_UTILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_UTILS" AS 

  --Fonction de récupération d'une valeur de cookie
  FUNCTION getCookieValue(c_name varchar2) RETURN varchar2;
  
  --Test si un cookie existe
  FUNCTION existCookie(c_name varchar2) RETURN boolean;
  
  --Creation de cookie
  PROCEDURE createCookie (c_name varchar2,c_value varchar2);
  
  --Suppression de cookie
  PROCEDURE removeCookie(c_name varchar2);
  
  
  --Retourne le Tour sélectionné
  FUNCTION getSelectedTour  RETURN varchar2;

  --Retourne l'étape selectionnée
  FUNCTION getSelectedEtape  RETURN varchar2;
  
    PROCEDURE COLOR_ROW_P (cpt number default 0);
  
  PROCEDURE MAJ_SELECTED_TOUR (v_tour varchar2,prev_url varchar2);
  
  PROCEDURE MAJ_SELECTED_ETAPE (n_etape varchar2,prev_url varchar2);
  
  FUNCTION FORMATED_TIME (time_number NUMBER) RETURN VARCHAR2;

END UI_UTILS;

/
