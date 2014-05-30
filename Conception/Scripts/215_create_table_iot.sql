-- -----------------------------------------------------------------------------
--       TABLE : DIRIGER
-- -----------------------------------------------------------------------------

CREATE TABLE DIRIGER
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    EQUIPE_NUM NUMBER(2)  NOT NULL,
    DIRS_NUM NUMBER(3)  NOT NULL 
,   CONSTRAINT PK_DIRIGER PRIMARY KEY (TOUR_ANNEE, EQUIPE_NUM, DIRS_NUM) 
   )
   ORGANIZATION INDEX
   TABLESPACE BD50_IND
   ;
-- -----------------------------------------------------------------------------
--       TABLE : CONSULTER
-- -----------------------------------------------------------------------------

CREATE TABLE CONSULTER
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    UTIL_NUM NUMBER(4)  NOT NULL
,   CONSTRAINT PK_CONSULTER PRIMARY KEY (TOUR_ANNEE, UTIL_NUM) 
   )
   ORGANIZATION INDEX
   TABLESPACE BD50_IND
   ;
-- -----------------------------------------------------------------------------
--       TABLE : TERMINER_ETAPE_EQUIPE
-- -----------------------------------------------------------------------------

CREATE TABLE TERMINER_ETAPE_EQUIPE
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    EQUIPE_NUM NUMBER(2)  NOT NULL,
    ETAPE_NUM NUMBER(2)  NOT NULL,
    EQUIPE_NOM VARCHAR2(50)  NOT NULL,
    EQUIPE_PAYS VARCHAR2(50)  NOT NULL,
    ETAPE_EQUI_TPS NUMBER(10)  NOT NULL,
    ETAPE_EQUI_CLASS NUMBER(2)  NOT NULL,
    GENE_EQUI_TPS NUMBER(10)  NOT NULL,
    GENE_EQUI_CLASS NUMBER(2)  NOT NULL 
,   CONSTRAINT PK_TERMINER_ETAPE_EQUIPE PRIMARY KEY (TOUR_ANNEE, EQUIPE_NUM, ETAPE_NUM)  
   )
   ORGANIZATION INDEX
   TABLESPACE BD50_IND
   ;

-- -----------------------------------------------------------------------------
--       TABLE : VOTER_COMBATIF
-- -----------------------------------------------------------------------------

CREATE TABLE VOTER_COMBATIF
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    ETAPE_NUM NUMBER(2)  NOT NULL,
    SPE_NUM NUMBER(1)  NOT NULL,
    PART_NUM NUMBER(3)  NOT NULL 
,   CONSTRAINT PK_VOTER_COMBATIF PRIMARY KEY (TOUR_ANNEE, ETAPE_NUM, SPE_NUM) 
   ) 
   ORGANIZATION INDEX
   TABLESPACE BD50_IND
   ;

-- -----------------------------------------------------------------------------
--       TABLE : PORTER
-- -----------------------------------------------------------------------------

CREATE TABLE PORTER
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    ETAPE_NUM NUMBER(2)  NOT NULL,
    MAILLOT_COULEUR VARCHAR2(20)  NOT NULL,
    PART_NUM NUMBER(3)  NOT NULL 
,   CONSTRAINT PK_PORTER PRIMARY KEY (TOUR_ANNEE, ETAPE_NUM, MAILLOT_COULEUR) 
   )
   ORGANIZATION INDEX
   TABLESPACE BD50_IND
   ;

-- -----------------------------------------------------------------------------
--       TABLE : VOTER_SUPER_COMBATIF
-- -----------------------------------------------------------------------------

CREATE TABLE VOTER_SUPER_COMBATIF
   (
    TOUR_ANNEE NUMBER(4)  NOT NULL,
    SPE_NUM NUMBER(1)  NOT NULL,
    PART_NUM NUMBER(3)  NOT NULL  
,   CONSTRAINT PK_VOTER_SUPER_COMBATIF PRIMARY KEY (TOUR_ANNEE, SPE_NUM)
   )
   ORGANIZATION INDEX
   TABLESPACE BD50_IND
   ;
