--------------------------------------------------------
--  DDL for Procedure UI_AFF_SELECT_TOURS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_AFF_SELECT_TOURS" IS
CURSOR c_tour IS 
SELECT tour_annee FROM tour ORDER BY tour_annee ASC;
v_tour c_tour%ROWTYPE;
BEGIN
	htp.print('<div><span>Tour</span><select name="select_tour">\n');
	OPEN c_tour;
	LOOP
		FETCH c_tour INTO v_tour;
		EXIT WHEN c_tour%NOTFOUND;
		htp.print('"<option value="' || v_tour.tour_annee || '">' || v_tour.tour_annee || '</option>\n');
	END LOOP;
	htp.print('</select></div>');
END UI_AFF_SELECT_TOURS;

/
