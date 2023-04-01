public with sharing class EventListController {

    @AuraEnabled(cacheable=true)
    public static List<Event__c> getEvents(){
        List<Event__c> eventList = [SELECT Id, Name, Start_Date_Time__c, Live__c, Event_Detail__c, Event_Organizer__r.Name, Location__r.Name FROM Event__c WHERE Live__c = true AND Start_Date_Time__c >= TODAY WITH SECURITY_ENFORCED];
        return eventList;
    }
}