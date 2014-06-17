--------------------------------------------------------
--  Fichier créé - mardi-juin-17-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body UI_UTILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "G11_FLIGHT"."UI_UTILS" AS 

  --Fonction de récupération d'une valeur de cookie
  FUNCTION getCookieValue(c_name varchar2) RETURN varchar2 IS
    cookie OWA_COOKIE.COOKIE;
  BEGIN
    cookie := OWA_COOKIE.GET(c_name);
    return cookie.VALS(1);
  END getCookieValue;
  
  --Test si un cookie existe
  FUNCTION existCookie(c_name varchar2) RETURN boolean IS
    cookie OWA_COOKIE.COOKIE;
  BEGIN
    cookie := OWA_COOKIE.GET(c_name);
    if(cookie.num_vals > 0) then
      return TRUE;
    else
      return FALSE;
    end if;
  END existCookie;
  
  --Creation de cookie
  PROCEDURE createCookie (c_name varchar2,c_value varchar2) IS
  BEGIN
 owa_util.http_header_close;
	owa_cookie.send(
		name=>'c_name',
		value=>c_value
	);
  owa_util.mime_header('text/html', FALSE);
  END createCookie;
  
  --Suppression de cookie
  PROCEDURE removeCookie(c_name varchar2) IS
  BEGIN
  owa_cookie.remove(c_name,null);
  END removeCookie;
  
  
  --Retourne le Tour sélectionné
  FUNCTION getSelectedTour  RETURN varchar2 IS
  a_tour varchar2(4);
  BEGIN
   if(ui_utils.existCookie('Tour')) then
     a_tour  := getCookieValue('Tour');
  else
     a_tour := db_commun.getLastTour;
  end if;
   RETURN a_tour;
   END getSelectedTour;

  --Retourne l'étape selectionnée
  FUNCTION getSelectedEtape  RETURN varchar2 IS
  n_etape varchar2(4);
  BEGIN
   if(ui_utils.existCookie('Etape')) then
     n_etape  := getCookieValue('Etape');
  else
     n_etape := db_commun.getLastEtape;
  end if;
  RETURN n_etape;
  END getSelectedEtape;
  
  PROCEDURE COLOR_ROW_P (cpt number default 0) IS
 BEGIN
	IF(mod(cpt,2)=0) THEN
				  htp.tableRowOpen(cattributes => 'class="rowP"');
			  ELSE
			   htp.tableRowOpen;
			  END IF;
 END COLOR_ROW_P;
 
 PROCEDURE MAJ_SELECTED_TOUR (v_tour varchar2,prev_url varchar2) IS
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
  
  
  PROCEDURE MAJ_SELECTED_ETAPE (n_etape varchar2,prev_url varchar2) IS
  BEGIN
	owa_cookie.remove('Etape',null);
	owa_util.mime_header('text/html', FALSE);
	owa_cookie.send(
		name=>'Etape',
		value=>n_etape
	);
	owa_util.redirect_url(prev_url);
	owa_util.http_header_close;
  END MAJ_SELECTED_ETAPE;
  
  FUNCTION FORMATED_TIME (time_number NUMBER)RETURN VARCHAR2 IS
  v_formated_time VARCHAR2(20);
  v_time  NUMBER(10, 0);
  v_tenths NUMBER(2, 0);
  v_seconds NUMBER(2, 0);
  v_minuts NUMBER(2, 0);
  v_hours NUMBER(3, 0);
  BEGIN
  v_time := time_number;
  
	v_tenths := MOD(v_time, 10);
  
  v_time := FLOOR(v_time / 10);
  v_seconds := MOD(v_time, 60);
    
  v_time := FLOOR(v_time / 60);
  v_minuts := MOD(v_time, 60);

  v_hours := FLOOR(v_time / 60);
  
  IF v_hours != 0 THEN
    v_formated_time := v_hours || 'h ';
  END IF;
  
  IF v_hours != 0 AND v_minuts < 10 THEN
    v_formated_time := v_formated_time || '0';
  END IF;
  
  IF v_hours != 0 OR v_minuts != 0 THEN
    v_formated_time := v_formated_time || v_minuts || ''' ';
  END IF;
  
  IF (v_hours != 0 OR v_minuts != 0) AND v_seconds < 10 THEN
    v_formated_time := v_formated_time || '0';
  END IF;
  
  IF v_hours != 0 OR v_minuts != 0 OR v_seconds != 0 THEN
    v_formated_time := v_formated_time || v_seconds || ''''' ';
  END IF;
  
  RETURN v_formated_time;
--EXCEPTION
--  WHEN OTHERS THEN dbms_output.put_line('Erreur');
  END FORMATED_TIME;

END UI_UTILS;

/
