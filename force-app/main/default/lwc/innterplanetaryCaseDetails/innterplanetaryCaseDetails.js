import { LightningElement , api} from 'lwc';

export default class InnterplanetaryCaseDetails extends LightningElement {

    @api casoId;

    submitDetails(){
        console.log('boton');
        console.log(casoId);
    }
}