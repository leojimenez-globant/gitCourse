import { LightningElement, api, track,wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

column = [
    { label: 'ID', fieldName: 'id' },
    { label: 'Name', fieldName: 'name' },
    { label: 'Email', fieldName: 'email', type: 'email' },
];

export default class Pruebaaaa extends LightningElement {
    columns = column;
    @track data = [];

      connectedCallback(){
        this.data = [{ id: 1, name: 'John', email: 'john@example.com' },
        { id: 2, name: 'Jane', email: 'jane@example.com' },
        { id: 3, name: 'Bob', email: 'bob@example.com' }];
        
      }
}