trigger leadDuplicatedEmail on Lead (before insert, before update) {
	
    Set <String> emailSets = new set <String>();
    Set <String> existingEmailSets = new set <String>();
    
    for (Lead lead1 : System.Trigger.new){
        emailSets.add(lead1.Email);
    }
    
    for (Lead l : [SELECT Email FROM Lead WHERE Email IN :emailSets]){
        existingEmailSets.add(l.Email);
    }
    
    if (Trigger.IsInsert || Trigger.IsUpdate){
        for (Lead lead2 : System.Trigger.new){
            if (existingEmailSets.contains(lead2.Email)){
                lead2.Email.addError('Email ya existe: ' + lead2.Email);
            } 
        }
    }
}