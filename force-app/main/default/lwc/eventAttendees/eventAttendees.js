import { LightningElement, api } from 'lwc';
import getAttendees from '@salesforce/apex/EventDetailController.getAttendees';

const columns = [
    { label: 'Nombre', fieldName: 'Name', type: 'text' },
    { label: 'Mail', fieldName: 'Email', type: 'email' },
    { label: 'Compania', fieldName: 'Company', type: 'text' },
    { label: 'Ubicacion', fieldName: 'Location', cellAttributes: {iconName: "utility:location", iconPosition: "left"}}
]

export default class EventAttendees extends LightningElement {
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
                console.log('Mostrar data: ', this.eventAttendeesData);
            })
            .catch(error => {
                this.errors = error;
                this.eventAttendeesData = undefined;
                console.log('Dio error');
            })
    }
}