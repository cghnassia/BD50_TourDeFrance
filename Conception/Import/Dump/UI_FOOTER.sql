--------------------------------------------------------
--  DDL for Procedure UI_FOOTER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_FOOTER" IS
	path_css varchar2(255) := '/public/css/';
BEGIN
	htp.print('
		<div id="footer" role="contentinfo" class="line pam txtcenter">
			Tour de France
		</div>
	</body>
	</html>');
END UI_FOOTER;

/
