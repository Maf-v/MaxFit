public with sharing class AttendeeEventsController {

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> getEventAttendees(String attendeeID) {
        List<Event_Attendee__c> eventAttendeeList = [SELECT Id, Name, Attendees__r.Name, Attendees__r.Id, Event__c, Event__r.Id, Event__r.Name, Event__r.Event_Organizer__r.Name, Event__r.Start_Date_Time__c, Event__r.Location__r.Name FROM Event_Attendee__c WHERE Attendees__r.Id = :attendeeID WITH SECURITY_ENFORCED];
        return eventAttendeeList;
    }
}