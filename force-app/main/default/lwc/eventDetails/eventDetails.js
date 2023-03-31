import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import LOCATION from '@salesforce/schema/Event__c.Location__c';
import STREET from '@salesforce/schema/Location__c.Street__c';
import CITY from '@salesforce/schema/Location__c.City__c';
import COUNTRY from '@salesforce/schema/Location__c.Country__c';
import STATE from '@salesforce/schema/Location__c.State__c';
import POSTAL_CODE from '@salesforce/schema/Location__c.Postal_Code__c';


export default class EventDetails extends LightningElement {
    @api recordId;
    errors;
    locationID;
    locationData;

    @wire(getRecord, { recordId: '$recordId', fields: [LOCATION] })
    wireRecord({ data }) {
        if (data) {
            this.locationID = getFieldValue(data, LOCATION);
        }
    }

    @wire(getRecord, { recordId: '$locationID', fields: [STREET, CITY, COUNTRY, STATE, POSTAL_CODE] })
    wireLocation({ error, data }){
        if (error) {
            this.errors = error;
            this.locationData = undefined;
        } else if (data) {
            this.locationData = data;
            this.errors= undefined;
        }
    }

    get street() {
        return getFieldValue(this.locationData, STREET);
    }

    get city() {
        return getFieldValue(this.locationData, CITY);
    }

    get country() {
        return getFieldValue(this.locationData, COUNTRY);
    }

    get state() {
        return getFieldValue(this.locationData, STATE);
    }

    get postalCode() {
        return getFieldValue(this.locationData, POSTAL_CODE);
    }
}