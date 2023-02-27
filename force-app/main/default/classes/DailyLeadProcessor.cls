global class DailyLeadProcessor implements Schedulable  {
    global void execute(SchedulableContext sc){
        List<Lead> leaad = [SELECT Id FROM Lead WHERE LeadSource = null LIMIT 200];
       	
        List<Lead> leadUpgrade = new List<Lead>();
        if(!leaad.isEmpty()){
            for (Lead lea :leaad){
            	lea.LeadSource = 'Dreamforce';
            	leadUpgrade.add(lea);
        	}
        	 
            update leadUpgrade;
        
        }
    
    }
}