@isTest
public with sharing class EventAttendeeTriggerTest {

    @TestSetup
    static void setupData(){
        Event_Organizer__c eventOrganizer = new Event_Organizer__c(
            Name = 'EventOrganizer Prueba',
            Email__c = 'eventorgmail@salesforce.com',
            Phone__c = '221454545'
        );
        insert eventOrganizer;

        Event__c event = new Event__c(
            Name = 'Evento Prueba',
            Event_Organizer__c = eventOrganizer.Id,
            Start_Date_Time__c = System.now(),
            End_Date_Time__c = System.now().addDays(5),
            Max_Seats__c = 20000,
            Live__c = true
        );
        insert event;

        Attendees__c attendee = new Attendees__c(
            Name = 'Attendee Prueba',
            Email__c = 'attendeemail@salesforce.com',
            Phone__c = '221656565'
        );        
        insert attendee;

    }

    @isTest
    static void sendEmailConfirmaitionTest() {
        Event__c event = [SELECT Id, Name FROM Event__c WHERE Name = 'Evento Prueba' LIMIT 1]; 
        Attendees__c attendee = [SELECT Id, Name FROM Attendees__c WHERE Name = 'Attendee Prueba' LIMIT 1];
        Event_Attendee__c eventAttendee = new Event_Attendee__c(
            Name = 'Event Attendee Prueba',
            Event__c = event.Id,
            Attendees__c = attendee.Id
        );

        Test.startTest();
        insert eventAttendee;
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        List<Error_Log__c> transactionLogs = [SELECT Id, Process_Name__c FROM Process_Name__c WHERE Process_Name__c = 'EventAttendeeTriggerHandler'];
        System.assertEquals(1, emailInvocations, 'Mail enviado correctamente.');
    
    }
}