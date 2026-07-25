
#include "Appevent.ch"
#include "Xbp.ch"


PROCEDURE Main
   LOCAL nEvent, mp1, mp2, oXbp

   SetColor( "N/W" )
   CLS

   oXbp          := XbpPushButton():new()
   oXbp:caption  := "Ich sage Hallo Welt"
   oXbp:activate := {|| MsgBox( "Hallo Welt" ) }
   oXbp:create( , , {140,200}, {360,30} )


   SetAppFocus( oXbp )

   nEvent := 0
   DO WHILE nEvent <> xbeP_Close
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:HandleEvent( nEvent, mp1, mp2 )
   ENDDO
RETURN



