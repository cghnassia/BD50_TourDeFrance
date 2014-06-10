--------------------------------------------------------
--  DDL for Procedure UI_FOOTER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_FOOTER" is
path_css varchar2(255) := '/public/css/';

begin
	htp.print('
  <div id="footer" role="contentinfo" class="line pam txtcenter">
    Tour de France
	</div>
  </body>
  </html>');
end;

/
