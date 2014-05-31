create or replace 
PROCEDURE UI_INS_PT_PASS (
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


create or replace PROCEDURE UI_INS_PASSER (
  vtour in passer.tour_annee%type,
  vetapenum in passer.etape_num%type,
  vpassnum in passer.pt_pass_num%type,
  vpartum in passer.part_num%type,
  vtps in passer.pass_tps%type
)
AS 
BEGIN
	insert into passer
		(tour_annee,etape_num,pt_pass_num,part_num,pass_tps)
	values 
		(vtour,vetapenum,vpassnum,vpartum,vtps);
	commit;
END UI_INS_EQUIPE;
/

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


