ALTER TABLE DIRECTEUR_SPORTIF ADD CONSTRAINT PK_DIRECTEUR_SPORTIF PRIMARY KEY (DIRS_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE CYCLISTE ADD CONSTRAINT PK_CYCLISTE PRIMARY KEY (CYCLISTE_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE CATEGORIE ADD CONSTRAINT PK_CATEGORIE PRIMARY KEY (CAT_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE UTILISATEUR ADD CONSTRAINT PK_UTILISATEUR PRIMARY KEY (UTIL_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE PARTICIPANT ADD CONSTRAINT PK_PARTICIPANT PRIMARY KEY (TOUR_ANNEE, PART_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE PAYS ADD CONSTRAINT PK_PAYS PRIMARY KEY (PAYS_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE BAREME ADD CONSTRAINT PK_BAREME PRIMARY KEY (CAT_NUM, BAREME_PLACE) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE EQUIPE ADD CONSTRAINT PK_EQUIPE PRIMARY KEY (TOUR_ANNEE, EQUIPE_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE VILLE ADD CONSTRAINT PK_VILLE PRIMARY KEY (VILLE_NUM)  USING INDEX TABLESPACE BD50_IND;

ALTER TABLE SPECIALISTE ADD CONSTRAINT PK_SPECIALISTE PRIMARY KEY (SPE_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE CONTROLE ADD CONSTRAINT PK_CONTROLE PRIMARY KEY (CONTR_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE ETAPE ADD CONSTRAINT PK_ETAPE PRIMARY KEY (TOUR_ANNEE, ETAPE_NUM) USING INDEX TABLESPACE BD50_IND;

ALTER TABLE TOUR ADD CONSTRAINT PK_TOUR PRIMARY KEY (TOUR_ANNEE) USING INDEX TABLESPACE BD50_IND;

-- -----------------------------------------------------------------------------
--       CREATION DES PK SUR LES TABLES PARTITIONNEES NON IOT
-- -----------------------------------------------------------------------------

ALTER TABLE POINT_PASSAGE ADD CONSTRAINT PK_POINT_PASSAGE PRIMARY KEY (TOUR_ANNEE, ETAPE_NUM, PT_PASS_NUM) USING INDEX TABLESPACE BD50_IND LOCAL;  
    