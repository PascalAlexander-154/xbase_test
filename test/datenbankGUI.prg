#include "Common.ch"
#include "Xbp.ch"
#include "Appevent.ch"


class dbGUI
   exported:
      var oDbSS
      var oXbpMenuWindow
      var oXbpAddKundeWindow
      var oxbpaddRechnungWindow
      var oxbpsendMahnungWindow
      var oxbpOutputWindow
      var oxbpbezahlWindow
      method createMainWindow()
      method sendMahnung()
      method sendMahnungEvent(cDate)
      method bezahl()
      method bezahlEvent(nRechnungId,nBetrag)
      method addRechnung()
      method addKunde()
      method addRechnungEvent(nKundenID,nBetrag)
      method addKundeEvent(cName,cAddresse)
      method getAllKunde()
      method getAllRechnung()
      method outputStringList(acString)
      method generateMLEdata(acString,nSeite,nElementeProSeite,nMaxSeite)
      method eventLoop()
      method init()
 endclass


 method dbGUI:init()
   ::oDbSS:=dbSS():new():init()
   ::createMainWindow()
   ::eventLoop()
   return NIL

 method dbGUI:createMainWindow()
   local oBaddKunde, oBaddRechnung,oBgetAllRechnung,oBgetAllKunde,oBSendMahnung,oBbezahl

   SetColor( "N/W" )
   CLS
   ::oXbpMenuWindow := XbpDialog():new()
  ::oXbpMenuWindow:create(,,{00,00},{500,400})
  ::oXbpMenuWindow:title:="Datenbank"
  ::oXbpMenuWindow:show()

   oBaddKunde:=xbpPushButton():new()
   oBaddKunde:caption:="Add new Kunde"
   oBaddKunde:activate:={|| ::addKunde()}
   oBaddKunde:create(::oXbpMenuWindow,,{20,320},{150,30})

   oBaddRechnung:=xbpPushButton():new()
   oBaddRechnung:caption:="Add new Rechnung"
   oBaddRechnung:activate:={|| ::addRechnung()}
   oBaddRechnung:create(::oXbpMenuWindow,,{20,280},{150,30})

   oBgetAllKunde:=xbpPushButton():new()
   oBgetAllKunde:caption:="Get all Kunden"
   oBgetAllKunde:activate:={|| ::getAllKunde()}
   oBgetAllKunde:create(::oXbpMenuWindow,,{20,240},{150,30})

   oBgetAllRechnung:=xbpPushButton():new()
   oBgetAllRechnung:caption:="Get all Rechnung"
   oBgetAllRechnung:activate:={|| ::getAllRechnung()}
   oBgetAllRechnung:create(::oXbpMenuWindow,,{20,200},{150,30})

   oBSendMahnung:=xbpPushButton():new()
   oBSendMahnung:caption:="Sende Mahnungen"
   oBSendMahnung:activate:={|| ::sendMahnung()}
   oBSendMahnung:create(::oXbpMenuWindow,,{20,160},{150,30})

   oBbezahl:=xbpPushButton():new()
   oBbezahl:caption:="Bezahl Rechnung"
   oBbezahl:activate:={|| ::bezahl()}
   oBbezahl:create(::oXbpMenuWindow,,{20,120},{150,30})

   SetAppFocus(oBaddKunde)

   return NIL

 method dbGUI:addKunde()
   local olName,oLAddresse
   local oSLEName,oSLEAddresse,oBbestaetige
   local cName:="",cAddresse:=""

   ::oXbpAddKundeWindow:=XbpDialog():new()
   ::oXbpAddKundeWindow:create(,,{00,00},{500,400})
   ::oXbpAddKundeWindow:setTitle("Add Kunde")
   ::oXbpAddKundeWindow:show()

   oLname:=xbpStatic():new()
   oLname:caption:="Name: "
   oLname:create(::oXbpAddKundeWindow,,{20,320},{50,30})


   oSLEName:=xbpSLE():new()
   oSLEName:bufferLength:=30
   oSLEName:dataLink:={|x| IIF(x==NIL,cName,cName:=x)}
   oSLEName:create(::oXbpAddKundeWindow,,{70,320},{280,30})
   oSLEName:setData()

   oLAddresse := XbpStatic():new()
   oLAddresse:caption := "Adresse:"
   oLAddresse:create(::oXbpAddKundeWindow,,{20,280},{60,25})


   oSLEAddresse := XbpSLE():new()
   oSLEAddresse:bufferLength := 40
   oSLEAddresse:dataLink := {|x| IIf(x==NIL,cAddresse,cAddresse:=x)}
   oSLEAddresse:create(::oXbpAddKundeWindow,,{80,280},{250,25})
   oSLEAddresse:setData()

   oBBestaetige := XbpPushButton():new()
   oBBestaetige:caption := "Speichern"
oBBestaetige:activate := {|| oSLEName:getData(),oSLEAddresse:getData(),::addKundeEvent(cName,cAddresse)}
   oBBestaetige:create(::oXbpAddKundeWindow,,{180,40},{120,30})

   return NIL


method dbGUI:addKundeEvent(cName,cAddresse)

    IF !Empty(AllTrim(cName)) .AND. !Empty(AllTrim(cAddresse))
      ::oDbSS:addKunde( kunde():new():init(cName, cAddresse) )
      ::oXbpAddKundeWindow:destroy()
   else
    MsgBox("Fehler: Name oder Adresse leer.")
   endif
   return NIL

 method dbGUI:addRechnung()
   local olKundenId,oLBetrag
   local oSLEKundenId,oSLEBetrag,oBbestaetige
   local nKundenId:="",nBetrag:=""

   ::oXbpAddRechnungWindow:=XbpDialog():new()
   ::oXbpAddRechnungWindow:create(,,{00,00},{500,400})
   ::oXbpAddRechnungWindow:setTitle("Add Rechnung")
   ::oXbpAddRechnungWindow:show()

   olKundenId:=xbpStatic():new()
   olKundenId:caption:="KundenId: "
   olKundenId:create(::oXbpAddRechnungWindow,,{20,320},{50,30})


   oSLEKundenId:=xbpSLE():new()
   oSLEKundenId:bufferLength:=6
   oSLEKundenId:dataLink:={|x| IIF(x==NIL,nKundenId,nKundenId:=x)}
   oSLEKundenId:create(::oXbpAddRechnungWindow,,{70,320},{280,30})
   oSLEKundenId:setData()

   oLBetrag := XbpStatic():new()
   oLBetrag:caption := "Betrag:"
   oLBetrag:create(::oXbpAddRechnungWindow,,{20,280},{60,25})


   oSLEBetrag := XbpSLE():new()
   oSLEBetrag:bufferLength := 13
   oSLEBetrag:dataLink := {|x| IIf(x==NIL,nBetrag,nBetrag:=x)}
   oSLEBetrag:create(::oXbpAddRechnungWindow,,{80,280},{250,25})
   oSLEBetrag:setData()

   oBBestaetige := XbpPushButton():new()
   oBBestaetige:caption := "Speichern"
oBBestaetige:activate := {|| oSLEBetrag:getData(),oSLEKundenId:getData(),::addRechnungEvent(nKundenId,nBetrag)}
   oBBestaetige:create(::oXbpAddRechnungWindow,,{180,40},{120,30})

   return NIL


method dbGUI:addRechnungEvent(nKundenId,nBetrag)
   nKundenId := Val(AllTrim(nKundenId))
   nBetrag   := Val(AllTrim(nBetrag))

   if nKundenId > -1 .AND. nBetrag > 0
      ::oDbSS:addRechnung( rechnung():new():init(nKundenId, nBetrag,date()) )
      ::oXbpAddRechnungWindow:destroy()
   else
    MsgBox("Fehler: KundenId oder Betrag invalid.")
   endif
   return NIL


 method dbGUI:bezahl()
   local olRechnungNr,oLBetrag
   local oSLERechnungNr,oSLEBetrag,oBbestaetige
   local nRechnungNr:="",nBetrag:=""

   ::oxbpbezahlWindow:=XbpDialog():new()
   ::oxbpbezahlWindow:create(,,{00,00},{500,400})
   ::oxbpbezahlWindow:setTitle("Bezahl Rechnung")
   ::oxbpbezahlWindow:show()

   olRechnungNr:=xbpStatic():new()
   olRechnungNr:caption:="RechnungNr: "
   olRechnungNr:create(::oxbpbezahlWindow,,{20,320},{50,30})


   oSLERechnungNr:=xbpSLE():new()
   oSLERechnungNr:bufferLength:=6
   oSLERechnungNr:dataLink:={|x| IIF(x==NIL,nRechnungNr,nRechnungNr:=x)}
   oSLERechnungNr:create(::oxbpbezahlWindow,,{70,320},{280,30})
   oSLERechnungNr:setData()

   oLBetrag := XbpStatic():new()
   oLBetrag:caption := "Betrag:"
   oLBetrag:create(::oxbpbezahlWindow,,{20,280},{60,25})


   oSLEBetrag := XbpSLE():new()
   oSLEBetrag:bufferLength := 13
   oSLEBetrag:dataLink := {|x| IIf(x==NIL,nBetrag,nBetrag:=x)}
   oSLEBetrag:create(::oxbpbezahlWindow,,{80,280},{250,25})
   oSLEBetrag:setData()

   oBBestaetige := XbpPushButton():new()
   oBBestaetige:caption := "Speichern"
oBBestaetige:activate := {|| oSLEBetrag:getData(),oSLERechnungNr:getData(),::bezahlEvent(nRechnungNr,nBetrag)}
   oBBestaetige:create(::oxbpbezahlWindow,,{180,40},{120,30})

   return NIL


method dbGUI:bezahlEvent(nRechnungNr,nBetrag)
   local nRet
   if nRechnungNr == ""
      MSGbox("Ungültige Rechnungsnr")
      return NIL
   endif
   nRechnungNr := Val(AllTrim(nRechnungNr))
   nBetrag   := Val(AllTrim(nBetrag))

   if nBetrag<=0
      MSGbox("Ungültiger Betrag")
      return NIL
   endif

   if nRechnungNr<0
      MSGbox("Ungültige Rechnungsnr")
      return NIL
   endif

   nRet:=::oDbSS:bezahlRechnung(nRechnungNr,nBetrag)

   if nRet == NIL
      MSGbox("Rechnung nicht gefunden")
      return NIL
   endif

   if nRet > 0
      MSGbox("Rechnung nicht vollstaendig bezhalt. Uebriger Betrag: "+ allTrim(str(nRet)))
      ::oxbpbezahlwindow:destroy()
    endif

    if nRet==0
      Msgbox("Rechnung vollstaendig bezahlt")
      ::oxbpbezahlwindow:destroy()
    endif

    if nRet <0
      Msgbox("Rechnunng vollstaendig gezahlt. Zurueckgegebenes Geld: "+(allTrim(str(-1*nRet))))
       ::oxbpbezahlwindow:destroy()
     endif
   return NIL


method dbGUI:outputStringList(acString)
   local nSeite:=1,nElementeProSeite:=10
   local oMLE, oBPrev,oBNext,oBExit
   local nMaxSeite := Max(1, Int((Len(acString)-2 + nElementeProSeite - 1) / nElementeProSeite))
   local cText:= ::generateMLEdata(acString,nSeite,nElementeProSeite,nMaxSeite)

   ::oxbpOutputWindow:=XbpDialog():new()
   ::oxbpOutputWindow:create(,,{00,00},{500,400})
   ::oxbpOutputWindow:setTitle(acString[1])
   ::oxbpOutputWindow:show()


   oMLE := XbpMLE():new()
   oMLE:editable := .F.
   oMLE:wordWrap := .F.
   oMLE:dataLink := {|x| IIf(x==NIL, cText, cText:=x)}
   oMLE:create(::oXbpOutputWindow,,{20,50},{460,300})
   oMLE:setData()

   oBprev:=XbpPushButton():new()
   oBprev:caption:="Vorherig"
   oBprev:activate:= {|| nSeite:=Max(nSeite-1,1),cText:=::generateMLEdata(acString,nSeite,nElementeProSeite,nMaxSeite),oMLE:setData()}
   oBPrev:create(::oXbpOutputWindow,,{20,20},{80,30})

   oBnext:=XbpPushButton():new()
   oBnext:caption:="Naechste"
   oBnext:activate:= {|| nSeite:=Min(nSeite+1,nMaxSeite),cText:=::generateMLEdata(acString,nSeite,nElementeProSeite,nMaxSeite),oMLE:setData()}
   oBNext:create(::oXbpOutputWindow,,{120,20},{80,30})

   oBexit:= XbpPushButton():new()
   oBexit:caption:="Exit"
   oBexit:activate:={|| ::oxbpOutputWindow:destroy()}
   oBexit:create(::oXbpOutputWindow,,{220,20},{80,30})


   return NIL






method dbGui:generateMLEdata(acString,nSeite,nElementeProSeite,nMaxSeite)
   local cKopfzeile
   local cText:=""
   local cSep:="-------------------------------------"
   local cNl:=Chr(13)+Chr(10)
   local i := 3 + (nSeite-1)*nElementeProSeite
   local iEnd := Min(Len(acString), i + nElementeProSeite - 1)

   cKopfzeile:=acString[2]

   cText+=cKopfzeile+cNl
   cText+=cSep+cNl
   FOR i:=i TO iend
     cText+= acString[i]+cNl
   Next
   cText+=cSep +cNl
   cText += "Seite " + LTrim(Str(nSeite)) +" Von:"+ LTrim(Str(nMaxSeite)) +cNl
   cText += cSep + cNl

   return cText

method dbGUI:getAllKunde()
   local acString:={}
   local cBuild:=""
   local cTab:=chr(9)
   local i := 1
   local aoKunde:=::odbSS:getAllKunden()

   aadd(acString,"Kundenlist")
   aadd(acString,"KundeId"+cTab+"Name"+cTab+"Adresse")
   for i:=1 to len(aoKunde)
      cBuild:=""
      cBuild+=AllTrim(Str(aoKunde[i]:nId))
      cBuild+=cTab
      cBuild+=AllTrim(aoKunde[i]:cName)
      cBuild+=cTab
      cBuild+=AllTrim(aoKunde[i]:cAddresse)
      aadd(acString,cBuild)
   next

  return ::outputStringList(acString)

method dbGUI:getAllRechnung()
   local acString:={}
   local cBuild:=""
   local cTab:=chr(9)
   local i := 1
   local aoRechnung:=::odbSS:getAllRechnung()

   aadd(acString,"Rechnungenlist")
   aadd(acString,"RechnungNr"+cTab+"KundenID"+cTab+"Betrag"+cTab+"Datum")
   for i:=1 to len(aoRechnung)
      cBuild:=""
      cBuild+=AllTrim(Str(aoRechnung[i]:nRechnungNr))
      cBuild+=cTab
      cBuild+=AllTrim(Str(aoRechnung[i]:nKundenId))
      cBuild+=cTab
      cBuild+=AllTrim(Str(aoRechnung[i]:nBetrag))
      cBuild+=cTab
      cBuild+=AllTrim(DtoC(aoRechnung[i]:dDatum))
      aadd(acString,cBuild)
   next

  return ::outputStringList(acString)

  method dbGUI:sendMahnung()
  local oLdate,oSLEdate,oBbestaetige
  local cDate :=""

  ::oxbpsendMahnungWindow:=XbpDialog():new()
   ::oxbpsendMahnungWindow:create(,,{00,00},{500,400})
   ::oxbpsendMahnungWindow:setTitle("Sende Mahnungen")
   ::oxbpsendMahnungWindow:show()

  oLdate := XbpStatic():new()
   oLdate:caption := "Aelter denn:"
   oLdate:create(::oxbpsendMahnungWindow,,{20,280},{60,25})


   oSLEdate := XbpSLE():new()
   oSLEdate:bufferLength := 13
   oSLEdate:dataLink := {|x| IIf(x==NIL,cDate,cDate:=x)}
   oSLEdate:validate := {|x| !Empty(CToD(x))}
   oSLEdate:create(::oxbpsendMahnungWindow,,{80,280},{250,25})
   oSLEdate:setData()

   oBBestaetige := XbpPushButton():new()
   oBBestaetige:caption := "Bestaetige"
oBBestaetige:activate := {|| oSLEdate:getData(),::sendMahnungEvent(cDate)}
   oBBestaetige:create(::oxbpsendMahnungWindow,,{180,40},{120,30})

   return NIL


 method  dbGUI:SendMahnungEvent(cDate)
 local dDate:=CToD(cDate)
   if empty(dDate)
      MsgBox("Datumsformatfehler")
   else
      ::oxbpsendMahnungWindow:destroy()
      ::outputStringList(::odbSS:sendMahnung(dDate))
   endif
   return NIL




method dbGUI:eventLoop()
   LOCAL nEvent:=0
   LOCAL mp1, mp2, oXbp
   DO WHILE nEvent <> xbeP_Close

      nEvent := AppEvent(@mp1,@mp2,@oXbp)

      IF oXbp <> NIL
         oXbp:handleEvent(nEvent,mp1,mp2)
      ENDIF

   ENDDO
return NIL


