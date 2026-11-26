REPORT ZZBGS106  MESSAGE-ID Z1.
*----------------------------------------------------------------------*
* Description: Utillity used for downloading abap/4 source code and    *
*              text elements to the desktop using ws_download.         *
*              Is useful as backup or for transporting to another site.*
*              You must run this program in foreground/online due to   *
*              the use of ws_download throug the SAPGUI.               *
*                                                                      *
* Implementing The program is client independent.                      *
*                                                                      *
* Authoriza.   No Authorization check.                                 *
*                                                                      *
* Submitting:  Run by SA38, SE38.                                      *
*                                                                      *
* Parametre:   You can use generic values when filling the parameters  *
*              except for the Path.                                    *
*                                                                      *
* Customizing: No need for customization.                              *
*                                                                      *
* Change of    You only need to do the syntax check at releasechanges. *
* release:                                                             *
*                                                                      *
* R/3 Release: Developed and tested in R/3 Release:                    *
*              2.2F                                                    *
*              3.0D                                                    *
*                                                                      *
* Programmer:  Benny G. Serensen, BGS-Consulting                       *
* Date:        Nov 1996.                                               *
*                                                                      *
* Version  1
*-------------------------------Corrections----------------------------*
* Date        Userid     Correction     Text                           *
* 11.11.1996  BGS        :::::::::::::: Start of development           *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Tables                                                               *
*----------------------------------------------------------------------*
TABLES: TRDIR      "Application Masterdata
       .
*----------------------------------------------------------------------*
* Parameters                                                           *
*----------------------------------------------------------------------*
SELECT-OPTIONS: REPO FOR TRDIR-NAME.
PARAMETERS:     PATH(60) TYPE C DEFAULT 'C:\SAP\'.

*----------------------------------------------------------------------*
* Work Variables and internal tables                                   *
*----------------------------------------------------------------------*
DATA: BEGIN OF WA_TABSOURCE
       ,SOURCE(72) TYPE C
     ,END OF WA_TABSOURCE.
DATA: TABSOURCE LIKE TABLE OF WA_TABSOURCE.

DATA: BEGIN OF TABTEXT OCCURS 50
       ,TAB LIKE TEXTPOOL
     ,END OF TABTEXT.

DATA: BEGIN OF TABRDIR OCCURS 100
       ,RDIR LIKE TRDIR
     ,END OF TABRDIR.

DATA: FILENAME   LIKE RLGRAP-FILENAME
     ,MODE       TYPE C VALUE ' '
     ,RDIRROWS   TYPE I
     ,SOURCEROWS TYPE I
     ,RC         TYPE I
     ,LENGTH     TYPE I
     .
FIELD-SYMBOLS: <P> .

*----------------------------------------------------------------------*
* Constants                                                            *
*----------------------------------------------------------------------*
DATA: OK         TYPE I VALUE 0
     ,FAIL       TYPE I VALUE 1.

*----------------------------------------------------------------------*
* EVENT: validate users entries on the selection screen                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
DATA: I TYPE I.
  DESCRIBE TABLE REPO LINES I.
  IF I <= 0.
    SET CURSOR FIELD REPO.
    MESSAGE E065 WITH TEXT-101.
  ENDIF.

*----------------------------------------------------------------------*
* EVENT: Start-Of-Selection                                            *
*----------------------------------------------------------------------*
START-OF-SELECTION.
* Set slash at the end of path if not speciefied by user
  CONDENSE PATH NO-GAPS.
  LENGTH = STRLEN( PATH ) .
  SUBTRACT 1 FROM LENGTH.
  ASSIGN PATH+LENGTH(1) TO <P>.
  IF <P> <> '\'.
    ADD 1 TO LENGTH.
    ASSIGN PATH+LENGTH TO <P>.
    <P> = '\'.
  ENDIF.

  SELECT NAME FROM TRDIR INTO TABLE TABRDIR WHERE NAME IN REPO.
  DESCRIBE TABLE TABRDIR LINES RDIRROWS.
  CHECK RDIRROWS > 0.

* For every selected program:
  LOOP AT TABRDIR.
    MOVE TABRDIR TO TRDIR.
    PERFORM DOWNLOAD_SOURCE CHANGING RC.
    CHECK RC = OK.
    PERFORM DOWNLOAD_TEXTPOOL CHANGING RC.
  ENDLOOP.

*----------------------------------------------------------------------*
* FORM: Download_Sourcecode                                            *
*----------------------------------------------------------------------*
FORM DOWNLOAD_SOURCE CHANGING RC.
  RC = FAIL.
  CLEAR:   TABSOURCE, FILENAME.
  REFRESH: TABSOURCE.

  CALL FUNCTION 'RFC_READ_REPORT'
       EXPORTING
            PROGRAM   = TRDIR-NAME
       TABLES
            QTAB      = TABSOURCE
       EXCEPTIONS
            NOT_FOUND = 1
            OTHERS    = 2.
  CHECK SY-SUBRC = 0.

  DESCRIBE TABLE TABSOURCE LINES SOURCEROWS.
  CHECK SOURCEROWS > 0.

  CALL FUNCTION 'STRING_CONCATENATE_3'                "R. 2.2F
       EXPORTING                                      "R. 2.2F
            STRING1 = PATH                            "R. 2.2F
            STRING2 = TRDIR-NAME                      "R. 2.2F
            STRING3 = '.aba'                          "R. 2.2F
       IMPORTING                                      "R. 2.2F
            STRING = FILENAME                         "R. 2.2F
       EXCEPTIONS                                     "R. 2.2F
            TOO_SMALL = 01.                           "R. 2.2F
  CHECK SY-SUBRC = 0.

  CONDENSE FILENAME NO-GAPS.
  PERFORM DOWNLOAD TABLES TABSOURCE USING FILENAME RC.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: Download_Textpool                                              *
*----------------------------------------------------------------------*
FORM DOWNLOAD_TEXTPOOL CHANGING RC.
  RC = FAIL.
  CLEAR:   TABTEXT, FILENAME.
  REFRESH: TABTEXT.

  CALL FUNCTION 'RPY_TEXTPOOL_READ'
       EXPORTING
            PROGRAM_NAME       = TRDIR-NAME
            LANGUAGE           = SY-LANGU
       TABLES
            TEXTPOOL           = TABTEXT
       EXCEPTIONS
            CANCELLED          = 1
            PERMISSION_FAILURE = 2
            OTHERS             = 3.
  CHECK SY-SUBRC = 0.

  DESCRIBE TABLE TABTEXT LINES SOURCEROWS.
  CHECK SOURCEROWS > 0.

  CALL FUNCTION 'STRING_CONCATENATE_3'                "R. 2.2F
       EXPORTING                                      "R. 2.2F
            STRING1 = PATH                            "R. 2.2F
            STRING2 = TRDIR-NAME                      "R. 2.2F
            STRING3 = '.TXT'                          "R. 2.2F
       IMPORTING                                      "R. 2.2F
            STRING = FILENAME                         "R. 2.2F
       EXCEPTIONS                                     "R. 2.2F
            TOO_SMALL = 01.                           "R. 2.2F
  CHECK SY-SUBRC = 0.

  CONDENSE FILENAME NO-GAPS.
  PERFORM DOWNLOAD TABLES TABTEXT USING FILENAME RC.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: Download                                                       *
*----------------------------------------------------------------------*
FORM DOWNLOAD TABLES TABDATA USING FILENAME RC.

  RC = FAIL.
  CALL FUNCTION 'WS_DOWNLOAD'
    EXPORTING
      FILENAME            = FILENAME
      FILETYPE            = 'ASC'
      MODE                = MODE
    TABLES
      DATA_TAB            = TABDATA
    EXCEPTIONS
      FILE_OPEN_ERROR     = 1
      FILE_WRITE_ERROR    = 2
      INVALID_FILESIZE    = 3
      INVALID_TABLE_WIDTH = 4
      INVALID_TYPE        = 5
      NO_BATCH            = 6
      UNKNOWN_ERROR       = 7.
  IF SY-SUBRC <> OK.
    WRITE:/ SY-SUBRC, TEXT-100.
  ENDIF.
  RC = SY-SUBRC.

ENDFORM.
