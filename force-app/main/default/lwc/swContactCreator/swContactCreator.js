import { LightningElement } from 'lwc';
import findCharacter from '@salesforce/apex/SWCharacterCallout.findCharacter';

export default class swContactCreator extends LightningElement {
    searchKey;
    personaje;
    error;
    
    handleOnChange(event){
        this.searchKey = event.target.value;
    }

    clickOnSearch() {    

        alert("Buscando..." + this.searchKey);

        findCharacter({num: this.searchKey})
        .then(result=>{
            console.log(result);
            this.personaje = result;
            this.error = undefined;
            console.log(this.personaje);
            console.log(this.personaje.name);
            this.template.querySelector('lightning-input[data-name="temp"]').value = this.personaje.name;
            console.log(nombres);
            console.log(this.template.querySelector('lightning-input[data-name="temp"]'));
            /* document.getElementBysearchKey('altura').value = personaje.get('height');
            document.getElementBysearchKey('genero').value = personaje.get('gender');
            document.getElementBysearchKey('colorDeCabello').value = personaje.get('hair_color');
            document.getElementBysearchKey('colorDeOjos').value = personaje.get('eye_color');
            document.getElementBysearchKey('url').value = personaje.get('url');
            document.getElementBysearchKey('planeta').value = personaje.get('homeworld');
            document.getElementBysearchKey('numero').value = personaje.get('id'); */
            
            alert("Chau " + this.personaje.name);
        })
        .catch(error=>{
            
            this.error = error;
            this.personaje = undefined;

            console.log(error);
        })

    }



    
}