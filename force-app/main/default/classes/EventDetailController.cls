public with sharing class EventDetailController {

    @AuraEnabled(cacheable=true)
    public static List<Event_Speaker__c> getSpeakers(String eventID) {
        List<Event_Speaker__c> eventSpeakerList = [SELECT Id, Name, Event__c, Speaker__r.Email__c, Speaker__r.Phone__c, Speaker__r.Company__c FROM Event_Speaker__c WHERE Event__c = :eventID WITH SECURITY_ENFORCED];
        return eventSpeakerList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> getAttendees(String eventID) {
        List<Event_Attendee__c> eventAttendeesList = [SELECT Id, Name, Event__c, Event__r.Location__r.Name, Attendees__r.Email__c, Attendees__r.Phone__c, Attendees__r.Company_Name__c FROM Event_Attendee__c WHERE Event__c = :eventID WITH SECURITY_ENFORCED];
        return eventAttendeesList;
    }
}