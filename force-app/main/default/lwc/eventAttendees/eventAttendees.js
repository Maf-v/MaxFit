import { LightningElement, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getAttendees from '@salesforce/apex/EventDetailController.getAttendees';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

const columns = [
    { label: 'Nombre', fieldName: 'Name', type: 'text' },
    { label: 'Mail', fieldName: 'Email', type: 'email' },
    { label: 'Compania', fieldName: 'Company', type: 'text' },
    { label: 'Ubicacion', fieldName: 'Location', cellAttributes: {iconName: "utility:location", iconPosition: "left"}}
]

export default class EventAttendees extends NavigationMixin(LightningElement) {
    @api recordId;
    columns = columns;
    eventAttendeesData;
    errors;

    connectedCallback() {
        getAttendees({ eventID: this.recordId}) 
            .then((result) => {
                this.error = undefined;
                let fieldData = [];
                result.forEach(eventAttendee => {
                    let eventAttendeeData = {};
                    eventAttendeeData.Id = eventAttendee.Id;
                    eventAttendeeData.Name = eventAttendee.Name;
                    eventAttendeeData.Email = eventAttendee.Attendees__r.Email__c;
                    eventAttendeeData.Company = eventAttendee.Attendees__r.Company_Name__c;
                    eventAttendeeData.Location = eventAttendee.Event__r.Location__r.Name;
                    fieldData.push(eventAttendeeData);
                });
                this.eventAttendeesData = fieldData;
            })
            .catch(error => {
                this.errors = error;
                this.eventAttendeesData = undefined;
            })
    }

    handleClick() {
        const defaultValues = encodeDefaultFieldValues({
            Event__c: this.recordId
        });
        
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event_Attendee__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        })
    }

}