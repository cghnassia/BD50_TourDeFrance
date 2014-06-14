--------------------------------------------------------
--  DDL for Function FORMATED_TIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."FORMATED_TIME" (
      time_number NUMBER)
RETURN VARCHAR2 IS
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

/
