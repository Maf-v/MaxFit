import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EVENT from '@salesforce/schema/Event__c';
import NAME from '@salesforce/schema/Event__c.Name';
import EVENT_ORGANIZER from '@salesforce/schema/Event__c.Event_Organizer__c';
import START_DATE_TIME from '@salesforce/schema/Event__c.Start_Date_Time__c';
import END_DATE_TIME from '@salesforce/schema/Event__c.End_Date_Time__c';
import MAX_SEATS from '@salesforce/schema/Event__c.Max_Seats__c';
import EVENT_DETAIL from '@salesforce/schema/Event__c.Event_Detail__c';

export default class AddEvent extends NavigationMixin(LightningElement) {
    eventObj = EVENT;
    nameField = NAME;
    eventOrganizerField = EVENT_ORGANIZER;
    startDateTimeField = START_DATE_TIME;
    endDateTimeField = END_DATE_TIME;
    maxSeatsField = MAX_SEATS;
    eventDetailField = EVENT_DETAIL;

    handleSuccess(event){
        const toastSuccess = new ShowToastEvent({
            title: 'Created',
            message: 'Fue creado correctamente',
            variant: 'success'
        })
        this.dispatchEvent(toastSuccess);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: this.eventObj,
                actionName: 'view'
            }
        })
    }
    
}