trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {

    switch on Trigger.operationType {
        when AFTER_INSERT {
            EventAttendeeTriggerHandler.sendConfirmationEmail(Trigger.new);
        }
    }

}