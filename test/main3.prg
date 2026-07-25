#include "Xbp.ch"
#include "Appevent.ch"

PROCEDURE Main()

   LOCAL oDlg
   LOCAL oSLE
   LOCAL nEvent
   LOCAL mp1, mp2, oXbp
   LOCAL cName := "Input Name"
   SetColor("N/W")
    CLS

   oSLE := XbpSLE():new()
   oSLE:dataLink := {|x| IIf(x == NIL, cName, cName := x)}
   oSLE:create(,,{50,100},{200,30})

   oSLE:setData()

   oButton := XbpPushButton():new()
   oButton:caption := "OK"

   oButton:create(,,{150,70},{100,30})


   // Button-Ereignis
   oButton:activate := ;
      {|| oSLE:getData(),MsgBox("Hallo " + cName) }


   // Event-Schleife
   DO WHILE nEvent <> xbeP_Close

      nEvent := AppEvent(@mp1,@mp2,@oXbp)

      IF oXbp <> NIL
         oXbp:handleEvent(nEvent,mp1,mp2)
      ENDIF

   ENDDO

RETURN
