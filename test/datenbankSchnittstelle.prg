//dbSS-> datenbankSchnittstelle
class dbSs
   exported:
      method init()
      method addRechnung(oRechnung)
      method addKunde(oKunde)
      method bezahlRechnung(nRechnungNr,nBetrag)
      method sendMahnung(dDatum)
      method getByRechnungNr(nRechnungNr)
      method getById(nId)
      method getAllKunden()
      method getAllRechnung()
   protected:
      var oDbKunde
      var oDbRechnung
      method generateMahnung(oRechnung)
   endclass

   method dbSS:init()
      ::oDbKunde:=datenbankKunden():new():init()
      ::oDbRechnung:=datenbankRechnung():new():init()
      return self

   method dbSS:getAllKunden()
      return ::oDbKunde:getAll()

   method dbSS:getAllRechnung()
      return ::oDbRechnung:getALl()

   method dbSS:getByRechnungNr(nRechnungNr)
      return ::oDbRechnung:getByNr(nRechnungNr)

   method dbSS:getById(nId)
      return ::oDbKunde:getById(nId)

   method dbSS:addRechnung(oRechnung)
     return ::oDbRechnung:add(oRechnung)

   method dbSS:addKunde(oKunde)
      return ::oDbKunde:add(oKunde)

   /*
   Generiere eine Liste von Strings im Format:
      An: NAME,ADDRESSE Bitte zahlen sie die Rechnung: RECHNUNGSNR in Höhe von BETRAG
   */
   method dbSS:sendMahnung(dDatum)
      local acMahnungen :={}
      local aoOverdue   := ::oDbRechnung:getOlderThan(dDatum)
      local i

      for i:=1 TO len(aoOverdue)
         AAdd(acMahnungen,::generateMahnung(aoOverdue[i]))
      next

      return acMahnungen

   method dbSS:generateMahnung(oRechnung)
      local cReturn:=""
      local cStr1:="An: ", cStr2:=" Bitte zahlen sie die Rechnung: ",cStr3:= " in Höhe von "
      local cName,cAddresse,cRechnungNr,cBetrag
      local oKunde

      if oRechnung== NIL
          return cReturn
      endif

      cRechnungNr:=Alltrim(str(oRechnung:nRechnungNr))
      cBetrag:=Alltrim(str(oRechnung:nBetrag))

      oKunde:=::oDbKunde:getById(oRechnung:nKundenId)

      if oKunde == NIL
         return "Kunde für RechnungNr: "+cRechnungNr+" existiert nicht mehr"
      endif

      cName:=Alltrim(oKunde:cName)
      cAddresse:=Alltrim(oKunde:cAddresse)

      return cStr1+cName+", "+cAddresse+cStr2+cRechnungNr+cStr3+cBetrag+"."

method dbSS:bezahlRechnung(nRechnungNr,nBetrag)
   local oRechnung:=::odBRechnung:getByNr(nRechnungNr)
   local nDelta

   if oRechnung ==NIL
      return nBetrag
   endif

   nDelta:=oRechnung:nBetrag-nBetrag

   if nDelta <= 0
      ::odBRechnung:delete(oRechnung)
   else
      oRechnung:nBetrag:=nDelta
      ::odBRechnung:update(oRechnung)
   endif

   return nDelta




