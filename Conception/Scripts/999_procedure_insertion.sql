-- -----------------------------------------------------------------------------
--       GESTION DES INSCRIPTIONS
-- -----------------------------------------------------------------------------

-- TOUR --
create or replace PROCEDURE UI_INS_TOUR (
  vtour in tour.tour_annee%type,
  vedi in tour.tour_edition%type,
  vdated in tour.tour_dated%type,
  vdatef in tour.tour_datef%type,
  vnom in tour.tour_nom%type
)
AS 
BEGIN
	insert into tour
		(tour_annee,tour_edition,tour_dated,tour_datef,tour_nom)
	values 
		(vtour,vedi,vdated,vdatef,vnom);
	commit;
END UI_INS_TOUR;
/

-- CYCLISTE --
create or replace PROCEDURE UI_INS_CYCLISTE (
  vnom in cycliste.cycliste_nom%type,
  vprenom in cycliste.cycliste_prenom%type,
  vdate in cycliste.cycliste_daten%type,
  vpays in cycliste.pays_num%type
)
AS 
BEGIN
	insert into cycliste
		(cycliste_nom,cycliste_prenom,cycliste_daten,pays_num)
	values 
		(vnom,vprenom,vdate,vpays);
	commit;
END UI_INS_CYCLISTE;
/

-- EQUIPE --
create or replace PROCEDURE UI_INS_EQUIPE (
  vtour in equipe.tour_annee%type,
  vequinom in equipe.equipe_nom%type,
  vweb in equipe.equipe_web%type,
  vdesc in equipe.equipe_desc%type,
  vsponn in equipe.spon_nom%type,
  vspona in equipe.spon_acro%type,
  vpays in equipe.pays_num%type
)
AS 
BEGIN
	insert into equipe
		(tour_annee,equipe_nom,equipe_web,equipe_desc,spon_nom,spon_acro,pays_num)
	values 
		(vtour,vequinom,vweb,vdesc,vsponn,vspona,vpays);
	commit;
END UI_INS_EQUIPE;
/

-- PARTICIPANT --
create or replace PROCEDURE UI_INS_PARTICIPANT (
  vtour in participant.tour_annee%type,
  vpoids in participant.part_poids%type,
  vtaille in participant.part_taille%type,
  vequinum in participant.equipe_num%type,
  vcyclistenum in participant.cycliste_num%type
)
AS 
BEGIN
	insert into participant
		(tour_annee,part_poids,part_taille,equipe_num,cycliste_num)
	values 
		(vtour,vpoids,vtaille,vequinum,vcyclistenum);
	commit;
END UI_INS_PARTICIPANT;
/

-- DIRECTEUR SPORTIF --
create or replace PROCEDURE UI_INS_DIRS (
  vnom in directeur_sportif.dirs_nom%type,
  vprenom in directeur_sportif.dirs_prenom%type
)
AS 
BEGIN
	insert into directeur_sportif
		(dirs_nom,dirs_prenom)
	values 
		(vnom,vprenom);
	commit;
END UI_INS_DIRS;
/

-- DIRIGER --
create or replace PROCEDURE UI_INS_DIRIGER (
  vtour in diriger.tour_annee%type,
  vequi in diriger.equipe_num%type,
  vdirs in diriger.dirs_num%type
)
AS 
BEGIN
	insert into diriger
		(tour_annee,equipe_num,dirs_num)
	values 
		(vtour,vequi,vdirs);
	commit;
END UI_INS_DIRIGER;
/

-- -----------------------------------------------------------------------------
--       GESTION DES INSCRIPTIONS
-- -----------------------------------------------------------------------------

-- ETAPE --
create or replace PROCEDURE UI_INS_ETAPE (
  vtour in etape.tour_annee%type,
  vetapnom in etape.etape_nom%type,
  vdate in etape.etape_date%type,
  vdist in etape.etape_distance%type,
  vtlib in etape.tetape_lib%type,
  vnumd in etape.ville_num_debuter%type,
  vnumf in etape.ville_num_finir%type)
)
AS 
BEGIN
	insert into etape
		(tour_annee, etape_nom, etape_date, etape_distance, tetape_lib,ville_num_debuter,ville_num_finir)
	values 
		(vtour,vetapnom,vdate,vdist,vtlib,vnumd,vnumf);
	commit;
END UI_INS_ETAPE;
/

-- VILLE --
create or replace PROCEDURE UI_INS_VILLE (
  vnom in ville.ville_nom%type,
  vpays in ville.pays_num%type
)
AS 
BEGIN
	insert into ville
		(ville_nom,pays_num)
	values 
		(vnom,vpays);
	commit;
END UI_INS_VILLE;
/


-- -----------------------------------------------------------------------------
--       GESTION CLASSEMENT
-- -----------------------------------------------------------------------------

-- POINT PASSAGE --
create or replace PROCEDURE UI_INS_PT_PASS (
  vtour in point_passage.tour_annee%type,
  vetapenum in point_passage.etape_num%type,
  vpassnom in point_passage.pt_pass_nom%type,
  vkmdep in point_passage.pt_pass_km_dep%type,
  valt in point_passage.pt_pass_alt%type,
  vhor in point_passage.pt_pass_horaire%type,
  vvillenum in point_passage.ville_num%type,
  vcat in point_passage.cat_num%type
)
AS 
BEGIN
	insert into point_passage 
		(tour_annee, etape_num, pt_pass_nom, pt_pass_km_dep, pt_pass_alt, pt_pass_horaire,ville_num,cat_num)
	values 
		(vtour,vetapenum,vpassnom,vkmdep,valt,vhor,vvillenum,vcat);
	commit;
END UI_INS_PT_PASS;
/

-- PORTER --
create or replace PROCEDURE UI_INS_PORTER (
  vtour in porter.tour_annee%type,
  vetapenum in porter.etape_num%type,
  vmaillot in porter.maillot_couleur%type,
  vpartum in porter.part_num%type
)
AS 
BEGIN
	insert into porter
		(tour_annee,etape_num,maillot_couleur,part_num)
	values 
		(vtour,vetapenum,vmaillot,vpartum);
	commit;
END UI_INS_PORTER;
/

-- CATEGORIE --
create or replace PROCEDURE UI_INS_CATEGORIE (
  vcatlib in categorie.cat_lib%type,
  vmaillot in porter.maillot_couleur%type
)
AS 
BEGIN
	insert into categorie
		(cat_lib,maillot_couleur)
	values 
		(vcatlib,vmaillot);
	commit;
END UI_INS_CATEGORIE;
/

execute UI_INS_PASSER(2013,2,1,12,2,11,5,1);
select * from passer;
-- PASSER --
create or replace PROCEDURE UI_INS_PASSER (
  vtour in passer.tour_annee%type,
  vetapenum in passer.etape_num%type,
  vpassnum in passer.pt_pass_num%type,
  vpartum in passer.part_num%type,
  vtpsheu in number,
  vtpsmin in number,
  vtpssec in number,
  vtpscent in number
)
AS
vtps passer.pass_tps%type; 
BEGIN
	vtps:=converttemps(vtpsheu,vtpsmin,vtpsmin,vtpscent);
	insert into passer
		(tour_annee,etape_num,pt_pass_num,part_num,pass_tps)
	values 
		(vtour,vetapenum,vpassnum,vpartum,vtps);
	commit;
END UI_INS_PASSER;
/



-- -----------------------------------------------------------------------------
--       GESTION UTILISATEUR
-- -----------------------------------------------------------------------------

-- SPECIALISTE --
create or replace PROCEDURE UI_INS_SPECIALISTE (
  vnom in specialiste.spe_nom%type,
  vprenom in specialiste.spe_prenom%type

)
AS 
BEGIN
	insert into specialiste
		(spe_nom,spe_prenom)
	values 
		(vnom,vprenom);
	commit;
END UI_INS_SPECIALISTE;
/

-- VOTER COMBATIF --
create or replace PROCEDURE UI_INS_COMBATIF (
	vtour in voter_combatif.tour_annee%type,
	vetapenum in voter_combatif.etape_num%type,
	vspenum in voter_combatif.spe_num%type,
	vpartum in voter_combatif.part_num%type
)
AS 
BEGIN
	insert into voter_combatif
		(tour_annee,etape_num,spe_num,part_num)
	values 
		(vtour,vetapenum,vspenum,vpartum);
	commit;
END UI_INS_COMBATIF;
/

-- VOTER SUPER COMBATIF --
create or replace PROCEDURE UI_INS_SUPER_COMBATIF (
	vtour in voter_combatif.tour_annee%type,
	vspenum in voter_combatif.spe_num%type,
	vpartum in voter_combatif.part_num%type
)
AS 
BEGIN
	insert into voter_super_combatif
		(tour_annee,spe_num,part_num)
	values 
		(vtour,vspenum,vpartum);
	commit;
END UI_INS_SUPER_COMBATIF;
/


-- -----------------------------------------------------------------------------
--       GESTION UTILISATEUR
-- -----------------------------------------------------------------------------


-- UTILISATEUR --
create or replace PROCEDURE UI_INS_UTILISATEUR (
  vnom in utilisateur.util_nom%type,
  vmdp in utilisateur.util_mdp%type,
  vprofil in utilisateur.profil_lib%type
)
AS 
BEGIN
	insert into utilisateur
		(util_nom,util_mdp,profil_lib)
	values 
		(vnom,vmdp,vprofil);
	commit;
END UI_INS_UTILISATEUR;
/

-- CONSULTER --
create or replace PROCEDURE UI_INS_CONSULTER (
  vtour in consulter.tour_annee%type,
  vutil in consulter.util_num%type
)
AS 
BEGIN
	insert into consulter
		(tour_annee,util_num)
	values 
		(vtour,vutil);
	commit;
END UI_INS_CONSULTER;
/





