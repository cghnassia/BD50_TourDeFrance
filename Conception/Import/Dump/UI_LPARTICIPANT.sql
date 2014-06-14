--------------------------------------------------------
--  DDL for Procedure UI_LPARTICIPANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_LPARTICIPANT" 
  (crit_nom varchar2 default '%',crit_pnom varchar2 default '%') IS
	CURSOR cur_part IS 
		SELECT 
			* 
		FROM 
			participant 
		WHERE 
			tour_annee=GETSELECTEDTOUR 
		AND UPPER(cycliste_nom) like UPPER('%'||crit_nom||'%')
		AND UPPER(cycliste_prenom) like UPPER('%'||crit_pnom||'%')
		ORDER BY part_num;

	cpt number(3) := 0;
	prev equipe.equipe_num%TYPE := 0;
BEGIN
  UI_HEAD;
  UI_HEADER;
  UI_MAIN_OPEN;
    htp.print('
		<div class="row">
			<div class="col">
				<h2>Participants</h2>
			</div>
			<div class="col">');
				htp.print('<div class="w90 txtleft">');
				htp.FORmopen(curl=>'ui_lparticipant', cmethod=>'POST');
				htp.print('Nom:');
				htp.FORmtext('crit_nom');
				htp.print('Prénom:');
				htp.FORmtext('crit_pnom');
				htp.FORmsubmit(cvalue=>'OK');
				htp.FORmclose;
				htp.print('</div>');
     htp.print('</div>
		</div>
		<div class="row separation2"></div></br>');
		
	FOR recpart in cur_part LOOP
		cpt:=cpt+1;
		IF (recpart.equipe_num!=prev AND prev=0) THEN
			htp.print('
			<div class="w80 center">'||htf.anchor ('ui_detail_equipe?n_equipe=' || recpart.equipe_num,recpart.equipe_nom)||'</div>');
			
			htp.tableOpen(cattributes => 'class="normalTab"');
			htp.tableheader('',cattributes => 'class="col2"');
			htp.tableheader('');
			htp.tableheader('');
			htp.tableheader('');
			
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
    
			htp.tableData(recpart.part_num);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom));
			htp.tableData(recpart.cycliste_prenom);
			htp.tableData(recpart.cycliste_pays);
			htp.tableRowClose;
    
			prev:=recpart.equipe_num; 
    
		ELSIF(recpart.equipe_num!=prev AND prev!=0) THEN
			htp.tableClose;
			htp.print('</br>
			<div class="w80 center">'||htf.anchor ('ui_detail_equipe?n_equipe=' || recpart.equipe_num,recpart.equipe_nom)||'</div>');
			htp.tableOpen(cattributes => 'class="normalTab"');
			htp.tableheader('',cattributes => 'class="col2"');
			htp.tableheader('');
			htp.tableheader('');
			htp.tableheader('');
      
             IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
    
			htp.tableData(recpart.part_num);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom));
			htp.tableData(recpart.cycliste_prenom);
			htp.tableData(recpart.cycliste_pays);
			htp.tableRowClose;
    
			prev:=recpart.equipe_num;
			
		ELSE
			IF(mod(cpt,2)=0) THEN
				htp.tableRowOpen(cattributes => 'class="rowP"');
			ELSE
				htp.tableRowOpen;
			END IF;
			
			htp.tableData(recpart.part_num);
			htp.tableData(htf.anchor ('ui_detail_participant?n_part=' || recpart.part_num,recpart.cycliste_nom));
			htp.tableData(recpart.cycliste_prenom);
			htp.tableData(recpart.cycliste_pays);
			htp.tableRowClose;
		END IF;
	END LOOP;
  UI_MAIN_CLOSE;
END UI_LPARTICIPANT;

/
