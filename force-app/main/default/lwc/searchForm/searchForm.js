import { LightningElement, api } from 'lwc';

export default class SearchForm extends LightningElement {
    @api eventNameValue;
    @api eventStartDateValue;
    @api eventLocationValue;
    @api unfilteredList;
    filteredList;

    handleNameChange(event) {
        let search = event.detail.value;
        this.dispatchEvent(new CustomEvent('namechange', { detail: search }));
    }

    handleDateChange(event) {
        let search = event.detail.value;
        this.dispatchEvent(new CustomEvent('datechange', { detail: search }));
    }

    handleLocationChange(event) {
        let search = event.detail.value;
        this.dispatchEvent(new CustomEvent('locationchange', { detail: search }));
    }

}
