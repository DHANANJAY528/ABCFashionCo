@RestResource(urlMapping='/getAccount/*') 
global without sharing class RestGetAccount {
    
    @HttpPost 
    global static Map<string,list<sObject>> getAccount(){
        
        Map<string,list<sObject>>  mapOfSobject= new Map<string,list<sObject>>();
        
        try{
            system.debug('inside rest class');
            String RequestedBody = ''; 
            RestResponse res = RestContext.response;
            RestRequest r = RestContext.request; 
            RequestedBody = r.requestBody.toString();
            Object bodyRequest = JSON.deserializeUntyped(RequestedBody);
            
            system.debug('bodyRequest--->'+bodyRequest);
            Map<String,Object> Requestedmap = (Map<String,Object>) bodyRequest;
            
            String accountQuery;
            
          
           if(Requestedmap.containsKey('accountQuery')){
                accountQuery=(String) Requestedmap.get('accountQuery'); 
                if(string.isBlank(accountQuery)){
                    return null; 
                }         
                
                SObject[] accountRes = Database.query( accountQuery);  
                mapOfSobject.put('accountRes', accountRes);
            }
            
            }catch(exception ex){
            system.debug('Error: '+ex.getMessage() + 'Line Number-->' + ex.getLineNumber());
            RestContext.response.statusCode = 500;
            throw ex;
        }
        return mapOfSobject;
    }     
}
