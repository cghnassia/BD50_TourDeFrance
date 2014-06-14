--------------------------------------------------------
--  DDL for Function RECUP_PORTEUR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "G11_FLIGHT"."RECUP_PORTEUR" (
      vmaillot porter.maillot_couleur%type,
      numetape porter.etape_num%type )
    RETURN participant%rowtype
  IS
    npart participant.part_num%type;
    vpart participant%rowtype;
  BEGIN
    IF (vmaillot='etape') THEN
      SELECT part_num
      INTO npart
      FROM terminer_etape
      WHERE tour_annee =getselectedtour
      AND etape_num    = numetape
      AND etape_class  = 1;
    ELSE
      SELECT DISTINCT po.part_num
      INTO npart
      FROM porter po
      INNER JOIN participant pa
      ON po.part_num         = pa.part_num
      WHERE po.etape_num     = numetape
      AND po.tour_annee      =getselectedtour
      AND po.maillot_couleur = vmaillot ;
    END IF;
    
    SELECT *
    INTO vpart
    FROM participant pa
    WHERE pa.part_num=npart
    AND tour_annee   =getselectedtour;
    RETURN vpart;
  EXCEPTION
  WHEN OTHERS THEN
    --htp.print('Aucun porteur de maillot pour cette étape');
    RETURN NULL;
  END recup_porteur;
  

/
