@isTest
public with sharing class TransactionLogHandlerTest {

    @isTest
    static void exceptionHandlerTest() {
        try {
            Integer i = 10/0;
        } catch (Exception except) {
            Test.startTest();
            TransactionLogHandler.exceptionHandler(except, 'ProcessPrueba');
            Test.stopTest(); 
        }

        List<Error_Log__c> errorLogs = [SELECT Id, Process_Name__c FROM Error_Log__c WHERE Process_Name__c = 'ProcessPrueba'];
        System.assertEquals(1, errorLogs.size(), 'Objeto creado correctamente.');
    }

    @isTest
    static void exceptionHandlerWithErrorTest() {
        Test.startTest();
        TransactionLogHandler.exceptionHandlerWithError('ErrorPrueba', 'ProcessWithErrorPrueba');
        Test.stopTest(); 

        List<Error_Log__c> errorLogs = [SELECT Id, Process_Name__c FROM Error_Log__c WHERE Process_Name__c = 'ProcessWithErrorPrueba'];
        System.assertEquals(1, errorLogs.size(), 'Objeto creado correctamente.');
    }
}