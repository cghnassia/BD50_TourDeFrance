-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CYCLISTE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_CYCLISTE_PAYS
     ON CYCLISTE (PAYS_NUM ASC)
	 TABLESPACE BD50_IND
    ;
	
CREATE  INDEX IR_CYCLISTE_NOM_PRENOM
     ON CYCLISTE (CYCLISTE_NOM,CYCLISTE_PRENOM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PARTICIPANT
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_PARTICIPANT_TOUR
     ON PARTICIPANT (TOUR_ANNEE ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_PARTICIPANT_EQUIPE
     ON PARTICIPANT (EQUIPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_PARTICIPANT_POINT_PASSAGE
     ON PARTICIPANT (TOUR_ANNEE ASC, ETAPE_NUM ASC, PT_PASS_NUM ASC)
    TABLESPACE BD50_IND
	;


CREATE  INDEX I_FK_PARTICIPANT_CYCLISTE
     ON PARTICIPANT (CYCLISTE_NUM ASC)
	 TABLESPACE BD50_IND
    ;
	
CREATE  INDEX IR_PARTICIPANT_CYCLISTE_NP
     ON PARTICIPANT (CYCLISTE_NOM,CYCLISTE_PRENOM ASC)
	 TABLESPACE BD50_IND
    ;
	
CREATE  INDEX IR_PARTICIPANT_EQUIPE_NOM
     ON PARTICIPANT (EQUIPE_NOM ASC)
	 TABLESPACE BD50_IND
    ;
	
CREATE  INDEX IT_PARTICIPANT_CLASS_GENE
     ON PARTICIPANT (PART_CLASS_GENE ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_PARTICIPANT_CLASS_MONT
     ON PARTICIPANT (PART_CLASS_MONT ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_PARTICIPANT_CLASS_SPRINT
     ON PARTICIPANT (PART_CLASS_SPRINT ASC)
	 TABLESPACE BD50_IND
    ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE BAREME
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_BAREME_CATEGORIE
     ON BAREME (CAT_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE EQUIPE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_EQUIPE_TOUR
     ON EQUIPE (TOUR_ANNEE ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_EQUIPE_PAYS
     ON EQUIPE (PAYS_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IR_EQUIPE_NOM
     ON EQUIPE (EQUIPE_NOM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_EQUIPE_CLASS_GENE
     ON EQUIPE (EQUIPE_CLASS_GENE ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VILLE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_VILLE_PAYS
     ON VILLE (PAYS_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IR_VILLE_NOM
     ON VILLE (VILLE_NOM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE POINT_PASSAGE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_POINT_PASSAGE_VILLE
     ON POINT_PASSAGE (VILLE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_POINT_PASSAGE_CATEGORIE
     ON POINT_PASSAGE (CAT_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_POINT_PASSAGE_ETAPE
     ON POINT_PASSAGE (TOUR_ANNEE ASC, ETAPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_POINT_PASSAGE_UTILISATEUR
     ON POINT_PASSAGE (UTIL_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CONTROLE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_CONTROLE_PARTICIPANT
     ON CONTROLE (TOUR_ANNEE ASC, PART_NUM ASC)
	 TABLESPACE BD50_IND
    ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE ETAPE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_ETAPE_TOUR
     ON ETAPE (TOUR_ANNEE ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_ETAPE_VILLE
     ON ETAPE (VILLE_NUM_FINIR ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_ETAPE_VILLE2
     ON ETAPE (VILLE_NUM_DEBUTER ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IR_ETAPE_NOM
     ON ETAPE (ETAPE_NOM ASC)
	 TABLESPACE BD50_IND
    ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TOUR
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_TOUR_PARTICIPANT
     ON TOUR (TOUR_ANNEE ASC, SUPER_COMBATIF_NUM ASC)
    ;

CREATE  INDEX I_FK_TOUR_UTILISATEUR
     ON TOUR (UTIL_NUM_MANAGER ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_TOUR_UTILISATEUR2
     ON TOUR (UTIL_NUM_ADMINISTRER ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE DIRIGER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_DIRIGER_EQUIPE
     ON DIRIGER (TOUR_ANNEE ASC, EQUIPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_DIRIGER_DIRECTEUR_SPORTIF
     ON DIRIGER (DIRS_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CONSULTER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_CONSULTER_TOUR
     ON CONSULTER (TOUR_ANNEE ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_CONSULTER_UTILISATEUR
     ON CONSULTER (UTIL_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TERMINER_ETAPE_EQUIPE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_TERMINER_ETAPE_EQUIPE_EQU
     ON TERMINER_ETAPE_EQUIPE (TOUR_ANNEE ASC, EQUIPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_TERMINER_ETAPE_EQUIPE_ETA
     ON TERMINER_ETAPE_EQUIPE (ETAPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_TERMINER_ETAPE_EQUIPE_CLASS
     ON TERMINER_ETAPE_EQUIPE (ETAPE_EQUI_CLASS ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_TERMINER_ETAPE_EQUIPE_CG
     ON TERMINER_ETAPE_EQUIPE (GENE_EQUI_CLASS ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VOTER_COMBATIF
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_VOTER_COMBATIF_SPECIALIST
     ON VOTER_COMBATIF (SPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_VOTER_COMBATIF_ETAPE
     ON VOTER_COMBATIF (TOUR_ANNEE ASC, ETAPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_VOTER_COMBATIF_PARTICIPAN
     ON VOTER_COMBATIF (PART_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TERMINER_ETAPE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_TERMINER_ETAPE_PARTICIPAN
     ON TERMINER_ETAPE (TOUR_ANNEE ASC, PART_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_TERMINER_ETAPE_ETAPE
     ON TERMINER_ETAPE (ETAPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_TERMINER_ETAPE_CLASS
     ON TERMINER_ETAPE (ETAPE_CLASS ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_TERMINER_ETAPE_CLASS_GENE
     ON TERMINER_ETAPE (GENE_CLASS ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_TERMINER_ETAPE_GENE_MONT
     ON TERMINER_ETAPE (GENE_CLASS_MONT ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX IT_TERMINER_ETAPE_GENE_SPRINT
     ON TERMINER_ETAPE (GENE_CLASS_SPRINT ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PORTER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_PORTER_PARTICIPANT
     ON PORTER (PART_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_PORTER_ETAPE
     ON PORTER (TOUR_ANNEE ASC, ETAPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PASSER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_PASSER_POINT_PASSAGE
     ON PASSER (TOUR_ANNEE ASC, ETAPE_NUM ASC, PT_PASS_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_PASSER_PARTICIPANT
     ON PASSER (PART_NUM ASC)
	 TABLESPACE BD50_IND
    ;
-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VOTER_SUPER_COMBATIF
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_VOTER_SUPER_COMBATIF_PART
     ON VOTER_SUPER_COMBATIF (PART_NUM ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_VOTER_SUPER_COMBATIF_TOUR
     ON VOTER_SUPER_COMBATIF (TOUR_ANNEE ASC)
	 TABLESPACE BD50_IND
    ;

CREATE  INDEX I_FK_VOTER_SUPER_COMBATIF_SPEC
     ON VOTER_SUPER_COMBATIF (SPE_NUM ASC)
	 TABLESPACE BD50_IND
    ;