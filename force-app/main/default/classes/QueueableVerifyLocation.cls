public with sharing class QueueableVerifyLocation implements Queueable, Database.AllowsCallouts {
    
    public List<Location__c> newLocationsList;
    
    public QueueableVerifyLocation(List<Location__c> triggerList) {
        this.newLocationsList = triggerList;
    }

    public void execute(QueueableContext qc) {

        List<Location__c> locationObjVerified = new List<Location__c>();
        for (Location__c locationObj : newLocationsList) {

            String baseURL = 'https://us-street.api.smartystreets.com/street-address?auth-id=7a5f1152-2dba-ddb7-689b-1f39d3c6db01&auth-token=DRi1fbMg91UQURe8h0uF';
            String endpoint = baseURL + '&street='+EncodingUtil.urlEncode(locationObj.Street__c, 'UTF-8') + '&city='+EncodingUtil.urlEncode(locationObj.City__c, 'UTF-8') + '&state='+EncodingUtil.urlEncode(locationObj.State__c, 'UTF-8') + '&zipcode='+EncodingUtil.urlEncode(locationObj.Postal_Code__c, 'UTF-8') + '&match=enhanced';

            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(endpoint);
            request.setHeader('Content-Type', 'application/json');
    
            Http http = new Http();
            
            try {
                HttpResponse response = http.send(request);
                if (response.getStatus() == 'OK' && response.getStatusCode() == 200) {
                    String responseBody = response.getBody();
                    Location__c newLocation = locationObj.clone(true, false, false, false);
                    if (!String.isBlank(responseBody) && responseBody.length() > 2) {
                        newLocation.Verified__c = true;
                    } else {
                        newLocation.Verified__c = false;
                    }
                    locationObjVerified.add(newLocation);
                } else {
                    TransactionLogHandler.exceptionHandlerWithError(response.getBody(), 'LocationTriggerHandler');
                }
            } catch (Exception except) {
                TransactionLogHandler.exceptionHandler(except, 'LocationTriggerHandler');
            }
            
        }
        update locationObjVerified;
    }
}