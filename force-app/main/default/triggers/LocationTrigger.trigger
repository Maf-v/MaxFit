trigger LocationTrigger on Location__c (after insert) {

    switch on Trigger.operationType {
        when AFTER_INSERT {
            LocationTriggerHandler.verifyLocation(Trigger.new);
        }
    }
}