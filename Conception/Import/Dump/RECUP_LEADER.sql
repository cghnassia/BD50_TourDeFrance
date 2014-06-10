--------------------------------------------------------
--  DDL for Function RECUP_LEADER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_LEADER" (vmaillot porter.maillot_couleur%type)
return participant%rowtype IS
npart participant.part_num%type;
max_etape etape.etape_num%type;
vpart participant%rowtype;
begin
select max(po.etape_num) into max_etape from porter po where po.tour_annee=getselectedtour and po.maillot_couleur=vmaillot ;
select distinct pa.part_num into npart from participant pa inner join porter po on pa.part_num = po.part_num and po.tour_annee = pa.tour_annee
where po.etape_num = max_etape
and po.tour_annee=getselectedtour
and po.maillot_couleur = vmaillot ;

select * into vpart from participant pa where pa.part_num=npart and tour_annee=getselectedtour;
return vpart;

end recup_leader;

/
