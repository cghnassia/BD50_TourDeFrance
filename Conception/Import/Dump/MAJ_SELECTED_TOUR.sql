--------------------------------------------------------
--  DDL for Procedure MAJ_SELECTED_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."MAJ_SELECTED_TOUR" 
(v_tour varchar2,prev_url varchar2) IS
BEGIN
	owa_cookie.remove('Tour',null);
	owa_util.mime_header('text/html', FALSE);
	owa_cookie.send(
		name=>'Tour',
		value=>v_tour
	);
	owa_util.redirect_url(prev_url);
    owa_util.http_header_close;
END MAJ_SELECTED_TOUR;

/
