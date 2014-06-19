-- -----------------------------------------------------------------------------
--       CREATION DE LA BASE 
-- -----------------------------------------------------------------------------

CREATE DATABASE TOUR;

-- -----------------------------------------------------------------------------
--       TABLE : DIRECTEUR_SPORTIF
-- -----------------------------------------------------------------------------

CREATE TABLE DIRECTEUR_SPORTIF
   (
    DIRS_NUM NUMBER(3)  NOT NULL,
    DIRS_NOM VARCHAR2(40)  NOT NULL,
    DIRS_PRENOM VARCHAR2(30)  NOT NULL  
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : CYCLISTE
-- -----------------------------------------------------------------------------

CREATE TABLE CYCLISTE
   (
    CYCLISTE_NUM NUMBER(5)  NOT NULL,
    CYCLISTE_NOM VARCHAR2(40)  NOT NULL,
    CYCLISTE_PRENOM VARCHAR2(30)  NOT NULL,
    CYCLISTE_DATEN DATE  NOT NULL,
    PAYS_NUM NUMBER(3)  NOT NULL 
   ) 
   TABLESPACE BD50_DATA ;
-- -----------------------------------------------------------------------------
--       TABLE : CATEGORIE
-- -----------------------------------------------------------------------------

CREATE TABLE CATEGORIE
   (
    CAT_NUM NUMBER(2)  NOT NULL,
    CAT_LIB VARCHAR2(50)  NOT NULL,
    MAILLOT_COULEUR VARCHAR2(20)  NOT NULL
	)
	TABLESPACE BD50_DATA
	;
-- -----------------------------------------------------------------------------
--       TABLE : UTILISATEUR
-- -----------------------------------------------------------------------------

CREATE TABLE UTILISATEUR
   (
    UTIL_NUM NUMBER(4)  NOT NULL,
    UTIL_NOM VARCHAR2(30)  NOT NULL,
    UTIL_MDP VARCHAR2(20)  NOT NULL,
    PROFIL_LIB VARCHAR2(30)  NOT NULL
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : PARTICIPANT
-- -----------------------------------------------------------------------------

CREATE TABLE PARTICIPANT
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    PART_NUM NUMBER(3)  NOT NULL,
    CYCLISTE_NOM VARCHAR2(40)  NOT NULL,
    CYCLISTE_PRENOM VARCHAR2(30)  NOT NULL,
    CYCLISTE_DATEN DATE  NOT NULL,
    CYCLISTE_PAYS VARCHAR2(50)  NOT NULL,
    PART_POIDS NUMBER(3),
    PART_TAILLE NUMBER(3),
    PART_TPS_GENE NUMBER(10)  NULL,
    PART_CLASS_GENE NUMBER(3)  NULL,
    PART_PTS_MONT NUMBER(3)  NULL,
    PART_CLASS_MONT NUMBER(3)  NULL,
    PART_PTS_SPRINT NUMBER(3)  NULL,
    PART_CLASS_SPRINT NUMBER(3)  NULL,
    PART_TPS_ECART NUMBER(10)  NULL,
    ABANDON_MOTIF VARCHAR2(128)  NULL,
    EQUIPE_NOM VARCHAR2(50)  NOT NULL,
    EQUIPE_NUM NUMBER(2)  NOT NULL,
    ETAPE_NUM NUMBER(2)  NULL,
    PT_PASS_NUM NUMBER(3)  NULL,
    CYCLISTE_NUM NUMBER(5)  NOT NULL
   ) 
    TABLESPACE BD50_DATA
   ;
-- -----------------------------------------------------------------------------
--       TABLE : PAYS
-- -----------------------------------------------------------------------------

CREATE TABLE PAYS
   (
    PAYS_NUM NUMBER(3)  NOT NULL,
    PAYS_NOM VARCHAR2(50)  NOT NULL,
	PAYS_ACRO CHAR(3) NOT NULL
   ) 
   TABLESPACE BD50_DATA
   ;

-- -----------------------------------------------------------------------------
--       TABLE : BAREME
-- -----------------------------------------------------------------------------

CREATE TABLE BAREME
   (
    CAT_NUM NUMBER(2)  NOT NULL,
    BAREME_PLACE NUMBER(3)  NOT NULL,
    BAREME_PTS NUMBER(3)  NOT NULL
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : EQUIPE
-- -----------------------------------------------------------------------------

CREATE TABLE EQUIPE
   (
	TOUR_ANNEE NUMBER(4)  NOT NULL,
    EQUIPE_NUM NUMBER(2)  NOT NULL,
    EQUIPE_NOM VARCHAR2(50)  NOT NULL,
    EQUIPE_WEB VARCHAR2(25)  NOT NULL,
    EQUIPE_DESC VARCHAR2(128)  NOT NULL,
    EQUIPE_TPS_GENE NUMBER(10)  NULL,
    EQUIPE_CLASS_GENE NUMBER(2)  NULL,
    EQUIPE_PAYS VARCHAR2(50)  NOT NULL,
    SPON_NOM VARCHAR2(60)  NOT NULL,
    SPON_ACRO VARCHAR2(10)  NOT NULL,
    PAYS_NUM NUMBER(3)  NOT NULL
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : VILLE
-- -----------------------------------------------------------------------------

CREATE TABLE VILLE
   (
    VILLE_NUM NUMBER(5)  NOT NULL,
    VILLE_NOM VARCHAR2(50)  NOT NULL,
    PAYS_NUM NUMBER(3)  NOT NULL
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : SPECIALISTE
-- -----------------------------------------------------------------------------

CREATE TABLE SPECIALISTE
   (
    SPE_NUM NUMBER(1)  NOT NULL,
    SPE_NOM VARCHAR2(40)  NOT NULL,
    SPE_PRENOM VARCHAR2(30)  NOT NULL
   ) 
   TABLESPACE BD50_DATA 
   ;

-- -----------------------------------------------------------------------------
--       TABLE : CONTROLE
-- -----------------------------------------------------------------------------

CREATE TABLE CONTROLE
   (
    CONTR_NUM NUMBER(5)  NOT NULL,
    CONTR_DATE DATE  NOT NULL,
    CONTR_RESULT VARCHAR2(50)  NOT NULL,
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    PART_NUM NUMBER(3)  NOT NULL 
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : ETAPE
-- -----------------------------------------------------------------------------

CREATE TABLE ETAPE
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    ETAPE_NUM NUMBER(2)  NOT NULL,
    ETAPE_NOM VARCHAR2(50)  NOT NULL,
    ETAPE_DATE DATE  NOT NULL,
    ETAPE_DISTANCE NUMBER(3) DEFAULT 0,
    TETAPE_LIB VARCHAR2(30)  NOT NULL,
    VILLE_NOM_DEBUTER VARCHAR2(50),
    VILLE_NOM_FINIR VARCHAR2(50),
    VILLE_NUM_FINIR NUMBER(5),
    VILLE_NUM_DEBUTER NUMBER(5) 
   ) 
   TABLESPACE BD50_DATA 
   ;
-- -----------------------------------------------------------------------------
--       TABLE : TOUR
-- -----------------------------------------------------------------------------

CREATE TABLE TOUR
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    TOUR_EDITION NUMBER(3)  NOT NULL,
    TOUR_DATED DATE  NOT NULL,
    TOUR_DATEF DATE  NOT NULL,
    TOUR_NOM VARCHAR2(25)  NOT NULL,
    SUPER_COMBATIF_NUM NUMBER(3) NULL,
    UTIL_NUM_MANAGER NUMBER(4)  NULL,
    UTIL_NUM_ADMINISTRER NUMBER(4)  NULL
   ) 
   TABLESPACE BD50_DATA 
   ;