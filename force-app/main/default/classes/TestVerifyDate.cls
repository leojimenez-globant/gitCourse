@isTest
public with sharing class TestVerifyDate {
   @isTest
    static void daysInRange30DaysUseD2(){
        Date d1 = Date.today();
        Date d2 = d1.addDays(25);

        test.startTest();
        Date dTest = VerifyDate.CheckDates(d1, d2);
        test.stopTest();

        System.assertEquals(d2, dTest, 'No se asigno d2 a los 30 dias de dif');

        }
    @isTest
    static void secondDayIsInThePast(){
        Date d1 = Date.today();
        Date d2 = d1.addDays(-1);

        test.startTest();
        Date dTest = VerifyDate.CheckDates(d1, d2);
        test.stopTest();
        
        Integer totalDays = Date.daysInMonth(d1.year(), d1.month());
        Date dTestExpected = Date.newInstance(d1.year(), d1.month(), totalDays);
        
        System.assertEquals(dTestExpected, dTest, 'No devolvio el ultimo dia siento el segundo dia menor');
    }
    @isTest
    static void daysWithMoreThan30Days(){
        Date d1 = Date.today();
        Date d2 = d1.addDays(39);

        test.startTest();
        Date dTest = VerifyDate.CheckDates(d1, d2);
        test.stopTest();
        
        Integer totalDays = Date.daysInMonth(d1.year(), d1.month());
        Date dTestExpected = Date.newInstance(d1.year(), d1.month(), totalDays);
        
        System.assertEquals(dTestExpected, dTest, 'No devolvio el ultimo dia siento el segundo mas de 30 dias en el futuro');
    }
}