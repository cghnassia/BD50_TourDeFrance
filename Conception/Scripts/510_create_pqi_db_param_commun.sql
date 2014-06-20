--------------------------------------------------------
--  DDL for Package DB_PARAM_COMMUN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "G11_FLIGHT"."DB_PARAM_COMMUN" AS 

  TYPE ref_cur IS REF CURSOR;

  TYPE array_class_t IS table of varchar2(3) index by binary_integer;

  TYPE array_temps_t IS table of varchar2(10) index by binary_integer;

END DB_PARAM_COMMUN;

/