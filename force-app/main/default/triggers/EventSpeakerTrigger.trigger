trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            EventSpeakerTriggerHandler.controlDuplicates(Trigger.new);
        }
        when BEFORE_UPDATE {
            EventSpeakerTriggerHandler.controlDuplicates(Trigger.new);
        }
    }
}