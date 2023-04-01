import { LightningElement} from 'lwc';
import getEvents from '@salesforce/apex/EventListController.getEvents';

const columns = [
    { label: 'View', fieldName: 'Id', type: 'navigateToRecord', typeAttributes: { recordId: {fieldName: 'Id'}, eventName: {fieldName: 'Name'}} },
    { label: 'Evento', fieldName: 'Name'},
    { label: 'Event Organizer', fieldName: 'OrganizerName'},
    { label: 'Ubicacion', fieldName: 'Location'},
    { label: 'Detalles', fieldName: 'Details'}
];

export default class EventList extends LightningElement {
    columns = columns;
    errors;
    eventsList;

    connectedCallback() {
        getEvents()
            .then((result) => {
                let fieldData = [];
                result.forEach(event => {
                    let eventData = {};
                    eventData.Id = event.Id;
                    eventData.Name = event.Name;
                    eventData.OrganizerName = event.Event_Organizer__r.Name;
                    eventData.Location = event.Location__r.Name;
                    eventData.Details = event.Event_Detail__c;
                    fieldData.push(eventData);
                });
                this.eventsList = fieldData;
            })
            .catch(error => {
                this.errors = error;
            })
    }

}  