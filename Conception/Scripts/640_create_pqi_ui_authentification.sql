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