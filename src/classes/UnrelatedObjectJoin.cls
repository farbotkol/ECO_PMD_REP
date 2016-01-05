global class UnrelatedObjectJoin {

	
    	
    @RemoteAction
	global static List<JoinedObjects> getJoinObjects() {

        List<AggregateResult> groupedPeople = [SELECT PersonId__c  FROM ExpendItem__c WHERE PersonId__c <> NULL GROUP BY PersonId__c ];
       
        List<string> personIds = new List<string>();
        
        
        for (AggregateResult ar : groupedPeople)
        {
            personIds.add((string)ar.get('PersonId__c'));
            
        }
        System.debug(personIds);
        List<JoinedObjects> joindedObject = new List<JoinedObjects>();
       
    	Map<string, User> users = new Map<string,User>();
		for(User u : [select PersonId__c, Name from User where PersonId__c IN :personIds])
        	users.put(u.PersonId__c, u);
        System.debug('lfxxxx' +  users);
        
        for(ExpendItem__c item : [select id, name, PersonId__c from ExpendItem__c order by id limit 10]) {
            System.debug('lfxxxx2' +  item);
           
            JoinedObjects joindedObject1 = new JoinedObjects();
            System.debug('lfxxxx3' +  users.get(item.PersonId__c));
        	
            try{
                User u = users.get(item.PersonId__c);
                joindedObject1.userId = u.Id ;
                joindedObject1.userName = u.Name;
            }catch(Exception ex){}
            joindedObject1.personId = item.PersonId__c;
            joindedObject1.expendItemId =item.Id;
            joindedObject1.expendItemName =item.Name;
            joindedObject.add(joindedObject1);
        }
        
        return joindedObject;
    }

	    
    global class JoinedObjects{
        
        public id userId {get; set;}
        public string userName {get; set;}
        public string personId {get; set;}
        public id expendItemId {get; set;}
        public string expendItemName {get; set;}
        
        
    }
}