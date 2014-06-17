-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CYCLISTE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_CYCLISTE_PAYS;
	
DROP INDEX IR_CYCLISTE_NOM_PRENOM;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PARTICIPANT
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_PARTICIPANT_TOUR;

DROP INDEX I_FK_PARTICIPANT_EQUIPE;

DROP INDEX I_FK_PARTICIPANT_POINT_PASSAGE;

DROP INDEX I_FK_PARTICIPANT_CYCLISTE;
	
DROP INDEX IR_PARTICIPANT_CYCLISTE_NP;
	
DROP INDEX IR_PARTICIPANT_EQUIPE_NOM;
	
DROP INDEX IT_PARTICIPANT_CLASS_GENE

DROP INDEX IT_PARTICIPANT_CLASS_MONT;

DROP INDEX IT_PARTICIPANT_CLASS_SPRINT;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE BAREME
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_BAREME_CATEGORIE;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE EQUIPE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_EQUIPE_TOUR;

DROP INDEX I_FK_EQUIPE_PAYS;

DROP INDEX IR_EQUIPE_NOM;

DROP INDEX IT_EQUIPE_CLASS_GENE;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VILLE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_VILLE_PAYS;

DROP INDEX IR_VILLE_NOM;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE POINT_PASSAGE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_POINT_PASSAGE_VILLE;

DROP INDEX I_FK_POINT_PASSAGE_CATEGORIE;

DROP INDEX I_FK_POINT_PASSAGE_ETAPE;

DROP INDEX I_FK_POINT_PASSAGE_UTILISATEUR;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CONTROLE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_CONTROLE_PARTICIPANT;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE ETAPE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_ETAPE_TOUR;

DROP INDEX I_FK_ETAPE_VILLE;

DROP INDEX I_FK_ETAPE_VILLE2;

DROP INDEX IR_ETAPE_NOM;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TOUR
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_TOUR_PARTICIPANT;

DROP INDEX I_FK_TOUR_UTILISATEUR;

DROP INDEX I_FK_TOUR_UTILISATEUR2;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE DIRIGER
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_DIRIGER_EQUIPE;

DROP INDEX I_FK_DIRIGER_DIRECTEUR_SPORTIF;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CONSULTER
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_CONSULTER_TOUR;

DROP INDEX I_FK_CONSULTER_UTILISATEUR;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TERMINER_ETAPE_EQUIPE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_TERMINER_ETAPE_EQUIPE_EQU;

DROP INDEX I_FK_TERMINER_ETAPE_EQUIPE_ETA;

DROP INDEX IT_TERMINER_ETAPE_EQUIPE_CLASS;

DROP INDEX IT_TERMINER_ETAPE_EQUIPE_CG;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VOTER_COMBATIF
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_VOTER_COMBATIF_SPECIALIST;

DROP INDEX I_FK_VOTER_COMBATIF_ETAPE;

DROP INDEX I_FK_VOTER_COMBATIF_PARTICIPAN;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE TERMINER_ETAPE
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_TERMINER_ETAPE_PARTICIPAN;

DROP INDEX I_FK_TERMINER_ETAPE_ETAPE;

DROP INDEX IT_TERMINER_ETAPE_CLASS;

DROP INDEX IT_TERMINER_ETAPE_CLASS_GENE;

DROP INDEX IT_TERMINER_ETAPE_GENE_MONT;

DROP INDEX IT_TERMINER_ETAPE_GENE_SPRINT;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PORTER
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_PORTER_PARTICIPANT;

DROP INDEX I_FK_PORTER_ETAPE;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PASSER
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_PASSER_POINT_PASSAGE;

DROP INDEX I_FK_PASSER_PARTICIPANT;


-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VOTER_SUPER_COMBATIF
-- -----------------------------------------------------------------------------

DROP INDEX I_FK_VOTER_SUPER_COMBATIF_PART;

DROP INDEX I_FK_VOTER_SUPER_COMBATIF_TOUR;

DROP INDEX I_FK_VOTER_SUPER_COMBATIF_SPEC;

