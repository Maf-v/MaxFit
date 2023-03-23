public class BatchScheduler implements Schedulable{

    public void execute(SchedulableContext sc) {
        try {
            DeleteEventBatch deleteEvent = new DeleteEventBatch();
            Id batchId = Database.executeBatch(deleteEvent);
        } catch (Exception except) {
            TransactionLogHandler.exceptionHandler(except, 'BatchScheduler');
        }
    }

}