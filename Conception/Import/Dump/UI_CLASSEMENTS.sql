--------------------------------------------------------
--  DDL for Procedure UI_CLASSEMENTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_CLASSEMENTS" is
begin
  ui_head;
  ui_header;
  ui_class_gene_min;
  ui_class_mont_min;
  ui_class_sprint_min;
  ui_class_jeune_min;
  ui_class_equi_min;
  ui_footer;
end;

/
