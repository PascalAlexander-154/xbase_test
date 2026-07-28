class datenbankRechnung
   exported:
      method getNextNr()
      method getByNr(nNr)
      method init()
      method add(oRechnung)
      method update(oRechnung)
      method delete(oRechnung)

      method getAllbyKunde(oKunde)
      method getSumByKunde(oKunde)
      method getOlderThan(dDate)
      method getSum(aoRechnung)
      method getAll()
   protected:
      method findBiggestNr()
      method createRechnungIfNeeded()
      method currRecordToRechnung()
      var nCurrNr
endclass

method datenbankRechnung:init()
   ::createRechnungIfNeeded()
   ::nCurrNr := -1
RETURN self

method datenbankRechnung:currRecordToRechnung()
       local oRechnung := rechnung():new()
       oRechnung:init(rechnung->KUNDENID,rechnung->BETRAG,rechnung->DATUM)
       oRechnung:nRechnungNr:=rechnung->RECHNUNGNR
       return oRechnung


method datenbankRechnung:createRechnungIfNeeded()
   local astruct:={}

   if !file("rechnung.dbf")
      AAdd(astruct,{"RECHNUNGNR","N",6,0})
      AAdd(astruct,{"KUNDENID","N",6,0})
      AAdd(astruct,{"BETRAG","N",10,2})
      AAdd(astruct,{"DATUM","D",8,0})

      Dbcreate("rechnung.dbf",astruct)
   ENDIF

   if !file("rechnungnr.ntx")
      USE rechnung NEW
     INDEX ON rechnung->RECHNUNGNR TO rechnungnr FOR !DELETED()
      USE
   endif
return NIL

method datenbankRechnung:findBiggestNr()
    local nBig:=-1

   USE rechnung NEW
     GO TOP
    do while !eof()
       nBig:=MAX(nBig,rechnung->RECHNUNGNR)
       skip
     enddo
     USE
     return nBig

method datenbankRechnung:getNextNr()
 if ::nCurrNr==-1
      ::nCurrNr:=::findBiggestNr()
   ENDIF
   ::nCurrNr++
   return ::nCurrNr


method datenbankRechnung:add(oRechnung)
   oRechnung:nRechnungNr:=::getNextNr()

   USE rechnung NEW
   SET INDEX TO rechnungNr

   APPEND BLANK
   REPLACE RECHNUNGNR WITH oRechnung:nRechnungNr
   REPLACE KUNDENID WITH oRechnung:nKundenId
   REPLACE BETRAG WITH oRechnung:nBetrag
   REPLACE DATUM WITH oRechnung:dDatum
    DBCOMMIT()
   USE


RETURN oRechnung

method datenbankRechnung:update(oRechnung)

   LOCAL bChange := .F.

   IF oRechnung == NIL
      RETURN .F.
   ENDIF

   USE rechnung NEW
   SET INDEX TO rechnungnr

   IF DBSEEK(oRechnung:nRechnungNr)

      IF RLOCK()

         REPLACE rechnung->KUNDENID WITH oRechnung:nKundenId
         REPLACE rechnung->BETRAG WITH oRechnung:nBetrag
         REPLACE rechnung->DATUM WITH oRechnung:dDatum
          DBCOMMIT()
         UNLOCK

         bChange := .T.

      ENDIF

   ENDIF

   USE

RETURN bChange

method datenbankRechnung:delete(oRechnung)
   LOCAL bDeleted := .F.
     IF oRechnung == NIL
      RETURN .F.
   ENDIF
   USE rechnung NEW
   SET INDEX TO rechnungNr

 IF DBSEEK(oRechnung:nRechnungNr)

   IF RLOCK()
    DELETE
DBCOMMIT()
UNLOCK
      bDeleted := .T.
   ENDIF

ENDIF

   USE

RETURN bDeleted

method datenbankRechnung:getByNr(nNr)
     local oRechnung:=NIL

   USE rechnung NEW
   SET INDEX TO rechnungNr
   IF dbseek(nNr) .AND. !DELETED()
       oRechnung := ::currRecordToRechnung()
   ENDIF
   USE
   return oRechnung

   method datenbankRechnung:getAllByKunde(oKunde)

      local nKundenId:=oKunde:nId
      local oTmpRechnung
      local aoRet:={}

      USE rechnung NEW
      SET INDEX TO rechnungnr
      GO TOP

      do while !EOF()
         if  nKundenId==rechnung->KUNDENID .AND. !deleted()
            oTmpRechnung:=::currRecordToRechnung()
            AAdd(aoRet,oTmpRechnung)
         ENDIF
         SKIP
      ENDDO
      USE
      return aoRet

method datenbankRechnung:getSum(aoRechnung)
   LOCAL nSumme := 0
   LOCAL i

   FOR i := 1 TO Len(aoRechnung)
      nSumme += aoRechnung[i]:nBetrag
   NEXT

RETURN nSumme

method datenbankRechnung:getSumByKunde(oKunde)
   return ::getSum(::getAllByKunde(oKunde))

method datenbankRechnung:getOlderThan(dDate)

      local oTmpRechnung
      local aoRet:={}

      USE rechnung NEW
      GO TOP

      do while !EOF()
         if dDate > rechnung->DATUM .AND. !deleted()
            oTmpRechnung:=::currRecordToRechnung()
            AAdd(aoRet,oTmpRechnung)
         ENDIF
         SKIP
      ENDDO
      USE
      return aoRet

method datenbankRechnung:getAll()
   local aoReturn:={}
   local oRechnung

   USE rechnung NEW
   SET index TO rechnungnr
   GO TOP
   do while !eof()
      if !deleted()
         oRechnung:=::currRecordToRechnung()
         AAdd(aoReturn,oRechnung)
      endif
      skip
   enddo

   USE

   return aoReturn
