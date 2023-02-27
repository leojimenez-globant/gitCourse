import { LightningElement, track, api } from 'lwc';
import getCases from '@salesforce/apex/caseHelper.retrieveListCases';
import searchPlanet from '@salesforce/apex/WSSearchPlanet.searchPlanetCallOut';
import getFieldsFromFieldSet from '@salesforce/apex/LeoHelper.RetrieveFieldMap';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';

const actions = [
    { label: 'Ver detalle', name: 'show_details' },
];

const cols=[
    {label: 'Caso', fieldName: 'caseId', type: 'url', 
        typeAttributes: {label: { fieldName: 'caseNumber' }, target: '_parent'}}, 
    {label:'Asunto',fieldName:'subject', type:'text',hideDefaultActions: true},
    {label:'Estado',fieldName:'status', type:'text',hideDefaultActions: true},
    {label:'Email de contacto',fieldName:'email', type:'text',hideDefaultActions: true},
    {label: 'Contacto', fieldName: 'contactId', type: 'url', 
        typeAttributes: {label: { fieldName: 'contact' }, target: '_parent'}},
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    } 
]

export default class InterplanetaryCases extends LightningElement {
    @track isModalOpen = false;
    @track planetaryCases = [];
    @track columns = cols;
    @track headerTitle;
    @track recordIdd;
    @track fieldsToShow = [];
    @track disableButton = false;
    channelName = '/event/PlanetaryCase__e';

    connectedCallback(){
        this.handleSubscribe();
        getCases().then((result) => {
            if(result.length > 0){
                this.planetaryCases = result;
                console.log(this.planetaryCases);
            } else {
                this.onError('UPS!!','No hay casos planetarios');
            }
            getFieldsFromFieldSet({objectName : 'Case', fieldSetName : 'Case_Detail'}).then((result2) => {
                console.log(JSON.parse(JSON.stringify(result2)));
                let mapTest = JSON.parse(JSON.stringify(result2));
                for(let key in mapTest){
                    this.fieldsToShow.push(mapTest[key]);
                }
                console.log(this.fieldsToShow);
            }).catch((error) => {
                this.onError(error.message, 'Error');
            });
        })
        .catch((error) => {
            this.onError(error.message, 'Error');
        });
    }

    handleRowAction(event){
        const row = event.detail.row;
        this.headerTitle = 'Caso: ' + row.caseNumber;
        console.log(row.caseId.substr(1));
        this.recordIdd = row.caseId.substr(1);
        this.isModalOpen = true;

        const actionName = event.detail.action.name;
        
        console.log('Action Name: ' + actionName);
        console.log('Row: ' + JSON. stringify(row));
        console.log(row.caseId);
    }

    hideModalBox(){this.isModalOpen = false;}


    scanCase(){
        this.disableButton = true;
        let arraySearch = this.planetaryCases.find(element => element.caseId.substr(1) == this.recordIdd);
        console.log(arraySearch);
        console.log(arraySearch.accesscode);
        searchPlanet({acesscode: arraySearch.accesscode, caseId: this.recordIdd}).then((response) => {
            if(response == 'false' || response == 'true'){
                let messageToShow = response == 'true' ? 'Found: Say hello To Baby Joya!!' : 'Not Found: Baby Joya was not there :(';
                let toastEvent = new ShowToastEvent({
                    title: 'Successful Scanning',
                    message: messageToShow,
                    variant: 'success'
                });
                this.dispatchEvent(toastEvent);
            } else {
                let messageToShow = response.includes("interference") ? 'Interplanetary interference, will be sent again in background' : response;
                let variantToShow = response.includes("interference") ? 'warning' : 'error';
                let toastEvent = new ShowToastEvent({
                    title: 'Not Successful Scanning',
                    message: messageToShow,
                    variant: variantToShow
                });
                this.dispatchEvent(toastEvent);
            }
            setTimeout(() => {
                //window.location.reload();
                eval("$A.get('e.force:refreshView').fire();");
            }, 3000);
           
        }).catch((error) => {
            this.onError(error.message, 'Error');
        });
    }

    onError (titleToShow,messageToShow) {
		let toastEvent = new ShowToastEvent({
            title: titleToShow,
            message: messageToShow,
            variant: 'error'
        });
        this.dispatchEvent(toastEvent);
	}

    handleSubscribe() {
        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, this.messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
        });
    }

    messageCallback = (response) => {
        console.log('Event response');
        if(response.data.payload.Refresh__c){
            eval("$A.get('e.force:refreshView').fire();");
        }
    }
}