trigger caseRelatedToTask on Case (after insert ,before insert) {

    /* Set<String> contactsIdSet = new Set<String>();
    List<Task> taskUp = new List<Task>();

    for (Case c: Trigger.new){
        contactsIdSet.add(c.ContactId);  
    }

    List<Task> possibleTaskToRelate = [SELECT WhatId, CreatedDate FROM Task WHERE WhoId IN :contactsIdSet AND WhatId = null ];

    
    for(Case c2: Trigger.new){
        for(Task taskToUpdate: possibleTaskToRelate){
            
            DateTime dt = taskToUpdate.CreatedDate;
            DateTime dt2 = c2.CreatedDate;
            
            Integer days = Date.valueOf(dt).daysBetween(date.valueof(dt2));
            Integer hours = math.mod(Integer.valueOf((dt2.getTime() - (dt).getTime())/(1000*60*60)),24);                
            Integer minutes = math.mod(Integer.valueOf((dt2.getTime() - (dt).getTime())/(1000*60)),60);

            if(days < 1 && hours < 1 && minutes < 3){
                taskToUpdate.WhatId = c2.Id;
                taskUp.add(taskToUpdate);
            }
        }
        if (!taskUp.isEmpty()){
            update taskUp;
        }
    } */

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            List<Case> casesToFillPlanet = new List<Case>();
            for(Case caseToCheck : Trigger.new){
                if(caseToCheck.Origin == 'Email'){
                    casesToFillPlanet.add(caseToCheck);
                }
            }
            if(casesToFillPlanet.size() >0){
                caseHelper.addPlanetToCase(casesToFillPlanet);
            }
        }
    }
    
    
}