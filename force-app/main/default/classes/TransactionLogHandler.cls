public with sharing class TransactionLogHandler {
    public static void exceptionHandler(System.Exception except, String processName) {
        Error_Log__c transactionLog = new Error_Log__c(
            Log_Details__c = except.getCause() + '<br>' + except.getLineNumber() + '<br>' + except.getMessage() + '<br>' + except.getStackTraceString() + '<br>' + except.getTypeName(),
            Log_Date_Time__c = System.now(),
            Process_Name__c = processName
        );

        if (Error_Log__c.SObjectType.getDescribe().isCreateable()) {
            insert transactionLog;
        }
    }

    public static void exceptionHandlerWithError(String error, String processName) {
        Error_Log__c transactionLog = new Error_Log__c(
            Log_Details__c = error,
            Log_Date_Time__c = System.now(),
            Process_Name__c = processName
        );

        if (Error_Log__c.SObjectType.getDescribe().isCreateable()) {
            insert transactionLog;
        }
    }
}
