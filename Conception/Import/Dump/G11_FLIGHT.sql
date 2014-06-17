--------------------------------------------------------
--  DDL for Procedure G11_FLIGHT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."G11_FLIGHT" UI_AFF_SELECT_TOURS IS
CURSOR c_tour IS SELECT tour_annee FROM tour ORDER BY tour_annee ASC;
v_tour c_tour.TYPE;
BEGIN
	htp.print('<select name="select_tour">');
	OPEN c_tour;
	LOOP
		FETCH c_tour IN v_tour;
		EXIT WHEN c_tour%NOTFOUND;
		htp.print('"<option value="' || v_tour.tour_annee || '">' || v_tour.tour_annee || '</option>\n");
	END LOOP;
	htp.print('</select>');
END UI_ADD_SELECT_TOUR

/
