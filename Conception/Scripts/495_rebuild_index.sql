-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CYCLISTE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_CYCLISTE_PAYS REBUILD;
	
ALTER INDEX IR_CYCLISTE_NOM_PRENOM REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PARTICIPANT
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_PARTICIPANT_TOUR REBUILD;

ALTER INDEX I_FK_PARTICIPANT_EQUIPE REBUILD;

ALTER INDEX I_FK_PARTICIPANT_POINT_PASSAGE REBUILD;

ALTER INDEX I_FK_PARTICIPANT_CYCLISTE REBUILD;
	
ALTER INDEX IR_PARTICIPANT_CYCLISTE_NP REBUILD;
	
ALTER INDEX IR_PARTICIPANT_EQUIPE_NOM REBUILD;
	
ALTER INDEX IT_PARTICIPANT_CLASS_GENE REBUILD;

ALTER INDEX IT_PARTICIPANT_CLASS_MONT REBUILD;

ALTER INDEX IT_PARTICIPANT_CLASS_SPRINT REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE BAREME
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_BAREME_CATEGORIE REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE EQUIPE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_EQUIPE_TOUR REBUILD;

ALTER INDEX I_FK_EQUIPE_PAYS REBUILD;

ALTER INDEX IR_EQUIPE_NOM REBUILD;

ALTER INDEX IT_EQUIPE_CLASS_GENE REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VILLE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_VILLE_PAYS REBUILD;

ALTER INDEX IR_VILLE_NOM REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE POINT_PASSAGE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_POINT_PASSAGE_VILLE REBUILD;

ALTER INDEX I_FK_POINT_PASSAGE_CATEGORIE REBUILD;

ALTER INDEX I_FK_POINT_PASSAGE_ETAPE REBUILD;

ALTER INDEX I_FK_POINT_PASSAGE_UTILISATEUR REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CONTROLE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_CONTROLE_PARTICIPANT REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE ETAPE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_ETAPE_TOUR REBUILD;

ALTER INDEX I_FK_ETAPE_VILLE REBUILD;

ALTER INDEX I_FK_ETAPE_VILLE2 REBUILD;

ALTER INDEX IR_ETAPE_NOM REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TOUR
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_TOUR_PARTICIPANT REBUILD;

ALTER INDEX I_FK_TOUR_UTILISATEUR REBUILD;

ALTER INDEX I_FK_TOUR_UTILISATEUR2 REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE DIRIGER
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_DIRIGER_EQUIPE REBUILD;

ALTER INDEX I_FK_DIRIGER_DIRECTEUR_SPORTIF REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CONSULTER
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_CONSULTER_TOUR REBUILD;

ALTER INDEX I_FK_CONSULTER_UTILISATEUR REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TERMINER_ETAPE_EQUIPE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_TERMINER_ETAPE_EQUIPE_EQU REBUILD;

ALTER INDEX I_FK_TERMINER_ETAPE_EQUIPE_ETA REBUILD;

ALTER INDEX IT_TERMINER_ETAPE_EQUIPE_CLASS REBUILD;

ALTER INDEX IT_TERMINER_ETAPE_EQUIPE_CG REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VOTER_COMBATIF
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_VOTER_COMBATIF_SPECIALIST REBUILD;

ALTER INDEX I_FK_VOTER_COMBATIF_ETAPE REBUILD;

ALTER INDEX I_FK_VOTER_COMBATIF_PARTICIPAN REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TERMINER_ETAPE
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_TERMINER_ETAPE_PARTICIPAN REBUILD;

ALTER INDEX I_FK_TERMINER_ETAPE_ETAPE REBUILD;

ALTER INDEX IT_TERMINER_ETAPE_CLASS REBUILD;

ALTER INDEX IT_TERMINER_ETAPE_CLASS_GENE REBUILD;

ALTER INDEX IT_TERMINER_ETAPE_GENE_MONT REBUILD;

ALTER INDEX IT_TERMINER_ETAPE_GENE_SPRINT REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PORTER
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_PORTER_PARTICIPANT REBUILD;

ALTER INDEX I_FK_PORTER_ETAPE REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PASSER
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_PASSER_POINT_PASSAGE REBUILD;

ALTER INDEX I_FK_PASSER_PARTICIPANT REBUILD;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VOTER_SUPER_COMBATIF
-- -----------------------------------------------------------------------------

ALTER INDEX I_FK_VOTER_SUPER_COMBATIF_PART REBUILD;

ALTER INDEX I_FK_VOTER_SUPER_COMBATIF_TOUR REBUILD;

ALTER INDEX I_FK_VOTER_SUPER_COMBATIF_SPEC REBUILD;

