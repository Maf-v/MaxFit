import { LightningElement, api } from 'lwc';
import  getSpeakers  from '@salesforce/apex/EventDetailController.getSpeakers';

const columns = [
    { label: 'Nombre', fieldName: 'Name', type: 'text' },
    { label: 'Mail', fieldName: 'Email', type: 'email' },
    { label: 'Telefono', fieldName: 'Phone', type: 'phone' },
    { label: 'Compania', fieldName: 'Company', type: 'text' },
];

export default class EventSpeakers extends LightningElement {
    @api recordId;
    columns = columns;
    eventSpeakersData;
    errors;

    connectedCallback() {
        getSpeakers({ eventID: this.recordId })
            .then((result) => {
                this.errors = undefined;
                //Datatable no reconocera los campos de objetos relacionados
                //Entonces se debe crear un array, con un objeto por Event Speaker, para pasarle al Datatable
                let fieldsData = [];
                result.forEach(eventSpeaker => {
                    //La key sera el fieldName del campo, y el value su valor
                    let eventSpeakerData = {};
                    eventSpeakerData.Id = eventSpeaker.Id;
                    eventSpeakerData.Name = eventSpeaker.Name;
                    eventSpeakerData.Email = eventSpeaker.Speaker__r.Email__c;
                    eventSpeakerData.Phone = eventSpeaker.Speaker__r.Phone__c;
                    eventSpeakerData.Company = eventSpeaker.Speaker__r.Company__c;
                    fieldsData.push(eventSpeakerData);
                });
                this.eventSpeakersData = fieldsData;
            })
            .catch((error) => {
                this.errors = error;
                this.eventSpeakersData = undefined;
            })
    }

}