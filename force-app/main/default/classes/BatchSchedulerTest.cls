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

}