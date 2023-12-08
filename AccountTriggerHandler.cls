public class AccountTriggerHandler {
    
    public static List<Account> newList;
    public static List<Account> oldList;
    public static Map<Id, Account> newMap;
    public static Map<Id, Account> oldMap;
    
    
    public static void beforeUpdate(){  
        
    }
    public static void afterInsert(){  
        sendEmail(newList);
    }
    
    public static void sendEmail(List<Account> accounts) {
        Account__c ProfileURL = Account__c.getOrgDefaults();

        EmailTemplate et=[Select id from EmailTemplate where name=:'Account Default Email Template'];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Account acc : accounts){

          
            if(acc.Email__c != null ){
                List<String> toAddresses = new List<String>();
                toAddresses.add(acc.Email__c);
                
                //Encrypting the id with aes 128 algorithm
         		String clearText =acc.Id;
                Blob key = Blob.valueOf('1234567890123456');
                //encrypted blob
                Blob cipherText = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(clearText));
                //encrypted string
                String encodedId = EncodingUtil.base64Encode(cipherText);
                encodedId = EncodingUtil.URLEncode(encodedId,'UTF-8');
                System.debug(encodedId);
                
                String url = ProfileURL.URL__c +'?id='+encodedId;
                system.debug('URL'+url);
                String body = 'Hello '+acc.Name + ','+'<br/>'+ '<br/>';
                body += 'Thank you for signing up . Please complete your profile with this <a href='+url+'>Profile Link.</a>';
                body+='<br/>'+ '<br/>';
                body += 'Thank You';
                body+='<br/>'+ '<br/>';
                body+='Regards,'+'<br/>';
                body+='ABC Fashion Co.';
                
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
				
                singleMail.setSubject('Profile Link - '+acc.Name);  
                singleMail.setHtmlBody(body);
                singleMail.setTargetObjectId(acc.OwnerId);
                singleMail.setTemplateId(et.Id);
                singleMail.setSaveAsActivity(false);
                singleMail.setToAddresses(toAddresses);
                emails.add(singleMail);
            }
        }

        //send mail
       Messaging.sendEmail(emails);
    }
}
