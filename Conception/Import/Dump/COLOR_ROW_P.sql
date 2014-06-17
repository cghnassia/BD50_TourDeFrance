--------------------------------------------------------
--  DDL for Procedure COLOR_ROW_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."COLOR_ROW_P" (cpt number default 0) IS
BEGIN
	IF(mod(cpt,2)=0) THEN
				  htp.tableRowOpen(cattributes => 'class="rowP"');
			  ELSE
			   htp.tableRowOpen;
			  END IF;
END COLOR_ROW_P;

/
