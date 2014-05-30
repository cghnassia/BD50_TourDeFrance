-- -----------------------------------------------------------------------------
--       TRIGGER INSERTION AVEC SEQUENCE
-- -----------------------------------------------------------------------------

create or replace trigger TI_CYCLISTE
before insert on CYCLISTE 
for each row
begin
	if inserting then
	select seq_cycliste.nextval into :new.cycliste_num from dual;
	end if; 
end;
/

create or replace trigger TI_PAYS
before insert on PAYS 
for each row
begin
	if inserting then
	select seq_pays.nextval into :new.pays_num from dual;
	end if; 
end;
/

create or replace trigger TI_DIRS
before insert on DIRECTEUR_SPORTIF
for each row
begin
	if inserting then
	select seq_dirs.nextval into :new.dirs_num from dual;
	end if; 
end;
/

create or replace trigger TI_VILLE
before insert on VILLE 
for each row
begin
	if inserting then
	select seq_ville.nextval into :new.ville_num from dual;
	end if; 
end;
/

create or replace trigger TI_PAYS
before insert on PAYS 
for each row
begin
	if inserting then
	select seq_pays.nextval into :new.pays_num from dual;
	end if; 
end;
/

create or replace trigger TI_CATEGORIE
before insert on CATEGORIE 
for each row
begin
	if inserting then
	select seq_categorie.nextval into :new.cat_num from dual;
	end if; 
end;
/

create or replace trigger TI_UTILISATEUR
before insert on UTILISATEUR
for each row
begin
	if inserting then
	select seq_utilisateur.nextval into :new.util_num from dual;
	end if; 
end;
/

create or replace trigger TI_CONTROLE
before insert on CONTROLE
for each row
begin
	if inserting then
	select seq_controle.nextval into :new.contr_num from dual;
	end if; 
end;
/

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
--       TRIGGER INSERTION AVEC DONNEES CALCULEES ET REDONDANTES
-- -----------------------------------------------------------------------------

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
		select ville_nom into :new.pt_pass_ville_nom from ville where ville.ville_num = :new.ville_num;
		select etape_distance into distance from etape where etape.etape_num = :new.etape_num;
		:new.pt_pass_km_arr := distance-:new.pt_pass_km_dep;
	end if; 
end;
/


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
		select ville_nom into :new.ville_nom_debuter from ville where ville.ville_num = :new.ville_num_debuter;
		select ville_nom into :new.ville_nom_finir from ville where ville.ville_num = :new.ville_num_finir;
	end if; 
end;
/

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
	end if; 
end;
/








