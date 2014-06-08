--------------------------------------------------------
--  DDL for Procedure MAJ_SELECTED_TOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."MAJ_SELECTED_TOUR" (vtour varchar2,prev_url varchar2) is
begin
  owa_cookie.remove('Tour',null);
  owa_util.mime_header('text/html', FALSE);
  owa_cookie.send(
    name=>'Tour',
    value=>vtour
  );
    owa_util.redirect_url(prev_url);
    owa_util.http_header_close;   
 
end;

/
