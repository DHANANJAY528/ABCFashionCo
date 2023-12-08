public with sharing class CustomerHomePageVFController {

    public static String recordIdAtt{get;set;}

    public CustomerHomePageVFController(){

        if(ApexPages.currentPage().getParameters().get('id') != null){
             
            Blob key = Blob.valueOf('1234567890123456');
            String idParam= ApexPages.currentPage().getParameters().get('id');
             //encrypted blob
            Blob encodedEncryptedBlob = EncodingUtil.base64Decode(idParam);
            //decrypted blob
            Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, encodedEncryptedBlob);
            //decrypted string
            recordIdAtt = decryptedBlob.toString();
        
            System.debug(recordIdAtt);
        }
    }
}
