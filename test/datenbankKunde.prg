#include "Common.ch"
class datenbankKunden
   exported:
      method getNextId()
      method getByID(nId)
      method init()
      method getByName(cName)
      method getByAddresse(cAddresse)
      method add(oKunde)
      method getAll()
      method update(oKunde)
      method delete(oKunde)
   protected:
    method findBiggestId()
    method createKundenIfNeeded()
    method currRecordToKunde()
    var nCurrId
endclass

method datenbankKunden:init()
   ::createKundenIfNeeded()
   ::nCurrId := -1
RETURN self

METHOD datenbankKunden:currRecordToKunde()

   LOCAL oKunde := kunde():new()

   oKunde:init( ;
      AllTrim(kunden->NAME), ;
      AllTrim(kunden->ADDRESSE) )

   oKunde:nId := kunden->ID

RETURN oKunde

method datenbankKunden:getNextId()
   if ::nCurrId==-1
      ::nCurrId:=::findBiggestId()
   ENDIF
   ::nCurrId++
   return ::nCurrID

method datenbankKunden:findBiggestId()
   local nBig:=-1

   USE kunden NEW
     GO TOP
    do while !eof()
       nBig:=MAX(nBig,kunden->ID)
       skip
     enddo
     USE
     return nBig

method datenbankKunden:getById(nId)
   local oKunde:=NIL


   USE kunden NEW
   SET INDEX TO kundenid
   IF dbseek(nId) .AND. !DELETED()
       oKunde := ::currRecordToKunde()
   ENDIF
   USE
   return oKunde

method datenbankKunden:getByName(cName)
   local aoRet:={}
   LOCAL oKunde
   USE kunden NEW
   GO TOP

   do while !eof()
      if ALLTRIM(kunden->NAME) == cName .AND. !DELETED()
          oKunde := ::currRecordToKunde()
          AAdd(aoRet, oKunde)
       ENDIF
       skip
      enddo
   USE
   return aoRet

METHOD datenbankKunden:getByAddresse(cAddresse)

   LOCAL aoRet := {}
   LOCAL oKunde

   USE kunden NEW
   GO TOP

   DO WHILE !EOF()

      IF AllTrim(kunden->ADDRESSE) == cAddresse .AND. !DELETED()
         oKunde := ::currRecordToKunde()
         AAdd(aoRet, oKunde)
      ENDIF

      SKIP
   ENDDO

   USE

RETURN aoRet

method datenbankKunden:createKundenIfNeeded()

   LOCAL aStruktur := {}

   IF !File("kunden.dbf")

      AAdd(aStruktur, {"ID", "N", 6, 0})
      AAdd(aStruktur, {"NAME", "C", 30, 0})
      AAdd(aStruktur, {"ADDRESSE", "C", 40, 0})

      DbCreate("kunden.dbf", aStruktur)

   ENDIF


   IF !File("kundenid.ntx")

      USE kunden NEW
     INDEX ON kunden->ID TO kundenid FOR !DELETED()
      USE

   ENDIF

RETURN NIL

method datenbankKunden:add(oKunde)
   oKunde:nId:=::getNextId()

   USE kunden NEW
   SET INDEX TO kundenid

   APPEND BLANK
   REPLACE ID WITH oKunde:nId
   REPLACE NAME WITH oKunde:cName
   REPLACE ADDRESSE WITH oKunde:cAddresse
    DBCOMMIT()
   USE


RETURN oKunde

method datenbankKunden:update(oKunde)

   LOCAL bChange := .F.

   IF oKunde == NIL
      RETURN .F.
   ENDIF

   USE kunden NEW
   SET INDEX TO kundenid

   IF DBSEEK(oKunde:nId)

      IF RLOCK()

         REPLACE kunden->NAME WITH oKunde:cName
         REPLACE kunden->ADDRESSE WITH oKunde:cAddresse
          DBCOMMIT()
         UNLOCK

         bChange := .T.

      ENDIF

   ENDIF

   USE

RETURN bChange


method datenbankKunden:delete(oKunde)
   LOCAL bDeleted := .F.
     IF oKunde == NIL
      RETURN .F.
   ENDIF
   USE kunden NEW
   SET INDEX TO kundenid

 IF DBSEEK(oKunde:nId)

   IF RLOCK()
    DELETE
DBCOMMIT()
UNLOCK
      bDeleted := .T.
   ENDIF

ENDIF

   USE

RETURN bDeleted

method datenbankKunden:getAll()
   local aoReturn:={}
   local oKunde

   USE kunden NEW
   SET index TO kundenid
   GO TOP
   do while !eof()
      if !deleted()
         oKunde:=::currRecordToKunde()
         AAdd(aoReturn, oKunde)
      endif
      skip
   enddo

   USE

   return aoReturn

