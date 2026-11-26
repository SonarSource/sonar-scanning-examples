REPORT ZBCMKZ17.
*----------------------------------------------------------------------*
* Description:   Report and Transaction Starter                        *
*                It shows an individual list of reports/Trans. to start*
*                                                                      *
* Authorization: S_PROGRAM, Reports starten                            *
*                                                                      *
* Class:         Utility                                               *
*                                                                      *
* Customizing:   Needs Customer Table: ZBCMKZ1                         *
*  Field:                Key Type        Length    Descr.              *
*  ZBCMKZ1-BNAME         X   CHAR C     12         User name           *
*  ZBCMKZ1-NAME          X   CHAR C      8         Report/Trans. code  *
*  ZBCMKZ1-NUMMER            INT1 X      1         Priority level      *
*                                                                      *
* R/3 Release:   3.0d                                                  *
*                                                                      *
* Programmer:    Bence Toth                                            *
* Date:          1997 April                                            *
*                                                                      *
*----------------------------------------------------------------------*
INCLUDE: <ICON>.
TABLES: ZBCMKZ1, TRDIR, TSTCT, TSTC.
DATA: BEGIN OF BTAB OCCURS 50,         "Hilfstabelle fuer Textpool
            TAB LIKE TEXTPOOL,
      END OF BTAB.
DATA: BEGIN OF T OCCURS 100,
     NUMMER LIKE ZBCMKZ1-NUMMER,
     NAME LIKE TRDIR-NAME,
            CODE(82),
END OF T.
DATA: FI(20).
DATA BEGIN OF BDCDATA OCCURS 100.
        INCLUDE STRUCTURE BDCDATA.
DATA END OF BDCDATA.

DATA BEGIN OF MESSTAB OCCURS 10.
        INCLUDE STRUCTURE BDCMSGCOLL.
DATA END OF MESSTAB.

DATA RPT_FLAG.
AUTHORITY-CHECK OBJECT 'S_PROGRAM'
         ID 'P_GROUP' FIELD '*'
         ID 'P_ACTION' FIELD '*'.
IF SY-SUBRC NE 0. EXIT. ENDIF.
WRITE: /2 'Er. Modus', 12 'Name', 22 'Text'.


DETAIL.
SKIP.
SELECT * FROM ZBCMKZ1 WHERE BNAME EQ SY-UNAME.
  CHECK ZBCMKZ1-NAME+5(1) EQ ' '.
  SELECT SINGLE * FROM TSTC WHERE TCODE EQ ZBCMKZ1-NAME.
  CHECK SY-SUBRC EQ 0.
  CLEAR TSTCT.
  SELECT SINGLE * FROM TSTCT WHERE SPRSL EQ SY-LANGU AND
                                   TCODE EQ ZBCMKZ1-NAME.
  T-CODE = TSTCT-TTEXT.
  MOVE-CORRESPONDING ZBCMKZ1 TO T.
  APPEND T.
  CLEAR T.
ENDSELECT.
SORT T BY NUMMER CODE.
RPT_FLAG = ' '.
PERFORM LIST CHANGING RPT_FLAG.
SELECT * FROM ZBCMKZ1  WHERE BNAME EQ SY-UNAME.
  CHECK ZBCMKZ1-NAME+5(1) NE ' '.
  CALL FUNCTION 'RPY_TEXTPOOL_READ'
       EXPORTING
            PROGRAM_NAME       = ZBCMKZ1-NAME
            LANGUAGE           = SY-LANGU
       TABLES
            TEXTPOOL           = BTAB
       EXCEPTIONS
            CANCELLED          = 1
            PERMISSION_FAILURE = 2
            OTHERS             = 3.
  CHECK SY-SUBRC EQ 0.
  LOOP AT BTAB.
    IF BTAB-TAB-ID EQ 'R'.
      EXIT.
    ENDIF.
  ENDLOOP.
  MOVE BTAB-TAB-ENTRY TO T-CODE.
  MOVE-CORRESPONDING ZBCMKZ1 TO T.
  APPEND T.
  CLEAR T.
ENDSELECT.
SORT T BY NUMMER CODE.
RPT_FLAG = 'X'.
PERFORM LIST CHANGING RPT_FLAG.

AT LINE-SELECTION.
  CHECK NOT ( T-NAME IS INITIAL ).
  GET CURSOR FIELD FI.
    IF T-NAME+5(1) EQ ' '.
      RPT_FLAG = ' '.
    ELSE.
      RPT_FLAG = 'X'.
  ENDIF.
  IF FI = 'ICON_EXECUTE_OBJECT'.
    PERFORM PERO USING T-NAME RPT_FLAG.
  ELSEIF RPT_FLAG EQ ' '.
* SELECT SINGLE * FROM TSTC WHERE TCODE EQ ZBCMKZ1-NAME.
* IF T+5(1) EQ ' '.
    CALL TRANSACTION T-NAME.
  ELSE.
    SUBMIT (T-NAME) VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
  CLEAR T-NAME.
*---------------------------------------------------------------------*
*       FORM LIST                                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM LIST CHANGING RPT_FLAG.
  LOOP AT T.
    IF RPT_FLAG = ' '.
      WRITE: /5 ICON_EXECUTE_OBJECT AS ICON, T-NAME UNDER 'Name',
                 T-CODE UNDER 'Text'.
    ELSE.
      WRITE: / T-NAME UNDER 'Name', T-CODE UNDER 'Text'.
    ENDIF.
  HIDE T.
    AT END OF NUMMER.
      SKIP.
    ENDAT.
  ENDLOOP.
  SKIP.
  CLEAR T.
  REFRESH T.
ENDFORM.
*---------------------------------------------------------------------*
*       FORM PERO                                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  T-NAME                                                        *
*---------------------------------------------------------------------*
FORM PERO USING T-NAME RPT_FLAG.
  CHECK RPT_FLAG EQ ' '.
  MOVE T-NAME TO T-NAME+2(4).
  MOVE '/o' TO T-NAME+0(2).
  BDCDATA-PROGRAM  = 'SAPMS01J'.
  BDCDATA-DYNPRO   = '0310'.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
  CLEAR BDCDATA.
  BDCDATA-FNAM     = 'BDC_OKCODE'.
  BDCDATA-FVAL     = T-NAME.
  APPEND BDCDATA.
  CALL TRANSACTION 'SU50'  USING BDCDATA  MODE 'N'
                           MESSAGES INTO MESSTAB.
  CLEAR BDCDATA.
  REFRESH BDCDATA.
ENDFORM.
