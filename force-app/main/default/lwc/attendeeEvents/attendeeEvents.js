import { LightningElement, api } from 'lwc';
import getEventAttendees from '@salesforce/apex/AttendeeEventsController.getEventAttendees';

const columns = [
    { label: 'Nombre del Evento', fieldName: 'EventName', type: 'text'},
    { label: 'Nombre del Organizador', fieldName: 'OrganizerName', type: 'text'},
    { label: 'Fecha del evento', fieldName: 'EventStartDate', type: 'text'},
    { label: 'Ubicacion', fieldName: 'EventLocation', type: 'text'},
]

export default class AttendeeEvents extends LightningElement {
    @api recordId;
    columns = columns;
    errors;
    eventsData;

    connectedCallback() {
        getEventAttendees({ attendeeID: this.recordId})
        .then((result) => {
            this.errors = undefined;
            let fieldsData = [];
            result.forEach(eventAttendee => {
                let eventAttendeeData = {};
                eventAttendeeData.Id = eventAttendee.Id;
                eventAttendeeData.EventName = eventAttendee.Event__r.Name;
                eventAttendeeData.OrganizerName = eventAttendee.Event__r.Event_Organizer__r.Name;
                eventAttendeeData.EventStartDate = new Date(eventAttendee.Event__r.Start_Date_Time__c).toLocaleDateString();
                eventAttendeeData.EventLocation = eventAttendee.Event__r.Location__r.Name;
                fieldsData.push(eventAttendeeData);
            })
            this.eventsData = fieldsData;
        })
        .catch((error) => {
            this.errors = error;
        })
    }
    
    get loaded() {
        return this.eventsData;
    }
    
    get dataUpcomingEvents() {
        const today = new Date().toLocaleDateString();
        console.log('Today: ', today);
        const filteredEventsData = this.eventsData.filter((event) => {
            console.log('Event Data: ', event.EventStartDate);
            return event.EventStartDate >= today;
        });
        console.log('Data filtrada', filteredEventsData);
        return filteredEventsData;
    }

    get dataPastEvents() {
        const today = new Date().toLocaleDateString();
        return this.eventsData.filter((event) => {
            return event.EventStartDate < today;
        })
    }

}