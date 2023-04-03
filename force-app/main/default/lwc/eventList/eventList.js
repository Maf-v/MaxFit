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
    eventsToDisplay;
    
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
                    eventData.StartDate = event.Start_Date_Time__c;
                    fieldData.push(eventData);
                });
                this.eventsList = fieldData;
                this.updateEventsToDisplay(); // actualizar eventsToDisplay
            })
            .catch(error => {
                this.errors = error;
            })
    }
    
    updateEventsToDisplay() {
        // aplicar todos los filtros
        let filteredEvents = this.eventsList;
        if (this.nameSearch) {
            filteredEvents = filteredEvents.filter((record) => {
                return record.Name.toLowerCase().includes(this.nameSearch.toLowerCase());
            });
        }
        if (this.dateSearch) {
            filteredEvents = filteredEvents.filter((record) => {
                return record.StartDate >= this.dateSearch;
            });
        }
        if (this.locationSearch) {
            filteredEvents = filteredEvents.filter((record) => {
                return record.Location.toLowerCase().includes(this.locationSearch.toLowerCase());
            });
        }
        this.eventsToDisplay = filteredEvents;
    }
    
    nameSearch = '';
    handleNameChange(event) {
        this.nameSearch = event.detail;
        this.updateEventsToDisplay(); // actualizar eventsToDisplay
    }
    
    dateSearch = '';
    handleDateChange(event) {
        this.dateSearch = event.detail;
        this.updateEventsToDisplay(); // actualizar eventsToDisplay
    }
    
    locationSearch = '';
    handleLocationChange(event) {
        this.locationSearch = event.detail;
        this.updateEventsToDisplay(); // actualizar eventsToDisplay
    }
    

}  