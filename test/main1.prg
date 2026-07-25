class taschenrechner
   exported:
      method setZahl1(nZahl)
      method setZahl2(nZahl)
      method setOperator(cOperator)
      method berechne()
   protected:
      VAR  nZahl1
      var  nZahl2
      var  cOperator
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

method taschenrechner:berechne()
   do case
      case ::cOperator == "+"
         return ::nZahl1+::nZahl2
      case ::cOperator == "-"
         return ::nZahl1-::nZahl2
      case ::cOperator == "*"
         return ::nZahl1*::nZahl2
      case ::cOperator == "/"
         if ::nZahl2 == 0
            ?"Error: Teilen durch 0"
            return NIL
         endif
         return ::nZahl1/::nZahl2
      otherwise
         ?"Error: Operand: "+::cOperand+" nicht unterstützt"
         return NIL
      end case
   return NIL

PROCEDURE Main

   local oTasche:=taschenrechner():new()
   local cInput
   local nLocZahl1
   local nLocZahl2
   local cLocOper
   local xErgebniss

   ?"Zahl 1"
   accept to cInput
   nLocZahl1:=VAL(cInput)
    ?"Zahl 2"
   accept to cInput
   nLocZahl2:=VAL(cInput)
   ?"Operator"
   accept to cLocOper

   oTasche:setZahl1(nLocZahl1)
    oTasche:setZahl2(nLocZahl2)
   oTasche:setOperator(cLocOper)

   xErgebniss:=oTasche:berechne()
   if  xErgebniss!=NIL
      ?"Ergebniss = ",xErgebniss
   else
      ?"Berechnung fehlgeschlagen"
   endif
    wait
RETURN
