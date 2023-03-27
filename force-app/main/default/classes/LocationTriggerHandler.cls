public with sharing class LocationTriggerHandler {

    public static void verifyLocation(List<Location__c> newLocationsList) {
        //Se agenda un Queueable Job para poder realizar callouts (no se puede usar future methods porque tenia que pasar una lista de custom objects)
        QueueableVerifyLocation verifyLocation = new QueueableVerifyLocation(newLocationsList);
        System.enqueueJob(verifyLocation);
    }

}
