#include "Common.ch"
class rechnung
   exported:
      var nRechnungNr
      var nKundenId
      var nBetrag
      var dDatum
      method init(nKundenId,nBetrag,dDatum)
endclass

method rechnung:init(nKundenId,nBetrag,dDatum)
   ::nRechnungNr:=-1
   ::nKundenId:=nKundenId
   ::nBetrag:=nBetrag
   ::dDatum := IIf(dDatum == NIL, Date(), dDatum)
   return self
