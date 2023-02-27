global class LeadProcessor implements Database.Batchable<sObject>{
	global Integer count = 0;
        //Start
    global Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator(
            'SELECT Id, LeadSource FROM Lead'
        ); 
    }
    
    //execute
    global void execute(Database.BatchableContext bc, List<Lead> l_can){
        List<lead> candidatos = new List<lead>();
        for (Lead cand : l_can){
            cand.leadsource = 'Dreamforce';
            candidatos.add(cand);
            count += 1;
        }
        update candidatos;
    }
    
    //finish
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                            FROM AsyncApexJob 
                            WHERE ID = :bc.getJobId() ];
        system.debug(job.Status);
        system.debug('Count '+ count);

    }

}