public without sharing class EventAttendeeTriggerHandler {

    public static void sendConfirmationEmail(List<Event_Attendee__c> eventAttendeesList) {

        List<Id> eventAttendeesID = new List<Id>();
        for (Event_Attendee__c eventAttendee : eventAttendeesList) {
            eventAttendeesID.add(eventAttendee.Id);
        }

        List<Event_Attendee__c> eventAttendeesQuery = [SELECT Id, Attendees__r.Name, Attendees__r.Email__c, Attendees__r.Phone__c, Event__r.Name, Event__r.Start_Date_Time__c, Event__r.Location__r.Name, Event__r.Location__r.Street__c, Event__r.Location__r.City__c, Event__r.Location__r.State__c, Event__r.Location__r.Postal_Code__c, Event__r.Location__r.Country__c, Event__r.Event_Organizer__r.Name FROM Event_Attendee__c WHERE Id IN :eventAttendeesID WITH SECURITY_ENFORCED];

        // Se crea una lista de mails a enviar
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for (Event_Attendee__c eventAttendee : eventAttendeesQuery) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new List<String>{ eventAttendee.Attendees__r.Email__c });
            email.setSubject('Pass for the ' + eventAttendee.Event__r.Name);
            email.setSenderDisplayName(eventAttendee.Event__r.Event_Organizer__r.Name);

            String location = 'https://www.google.com/maps/place/'+eventAttendee.Event__r.Location__r.Street__c+' '+eventAttendee.Event__r.Location__r.City__c+' '+eventAttendee.Event__r.Location__r.State__c+' '+eventAttendee.Event__r.Location__r.Country__c+' '+eventAttendee.Event__r.Location__r.Postal_Code__c;
            String hrefForLocation = '<a href="'+location+'"'+'target="_blank">aca</a>';
            String emailBody = 'Hola ' + eventAttendee.Attendees__r.Name + ', <br/>' +
            'Gracias por inscribirte para el evento ' + eventAttendee.Event__r.Name + ' el dia ' + eventAttendee.Event__r.Start_Date_Time__c + ' que tendra lugar en ' + eventAttendee.Event__r.Location__r.Name + '. Estamos emocionados de contar con tu participacion!. <br/>' +
            'Puedes encontrar la ubicacion del evento en Google Maps ' + hrefForLocation + '.<br/><br/><br/>' + 'Saludos, <br/>' +eventAttendee.Event__r.Event_Organizer__r.Name;

            email.setHtmlBody(emailBody);
            // Se agrega el mail creado a la lista
            emailList.add(email);
        }

        try {
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(emailList, false); 
            for(Messaging.SendEmailResult email : results){
                if(!email.isSuccess()){
                    List<Messaging.SendEmailError> errors = email.getErrors();
                    TransactionLogHandler.exceptionHandlerWithError(JSON.serialize(errors), 'EventAttendeeTriggerHandler');
                }
            }  
        } catch (System.Exception except) {
            TransactionLogHandler.exceptionHandler(except, 'EventAttendeeTriggerHandler');
        } 

    }

}