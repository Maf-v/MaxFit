public without sharing class EventSpeakerTriggerHandler {
    public static void controlDuplicates(List<Event_Speaker__c> eventSpeakers) {
        // se crea una lista con los ID de los presentadores para despues usarlos como key en un map
        List<Id> speakersID = new List<Id>();
        // se crea una lista con los ID de los eventos asociados al nuevo objeto Event Speaker para despues obtener el Start Date
        List<Id> eventsID = new List<Id>();
        for (Event_Speaker__c eventSpeaker : eventSpeakers) {
            speakersID.add(eventSpeaker.Speaker__c);
            eventsID.add(eventSpeaker.Event__c);
        }

        // query los Events mediante sus ids para obtener su Start Date
        List<Event__c> relatedEvents = [SELECT Id, Start_Date_Time__c FROM Event__c WHERE Id IN :eventsID WITH SECURITY_ENFORCED];
        // Map con key en Event__c ID y como valor el Start Date
        Map<Id,Datetime> mapRelatedEvents = new Map<Id,Datetime>();
        for (Event__c event : relatedEvents) {
            mapRelatedEvents.put(event.Id, event.Start_Date_Time__c);
        }

        // Lista de los EventSpeaker existentes con el mismo presentador, para comparar con los nuevos
        List<Event_Speaker__c> existingEventSpeakers = [SELECT Id, Speaker__c, Event__r.Start_Date_Time__c, Event__r.End_Date_Time__c FROM Event_Speaker__c WHERE Speaker__c IN :speakersID WITH SECURITY_ENFORCED];

        // Comparacion de los objetos EventSpeaker nuevos y existentes 
        for (Event_Speaker__c newEventSpeaker : eventSpeakers) {
            // Fecha de inicio del evento relacionado al nuevo Objeto
            Datetime relatedEventStartDate = mapRelatedEvents.get(newEventSpeaker.Event__c);
            
            for (Event_Speaker__c existingEventSpeaker : existingEventSpeakers) {
                // Si ese mismo presentador tiene un evento en la fecha del evento relacionado dar error.
                if (newEventSpeaker.Speaker__c == existingEventSpeaker.Speaker__c && (existingEventSpeaker.Event__r.Start_Date_Time__c < relatedEventStartDate && relatedEventStartDate < existingEventSpeaker.Event__r.End_Date_Time__c)) {
                    newEventSpeaker.addError('El presentador elegido ya tiene un evento en esa fecha');
                }
            }
        }

    }
}