//test generiert mithilfe von generativer ki
class dbTest
   exported:
      method testKunde()
      method testRechnung()
      method testSchnittstelle()
   protected:
      var oDbK
      var oDbR
      var oDbSS
      method reset()
      method createKundenTest()
      method createRechnungenTest()
      method testGetById()
      method testGetByName()
      method testGetByAddresse()
      method testGetAllKunde()
      method testUpdateKunde()
      method testDeleteKunde()
      method testGetByNr()
   method testGetAllRechnung()
   method testGetAllByKunde()
   method testGetSum()
   method testGetSumByKunde()
  method testGetOlderThan()
   method testUpdateRechnung()
   method testDeleteRechnung()
      method testBezahlRechnungTeil()
   method testBezahlRechnungKomplett()
   method testBezahlRechnungUeberzahlung()
   method testSendMahnungen()
   method testMahnungInhalt()
  method testMahnungOhneKunde()



  endclass

  method dbTest:reset()

   CLOSE DATABASES

   IF File("kunden.dbf")
      FErase("kunden.dbf")
   ENDIF

   IF File("kundenid.ntx")
      FErase("kundenid.ntx")
   ENDIF

   IF File("rechnung.dbf")
      FErase("rechnung.dbf")
   ENDIF

   IF File("rechnungnr.ntx")
      FErase("rechnungnr.ntx")
   ENDIF

RETURN


method dbTest:createKundenTest()

   LOCAL i
   LOCAL oKunde

   ::oDbK := datenbankKunden():new():init()

   FOR i := 1 TO 20

      oKunde := kunde():new()
      oKunde:init( ;
         "Kunde " + AllTrim(Str(i)), ;
         "Adresse " + AllTrim(Str(i)) )

      ::oDbK:add(oKunde)

   NEXT

RETURN NIL


method dbTest:createRechnungenTest()

   LOCAL i
   LOCAL oRechnung

   ::oDbR := datenbankRechnung():new():init()

   // Je eine Rechnung pro Kunde
   FOR i := 0 TO 19

      oRechnung := rechnung():new()
      oRechnung:init( i, 100 * (i + 1), Date() )

      ::oDbR:add(oRechnung)

   NEXT

   // Fünf zusätzliche Rechnungen für Kunde 1
   FOR i := 1 TO 5

      oRechnung := rechnung():new()
      oRechnung:init( 1, 50 * i, Date() - i )

      ::oDbR:add(oRechnung)

   NEXT

RETURN NIL

method dbTest:testKunde()

   ::reset()
   ::createKundenTest()

   ? "getById      :", ::testGetById()
   ? "getByName    :", ::testGetByName()
   ? "getAddresse  :", ::testGetByAddresse()
   ? "getAll       :", ::testGetAllKunde()
   ? "update       :", ::testUpdateKunde()
   ? "delete       :", ::testDeleteKunde()

return NIL

METHOD dbTest:testGetById()

   LOCAL oKunde

   oKunde := ::oDbK:getById(5)

RETURN oKunde != NIL .AND. ;
       oKunde:nId == 5 .AND. ;
       oKunde:cName == "Kunde 6"

METHOD dbTest:testGetByName()

   LOCAL aKunden

   aKunden := ::oDbK:getByName("Kunde 10")

RETURN Len(aKunden) == 1 .AND. ;
       aKunden[1]:nId == 9

METHOD dbTest:testGetByAddresse()

   LOCAL aKunden

   aKunden := ::oDbK:getByAddresse("Adresse 3")

RETURN Len(aKunden) == 1 .AND. ;
       aKunden[1]:nId == 2

METHOD dbTest:testGetAllKunde()

   LOCAL aKunden

   aKunden := ::oDbK:getAll()

RETURN Len(aKunden) == 20

METHOD dbTest:testUpdateKunde()

   LOCAL oKunde

   oKunde := ::oDbK:getById(7)

   oKunde:cName := "Neuer Name"

   ::oDbK:update(oKunde)

   oKunde := ::oDbK:getById(7)

RETURN oKunde:cName == "Neuer Name"

METHOD dbTest:testDeleteKunde()

   LOCAL oKunde

   oKunde := ::oDbK:getById(12)

   ::oDbK:delete(oKunde)

RETURN ::oDbK:getById(12) == NIL

METHOD dbTest:testRechnung()

   ::reset()
   ::createKundenTest()
   ::createRechnungenTest()

   ? "getByNr()        :", ::testGetByNr()
   ? "getAll()         :", ::testGetAllRechnung()
   ? "getAllByKunde()  :", ::testGetAllByKunde()
   ? "getSum()         :", ::testGetSum()
   ? "getSumByKunde()  :", ::testGetSumByKunde()
   ? "getOlderThan()   :", ::testGetOlderThan()
   ? "update()         :", ::testUpdateRechnung()
   ? "delete()         :", ::testDeleteRechnung()

RETURN

METHOD dbTest:testGetByNr()

   LOCAL oRechnung

   oRechnung := ::oDbR:getByNr(5)

RETURN oRechnung != NIL .AND. ;
       oRechnung:nRechnungNr == 5 .AND. ;
       oRechnung:nKundenId == 5 .AND. ;
       oRechnung:nBetrag == 600


METHOD dbTest:testGetAllRechnung()

   LOCAL aRechnung

   aRechnung := ::oDbR:getAll()

RETURN Len(aRechnung) == 25


METHOD dbTest:testGetAllByKunde()

   LOCAL oKunde
   LOCAL aRechnung

   oKunde := ::oDbK:getById(1)

   aRechnung := ::oDbR:getAllByKunde(oKunde)

RETURN Len(aRechnung) == 6


METHOD dbTest:testGetSum()

   LOCAL aRechnung

   aRechnung := ::oDbR:getAll()

RETURN ::oDbR:getSum(aRechnung) == 21750


METHOD dbTest:testGetSumByKunde()

   LOCAL oKunde

   oKunde := ::oDbK:getById(1)

RETURN ::oDbR:getSumByKunde(oKunde) == 950


METHOD dbTest:testGetOlderThan()

   LOCAL aRechnung

   aRechnung := ::oDbR:getOlderThan(Date()-2)

RETURN Len(aRechnung) == 3

METHOD dbTest:testUpdateRechnung()

   LOCAL oRechnung

   oRechnung := ::oDbR:getByNr(4)

   oRechnung:nBetrag := 1234.56

   ::oDbR:update(oRechnung)

   oRechnung := ::oDbR:getByNr(4)

RETURN oRechnung:nBetrag == 1234.56

METHOD dbTest:testDeleteRechnung()

   LOCAL oRechnung

   oRechnung := ::oDbR:getByNr(10)

   ::oDbR:delete(oRechnung)

RETURN ::oDbR:getByNr(10) == NIL

METHOD dbTest:testSchnittstelle()

   ::reset()
   ::createKundenTest()
   ::createRechnungenTest()
   ::oDbSS := dbSS():new():init()

   ? "bezahl Teil()          :", ::testBezahlRechnungTeil()
   ? "bezahl Komplett()      :", ::testBezahlRechnungKomplett()
   ? "bezahl Überzahlung()   :", ::testBezahlRechnungUeberzahlung()
   ? "sendMahnungen()        :", ::testSendMahnungen()
   ? "Mahnung Inhalt()       :", ::testMahnungInhalt()
   ? "Mahnung ohne Kunde()   :", ::testMahnungOhneKunde()

RETURN NIL

method dbTest:testBezahlRechnungTeil()
   local oRechnung
   local bExpec
    bExpec:= ::odbSS:bezahlRechnung(0,50) == 50
    oRechnung:=::odBSS:getByRechnungNr(0)

   return    bExpec .AND. oRechnung:nBetrag==50

method dbTest:testBezahlRechnungKomplett()
   local oRechnung
   local bExpec
    bExpec:= ::odbSS:bezahlRechnung(1,200) == 0
    oRechnung:=::odBSS:getByRechnungNr(1)

   return  bExpec .AND. oRechnung == NIL


   method dbTest:testBezahlRechnungUeberzahlung()
   local oRechnung
   local bExpec
    bExpec:= ::odbSS:bezahlRechnung(2,400) == -100
    oRechnung:=::odBSS:getByRechnungNr(2)

   return  bExpec .AND. oRechnung == NIL

   method dbTest:testSendMahnungen()
      local aMahnung:=::odbSS:sendMahnung(date())

      return  len(aMahnung)==5

   method dbTest:testMahnungInhalt()
             local aMahnung:=::odbSS:sendMahnung(date())

      return  aMahnung[1]

   method dbTest:testMahnungOhneKunde()
   local aMahnung
      ::odbSS:addRechnung(Rechnung():new():init(50,100,date()-100)  )
      aMahnung:=::odbSS:sendMahnung(date()-99)
   return aMahnung[1]


