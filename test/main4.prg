class taschenrechner
   exported:
      method setZahl1(nZahl)
      method setZahl2(nZahl)
      method setOperator(cOperator)
      method berechne()
      method getError()
      method getErrorDesc()
   protected:
      VAR  nZahl1
      var  nZahl2
      var  cOperator
      var  nErrCode
endclass

method taschenrechner:setZahl1(nZahl)
   ::nZahl1:=nZahl
   return self

method taschenrechner:setZahl2(nZahl)
   ::nZahl2:=nZahl
   return self

method taschenrechner:setOperator(cOperator)
   ::cOperator:=cOperator
   return self

method taschenrechner:getError()
   return ::nErrCode

method taschenrechner:berechne()
   ::nErrCode:=0
   do case
      case ::cOperator == "+"
         return ::nZahl1+::nZahl2
      case ::cOperator == "-"
         return ::nZahl1-::nZahl2
      case ::cOperator == "*"
         return ::nZahl1*::nZahl2
      case ::cOperator == "/"
         if ::nZahl2 == 0
            ::nErrCode := 1
            return NIL
         endif
         return ::nZahl1/::nZahl2
      otherwise
         ::nErrCode := 2
         return NIL
      end case
   return NIL

method taschenrechner:getErrorDesc()
         do case
         case ::nErrCode==1
            return "Teilen durch 0"
         case ::nErrCode==2
            return "Unbekannter Operator"
         otherwise
            return "Unbekannter Fehler"
          end case
 return NIL
#include "Common.ch"
#include "xbp.ch"
#include "Appevent.ch"

class taschenrechnerGUI
   Protected:
     var oTasche
      var nLocalZahl1,nLocalZahl2,cLocalOperator
     Exported:
        method init()
        method setZahl1(n),setZahl2(n),setOperator(c)
        method getZahl1(),getZahl2(),getOperator()
        method doBerechne()
   endclass

   method taschenrechnerGUI:getZahl1()
      return ::nLocalZahl1

       method taschenrechnerGUI:getZahl2()
    return ::nLocalZahl2

       method taschenrechnerGUI:getOperator()
      return ::cLocalOperator

      method taschenrechnerGUI:setZahl1(n)
         ::nLocalZahl1:=val(n)
         return ::nLocalZahl1
      method taschenrechnerGUI:setZahl2(n)
         ::nLocalZahl2:=val(n)
         return ::nLocalZahl2
      method taschenrechnerGUI:setOperator(c)
         ::cLocalOperator:=c
         return ::cLocalOperator


method taschenrechnerGUI:doBerechne()
   local x
   ::oTasche:setZahl1(::nLocalZahl1)
   ::oTasche:setZahl2(::nLocalZahl2)
   ::oTasche:setOperator(::cLocalOperator)

   x := ::oTasche:berechne()

   if x!= NIL
     MsgBox("Ergebnis: " + LTrim(Str(x)))
   else
      MsgBox(::oTasche:getErrorDesc())
   endif

   return NIL

method taschenrechnerGUI:init()
   local nEvent
   LOCAL oSelf := self
   local mp1, mp2, oXbp
   local oInputZahl1
   local oInputZahl2
   local oInputOperator
   local oLabelZahl1, oLabelZahl2, oLabelOperator
   local oBerechneButton
   nEvent := 0
   ::nLocalZahl1 := 0
::nLocalZahl2 := 0
::cLocalOperator := ""
   ::oTasche:=taschenrechner():new()
   SetColor("N/W")
   CLS

   oLabelZahl1:=XbpStatic():new()
   oLabelZahl1:caption= "Zahl 1:"
   oLabelZahl1:create(,,{50,300},{50,30})

   oInputZahl1:=XbpSLE():new()
   oInputZahl1:bufferLength:=20
   oInputZahl1:dataLink:={|x| IIf( x==NIL, oSelf:getZahl1(), oSelf:setZahl1(x))}
   oInputZahl1:create(,,{150,305},{200,30})

   oLabelZahl2:=XbpStatic():new()
   oLabelZahl2:caption= "Zahl 2:"
   oLabelZahl2:create(,,{50,250},{50,30})

   oInputZahl2:=XbpSLE():new()
   oInputZahl2:bufferLength:=20
   oInputZahl2:dataLink:={|x| IIf( x==NIL, oSelf:getZahl2(), oSelf:setZahl2(x))}
   oInputZahl2:create(,,{150,255},{200,30})

   oLabelOperator:=XbpStatic():new()
   oLabelOperator:caption= "Operator:"
   oLabelOperator:create(,,{50,200},{100,30})

   oInputOperator:=XbpSLE():new()
   oInputOperator:bufferLength:=1
   oInputOperator:dataLink:={|x| IIf( x==NIL, oSelf:getOperator(), oSelf:setOperator(x))}
   oInputOperator:create(,,{150,205},{200,30})

   oBerechneButton:=XbpPushButton():new()
   oBerechneButton:caption:="Berechne"
   oBerechneButton:create(,,{50,150},{200,30})

   oBerechneButton:activate := ;
   { ||oInputZahl1:getData(),oInputZahl2:getData(),oInputOperator:getData(),oSelf:doBerechne()}

   // Event-Schleife
   DO WHILE nEvent <> xbeP_Close

      nEvent := AppEvent(@mp1,@mp2,@oXbp)

      IF oXbp <> NIL
         oXbp:handleEvent(nEvent,mp1,mp2)
      ENDIF

   ENDDO
   return self
PROCEDURE Main
         local oGUI:=taschenrechnerGUI():new()
         oGUI:init()


RETURN
