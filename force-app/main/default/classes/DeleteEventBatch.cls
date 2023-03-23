public class DeleteEventBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        //Obtiene los events cuya End Date fue hace mas de dos meses
        return Database.getQueryLocator([SELECT Id, End_Date_Time__c FROM Event__c WHERE End_Date_Time__c < LAST_N_MONTHS:2]);
    }

    public void execute(Database.BatchableContext bc, List<Event__c> eventList) {
        if(!eventList.isEmpty()) {
            //Realiza las operacions DML
            List<Database.DeleteResult> drList = Database.delete(eventList);
            //Obtiene los errores de las operaciones DML que fallaron
            for (Database.DeleteResult dr : drList) {
                if(!dr.isSuccess()) {
                    List<Database.Error> errors = dr.getErrors();
                    //Une los errores en un solo String
                    String errorsString = String.join(errors, ',');
                    //Crea un objeto ErrorLog
                    TransactionLogHandler.exceptionHandlerWithError(errorsString, 'DeleteEventBatch');
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ 'mafsalesforce@gmail.com' });
        email.setSubject('Events Deleted');
        email.setHtmlBody('El Batch DeleteEventBatch fue completado');

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }

}