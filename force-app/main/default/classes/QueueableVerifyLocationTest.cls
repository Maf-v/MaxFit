@isTest
public class QueueableVerifyLocationTest{

    @isTest
    static void verifyLocationTest(){
        Test.setMock(HttpCalloutMock.class, new LocationHttpCalloutMock('OK'));

        List<Location__c> locationList = new List<Location__c>();
        Location__c locationObj = new Location__c(
            Name = 'Location Test',
            Street__c = 'Uruguay',
            State__c = 'Buenos Aires',
            City__c = 'Bahia Blanca',
            Postal_Code__c = '8000',
            Country__c = 'Argentina'
        );
        insert locationObj;
        locationList.add(locationObj);

        Test.startTest();
        Id jobID = System.enqueueJob(new QueueableVerifyLocation(locationList));
        Test.stopTest();
        
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', jobInfo.Status, 'Queueable Job creado');
        Location__c location = [SELECT Id, Verified__c FROM Location__c WHERE Id = :locationObj.Id];
        System.assertEquals(true, location.Verified__c, 'La ubicacion esta verificada');
    }

    @isTest
    static void verifyLocationFalseTest(){
        Test.setMock(HttpCalloutMock.class, new LocationHttpCalloutMock('Empty Body'));

        List<Location__c> locationList = new List<Location__c>();
        Location__c locationObj = new Location__c(
            Name = 'Location Test',
            Street__c = 'Uruguay',
            State__c = 'Buenos Aires',
            City__c = 'Bahia Blanca',
            Postal_Code__c = '8000',
            Country__c = 'Argentina'
        );
        insert locationObj;
        locationList.add(locationObj);

        Test.startTest();
        Id jobID = System.enqueueJob(new QueueableVerifyLocation(locationList));
        Test.stopTest();
        
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', jobInfo.Status, 'Queueable Job creado');
        Location__c location = [SELECT Id, Verified__c FROM Location__c WHERE Id = :locationObj.Id];
        System.assertEquals(false, location.Verified__c, 'La ubicacion no esta verificada');
        List<Error_Log__c> errorLogs = [SELECT Id, Process_Name__c, Log_Date_Time__c FROM Error_Log__c WHERE Process_Name__c = 'LocationTriggerHandler' AND Log_Date_Time__c = TODAY];
        System.assertEquals(0, errorLogs.size(), 'No se crearon Error Log');
    }

    @isTest
    static void verifyLocationExceptionWithErrorTest(){
        Test.setMock(HttpCalloutMock.class, new LocationHttpCalloutMock('Bad Request'));

        List<Location__c> locationList = new List<Location__c>();
        Location__c locationObj = new Location__c(
            Name = 'False',
            Street__c = 'False',
            State__c = 'False',
            City__c = 'False',
            Postal_Code__c = 'False',
            Country__c = 'Argentina'
        );
        locationList.add(locationObj);

        Test.startTest();
        Id jobID = System.enqueueJob(new QueueableVerifyLocation(locationList));
        Test.stopTest();
        
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', jobInfo.Status, 'Queueable Job creado');
        List<Error_Log__c> errorLogs = [SELECT Id, Process_Name__c, Log_Date_Time__c FROM Error_Log__c WHERE Process_Name__c = 'LocationTriggerHandler' AND Log_Date_Time__c = TODAY];
        System.assertEquals(1, errorLogs.size(), 'Se creo correctamente el Error Log');
    }
    
    @isTest
    static void verifyLocationExceptionTest(){
        List<Location__c> locationList = new List<Location__c>();
        for(Integer i=0; i < 10; i++) {
            locationList.add(new Location__c(
                Name = 'Location Test' + i,
                Street__c = 'Street' + i,
                City__c = 'Bahia Blanca',
                State__c = 'Buenos Aires',
                Postal_Code__c = '800' + i,
                Country__c = 'Argentina'
            ));
        }

        Test.startTest();
        Id jobID = System.enqueueJob(new QueueableVerifyLocation(locationList));
        Test.stopTest();
        
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', jobInfo.Status, 'Queueable Job creado');
        List<Error_Log__c> errorLogs = [SELECT Id, Process_Name__c, Log_Date_Time__c FROM Error_Log__c WHERE Process_Name__c = 'LocationTriggerHandler' AND Log_Date_Time__c = TODAY];
        System.System.debug(errorLogs);
        System.assertEquals(10, errorLogs.size(), 'Error Logs creados');
    }

}