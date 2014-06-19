--------------------------------------------------------
--  DDL for Package UI_ADMINISTRATION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."UI_ADMINISTRATION" AS 

 PROCEDURE UI_GESTION;

 PROCEDURE UI_HEADER_ADMIN;
 
 PROCEDURE UI_FORM_PASSER (
  v_etape_num etape.etape_num%TYPE default 1, 
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 1,
  v_part_num participant.part_num%TYPE default 0,
  v_temps VARCHAR2 default '',
  v_code NUMBER default 0,
  v_message VARCHAR2 default NULL);
  
  PROCEDURE              UI_EXECFORM_PASSER (
	select_etape etape.etape_num%TYPE default 1,
	select_passage point_passage.pt_pass_num%TYPE default 1,
	select_participant participant.part_num%TYPE default 0,
  text_temps VARCHAR2 DEFAULT '',
  button_submit VARCHAR2 DEFAULT NULL);


	PROCEDURE              UI_AFF_SELECT_POINT_PASSAGES (
	v_etape_num etape.etape_num%TYPE default 1,
  v_pt_pass_num point_passage.pt_pass_num%TYPE default 1);
  
  PROCEDURE              UI_AFF_SELECT_PARTICIPANTS (
	v_etape_num etape.etape_num%TYPE default 1,
	v_pt_pass_num point_passage.pt_pass_num%TYPE default 1,
	v_part_num participant.part_num%TYPE default 0);
  
  PROCEDURE              UI_AFF_SELECT_ETAPES (
  v_etape_num etape.etape_num%TYPE default 1);
  
END UI_ADMINISTRATION;

/