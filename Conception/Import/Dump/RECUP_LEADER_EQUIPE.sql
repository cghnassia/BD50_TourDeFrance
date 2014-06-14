--------------------------------------------------------
--  DDL for Function RECUP_LEADER_EQUIPE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_LEADER_EQUIPE" (numetape porter.etape_num%type )
return equipe%rowtype IS
nequipe equipe.equipe_num%type;
vequipe equipe%rowtype;
begin

  select equipe_num into nequipe
  from (select * from terminer_etape_equipe order by gene_equi_class asc)
  where tour_annee=getselectedtour
  and etape_num = numetape
  and rownum = 1;
  
  
select * into vequipe from equipe eq where eq.equipe_num=nequipe and tour_annee=getselectedtour;
return vequipe;

exception
  when others then
   --htp.print('Aucun porteur de maillot pour cette étape');
   return null;


end recup_leader_equipe;

/
