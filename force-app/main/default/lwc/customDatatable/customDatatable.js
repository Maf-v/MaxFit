import LightningDatatable from 'lightning/datatable';
import customTemplate from './customTemplate.html';


export default class MyCustomTypeDatatable extends LightningDatatable {
    static customTypes = {
        navigateToRecord: {
            template: customTemplate,
            standardCellLayout: true,
            typeAttributes: ['recordId', 'eventName'],
        }
    }
}