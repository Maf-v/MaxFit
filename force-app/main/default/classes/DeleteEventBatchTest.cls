@isTest
public class DeleteEventBatchTest {

    @TestSetup
    static void setupData(){
        Event_Organizer__c organizer = new Event_Organizer__c(
            Name = 'Organizer',
            Email__c = 'organizer@prueba.com',
            Phone__c = '221454454'
        );
        insert organizer;

        List<Event__c> eventList = new List<Event__c>();
        for (Integer i = 0; i<200; i++) {
            eventList.add(new Event__c(
                Name = 'Event Prueba' + i,
                Event_Organizer__c = organizer.Id,
                Start_Date_Time__c = System.now().addMonths(-4),
                End_Date_Time__c = System.now().addDays(15).addMonths(-4),
                Max_Seats__c = 20000
            ));
        }
        insert eventList; 
    }

    @isTest
    static void deleteEventTest() {
        Test.startTest();
        String nameString = 'Event Prueba%';
        System.assertEquals(200, Database.query('SELECT Id, Name, End_Date_Time__c FROM Event__c WHERE Name LIKE :nameString').size(), 'Para comprobar si efectivamente se crearon los objetos desde setupData');

        Id batchId = Database.executeBatch(new DeleteEventBatch(), 250);
        Test.stopTest();

        Datetime checkDate = System.now().addMonths(-2);
        List<Event__c> events = [SELECT Id, End_Date_Time__c FROM Event__c WHERE End_Date_Time__c < :checkDate];
        System.assertEquals(0, events.size(), 'Todos los eventos eliminados');
    }
}