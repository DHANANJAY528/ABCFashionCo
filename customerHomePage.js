import { LightningElement,api,track,wire } from 'lwc';
import getCode from '@salesforce/apex/CustomerHomePageController.getCode';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecords from '@salesforce/apex/CustomerHomePageController.getRecords';
import saveRecords from '@salesforce/apex/CustomerHomePageController.saveRecords';
import sendCode from '@salesforce/apex/CustomerHomePageController.sendCode';

export default class CustomerHomePage extends LightningElement {
    @api recordId;
    @track validate = false;
    code = 0;
    @track enteredCode = 0;
    @track message;
    @track variant;
    @track showModal = false;
    @track accountData;
    @track shoeSize;
    @track shirtSize;
    @track accountName;
    @track accountPhone;
    @track accountEmail;
    @track ownerId;
    @track codeSent = false;
    @track birthDate;
    @track profileCompleted = false;

    phoneRegex = /^(1\s?)?(\d{3}|\(\d{3}\))[\s\-]?\d{3}[\s\-]?\d{4}$/;

    get mainDivClass() {
        return 'slds-notify slds-notify_toast slds-theme_'+this.variant;
      }
    get messageDivClass() {
        return 'slds-icon_container slds-icon-utility-'+this.variant+' slds-icon-utility-success slds-m-right_small slds-no-flex slds-align-top';
    }
    get iconName() {
        return 'utility:'+this.variant;
    }

    @wire(getCode, { })
    wiredGetCode({ error, data }) {
        if (data) {

            this.code = data;
            this.error = undefined;

        } else if (error) {
            this.error = error;
            console.error(error);
        }
    }

    connectedCallback() {
         getRecords({ recId: this.recordId }).then(data => {
               
                if (data) {
                    this.shoeSize = data.shoeSize;
                    this.shirtSize = data.shirtSize;
                    this.accountName = data.accountName;
                    this.accountPhone = data.phone;
                    this.accountEmail = data.accountEmail;
                    this.ownerId = data.ownerId;
                    this.birthDate = data.birthDate;
                    this.profileCompleted = data.profileCompleted;
                    this.error = undefined;

                }
            }).catch(error => {
                let errorMessage = error?.body?.message;
                console.log(JSON.stringify(this.error));
                this.message=errorMessage;
                this.variant = 'error';
                this.showModal = true;
                
            });
     
    }

    checkPhoneNumber() {
        let validate = false;
        if (this.phoneRegex.test(this.accountPhone)) {
            console.log('Valid US phone number');
                validate = true;
        }
        else {
            console.log('Invalid US phone number');
        }
        return validate;
    }

    handlePhoneChange(event){
        let phone = event.detail.value;
        this.accountPhone = phone;
    }

    handleCodeChange(event) {
        let enteredCode = event.detail.value;
        this.enteredCode = enteredCode;
    }

    handleDateChange(event) {
        let birthDate = event.detail.value;
        this.birthDate = birthDate;
    }

    handleValidate(){
        
        if(parseInt(this.enteredCode) === parseInt(this.code)){
            this.validate = true;
        }

        else{
           
            this.message='Please check the verfication code';
            this.variant = 'error';
            this.showModal = true;
            //this.toaster('Incorrect Code','Please check the verfication code','error','dismissible');
        }

    }

    handleSendCode(){
       
            sendCode({ code: this.code, email: this.accountEmail, accountName: this.accountName, ownerId: this.ownerId }).then(result => {
                
                if (result) {
                    this.codeSent = true;
                }
            }).catch(error => {
                let errorMessage = error?.body?.message;
                console.log(JSON.stringify(this.error));
                this.message=errorMessage;
                this.variant = 'error';
                this.showModal = true;
                
            });
    }

    closeModal(){
        this.showModal=false;
    }

    onShoeSizeChange(event) {
        let value = event.detail.selectedValue;
        this.shoeSize = value;
    }

    onShirtSizeChange(event) {
        let value = event.detail.selectedValue;
        this.shirtSize = value;
    }


    handleSave(){
       
        if(this.accountPhone && this.shirtSize && this.shoeSize && this.birthDate ){
            if(!this.checkPhoneNumber()){
                this.message='Enter a valid phone number';
                this.variant = 'error';
                this.showModal = true;
            }
            else{
                saveRecords({ recId: this.recordId, accountPhone: this.accountPhone, shirtSize: this.shirtSize, shoeSize: this.shoeSize,dob : this.birthDate }).then(result => {
               
                if (result) {
                    this.message='Record saved successfully.';
                    this.variant = 'success';
                    this.showModal = true;
                    this.handleCancel();
                }
                }).catch(error => {
                    let errorMessage = error?.body?.message;
                    console.log(JSON.stringify(this.error));
                    this.message=errorMessage;
                    this.variant = 'error';
                    this.showModal = true;
                    
                });
            }
        }

        else{
            this.message='Please fill the required values.';
            this.variant = 'error';
            this.showModal = true;
        }
    }

    handleCancel(){
        window.location.reload();
    }



}
