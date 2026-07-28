 #include "Common.ch"

class kunde
   exported:
      method init(cName,cAddresse)
      method toArray()
      method toString()
      method equals(oKunde)
      var cName
      var nId
      var cAddresse
endclass

method kunde:init(cName,cAddresse)
   ::cName:=cName
   ::cAddresse:=cAddresse
   ::nId :=-1
   return self

method kunde:toArray()
   return {::nId,::cName,::cAddresse}

method kunde:toString()
   return LTrim(str(::nId))+", "+::cName+", "+::cAddresse

method kunde:equals(oKunde)
   IF oKunde == NIL
      RETURN .F.
   ENDIF

   RETURN ::nId == oKunde:nId .AND. ;
          ::cName == oKunde:cName .AND. ;
          ::cAddresse == oKunde:cAddresse
