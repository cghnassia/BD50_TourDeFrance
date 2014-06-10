--------------------------------------------------------
--  DDL for Procedure UI_SELECT_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_SELECT_TOUR" (vtour varchar2 default 2013) is
cursor ltour is select tour_annee from tour order by 1;
ftour tour%ROWTYPE;
begin
  /*Formulaire de sélection du Tour*/
  htp.formopen(curl=>'maj_selected_tour', cmethod=>'POST');
	htp.print('Tour:');
  htp.formselectopen('vtour');
	for crec in ltour loop
    if (crec.tour_annee=vtour) then
      htp.formselectoption(crec.tour_annee,crec.tour_annee);
    else
      htp.formselectoption(crec.tour_annee);
    end if;
	end loop ;
  htp.formSelectClose;
  htp.formhidden('prev_url',owa_util.get_procedure);
	htp.formsubmit(cvalue=>'OK');
	htp.formclose;
  /*********************************/
end;

/
