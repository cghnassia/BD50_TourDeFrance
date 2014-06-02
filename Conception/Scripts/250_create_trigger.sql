-- -----------------------------------------------------------------------------
--       GESTION DES INSCRIPTIONS
-- -----------------------------------------------------------------------------


-- CYCLISTE --
create or replace trigger TI_CYCLISTE
before insert on CYCLISTE 
for each row
begin
	if inserting then
	select seq_cycliste.nextval into :new.cycliste_num from dual;
	end if; 
end;
/

-- PAYS --
create or replace trigger TI_PAYS
before insert on PAYS 
for each row
begin
	if inserting then
	select seq_pays.nextval into :new.pays_num from dual;
	end if; 
end;
/

-- DIRECTEUR_SPORTIF --
create or replace trigger TI_DIRS
before insert on DIRECTEUR_SPORTIF
for each row
begin
	if inserting then
	select seq_dirs.nextval into :new.dirs_num from dual;
	end if; 
end;
/

-- EQUIPE --
create or replace trigger TI_EQUIPE
before insert on EQUIPE
for each row
declare
nequipe number(2);
nbequipe number(2);
begin
	if inserting then
		select count(equ.equipe_num) into nbequipe from equipe equ where equ.tour_annee = :new.tour_annee;
			if(nbequipe=0) then
				nequipe:=0;
			else
				select max(equ.equipe_num) into nequipe from equipe equ where equ.tour_annee = :new.tour_annee;
			end if;
		:new.equipe_num:=nequipe+1;
		:new.equipe_pays := returnPays(:new.pays_num);
	end if; 
end;
/

-- PARTICIPANT --
create or replace trigger TI_PARTICIPANT
before insert on PARTICIPANT
for each row
declare
npart number(2);
nbpart number(2);
npays number(3);
begin
	if inserting then
		select count(par.part_num) into nbpart from participant par where par.tour_annee = :new.tour_annee AND par.equipe_num = :new.equipe_num;
		
			if(nbpart=0) then
				npart:=(:new.equipe_num-1)*10;
			else
				select max(par.part_num) into npart from participant par where par.tour_annee = :new.tour_annee AND par.equipe_num = :new.equipe_num;
			end if;
		:new.part_num:=npart+1;
		
		:new.cycliste_nom:=returnNomCycliste(:new.cycliste_num);
		:new.cycliste_prenom:=returnPrenomCycliste(:new.cycliste_num);
		:new.cycliste_daten:=returnDateCycliste(:new.cycliste_num);
	
		select cyc.pays_num into npays from cycliste cyc where cyc.cycliste_num = :new.cycliste_num;
		:new.cycliste_pays:=returnPays(npays);
		
		:new.equipe_nom:=returnNomEquipe(:new.equipe_num);
		
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION DE LA COURSE
-- -----------------------------------------------------------------------------


-- VILLE --
create or replace trigger TI_VILLE
before insert on VILLE 
for each row
begin
	if inserting then
	select seq_ville.nextval into :new.ville_num from dual;
	end if; 
end;
/

-- ETAPE --
create or replace trigger TI_ETAPE
before insert on ETAPE
for each row
declare
netape number(2);
nbetape number(2);
begin
	if inserting then
		select count(etape.etape_num) into nbetape from etape where etape.tour_annee = :new.tour_annee;
			if(nbetape=0) then
				netape:=0;
			else
				select max(etape.etape_num) into netape from etape where etape.tour_annee = :new.tour_annee;
			end if;
		:new.etape_num:=netape+1;
		:new.ville_nom_debuter := returnVille(:new.ville_num_debuter);
		:new.ville_nom_finir := returnVille(:new.ville_num_finir);
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION DU CLASSEMENT
-- -----------------------------------------------------------------------------


-- CATEGORIE --
create or replace trigger TI_CATEGORIE
before insert on CATEGORIE 
for each row
begin
	if inserting then
	select seq_categorie.nextval into :new.cat_num from dual;
	end if; 
end;
/

-- POINT_PASSAGE --
create or replace trigger TI_POINT_PASSAGE
before insert on POINT_PASSAGE
for each row
declare
distance number(3);
km_arr number(3);
npp number(3);
nbpp number(3);
begin
	if inserting then
		select count(pp.pt_pass_num) into nbpp from point_passage pp where pp.tour_annee = :new.tour_annee AND pp.etape_num = :new.etape_num ;
			if(nbpp=0) then
				npp:=0;
			else
				select max(pp.pt_pass_num) into npp from point_passage pp where pp.tour_annee = :new.tour_annee AND pp.etape_num = :new.etape_num;
			end if;
		:new.pt_pass_num:=npp+1;
		:new.pt_pass_ville_nom := returnVille(:new.ville_num);
		:new.pt_pass_km_arr := distance-:new.pt_pass_km_dep;
	end if; 
end;
/

-- PASSER --
create or replace 
trigger TI_PASSER
before insert on PASSER
for each row
declare
cl_part number(3);
v_passer passer%ROWTYPE;
CURSOR chk_class IS
    SELECT * FROM passer WHERE  pass_tps > :NEW.pass_tps
    and tour_annee = :new.tour_annee
    and etape_num = :new.etape_num
    and pt_pass_num = :new.pt_pass_num;
begin
	if inserting then
		select count(*) into cl_part from passer WHERE  pass_tps < :NEW.pass_tps
		and tour_annee = :new.tour_annee
		and etape_num = :new.etape_num
		and pt_pass_num = :new.pt_pass_num;
		
		cl_part:=cl_part+1;
		:new.pass_class:=cl_part;
		
		OPEN chk_class;
		LOOP
			cl_part:=cl_part+1;
			FETCH chk_class INTO v_passer;
			UPDATE PASSER SET pass_class = cl_part where v_passer.part_num = passer.part_num
			and v_passer.tour_annee = passer.tour_annee
			and v_passer.etape_num = passer.etape_num
			and v_passer.pt_pass_num = passer.pt_pass_num;
			EXIT WHEN chk_class%NOTFOUND;
		END LOOP;
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION COMBATIF
-- -----------------------------------------------------------------------------

-- SPECIALISTE --
create or replace trigger TI_SPECIALISTE
before insert on SPECIALISTE 
for each row
begin
	if inserting then
	select seq_specialiste.nextval into :new.spe_num from dual;
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION DOPAGE
-- -----------------------------------------------------------------------------

-- CONTROLE --
create or replace trigger TI_CONTROLE
before insert on CONTROLE
for each row
begin
	if inserting then
	select seq_controle.nextval into :new.contr_num from dual;
	end if; 
end;
/

-- -----------------------------------------------------------------------------
--       GESTION DES UTILISATEURS
-- -----------------------------------------------------------------------------

-- UTILISATEUR --
create or replace trigger TI_UTILISATEUR
before insert on UTILISATEUR
for each row
begin
	if inserting then
	select seq_utilisateur.nextval into :new.util_num from dual;
	end if; 
end;
/



