@isTest
public class BatchSchedulerTest {

    @isTest
    static void batchScheduled() {
        Test.startTest();
        String sch = '0 0 10 ? * MON';
        String jobID = System.schedule('Schedule Prueba', sch, new BatchScheduler());

        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(1, ct.size(), 'Se creo correntamente el Schedule Job');
        System.assertEquals(sch, ct[0].CronExpression, 'Correct Schedule Expression');
        Test.stopTest();
    }

    @isTest
    static void batchScheduledFailure() {
        Test.startTest();
        String sch = 'incorrecto';
        String jobID = System.schedule('Schedule Prueba', sch, new BatchScheduler());
        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(0, ct.size(), 'No se creo ningun Schedule Job');
        List<Error_Log__c> errorLog = [SELECT Id, Process_Name__c, Log_Date_Time__c FROM  Error_Log__c WHERE Process_Name__c = 'BatchScheduler' AND Log_Date_Time__c = TODAY];
        System.assertEquals(1, errorLog.size(), 'Se creo el objeto de erorr');
        Test.stopTest();
    }

}