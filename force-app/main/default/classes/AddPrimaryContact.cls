public class AddPrimaryContact implements Queueable {
	private Contact contacto;
    private String estado;
    
    public AddPrimaryContact (Contact cnt , String stateAbr){
        this.contacto = cnt;
        this.estado = stateAbr;
    }
    
    public void execute(QueueableContext context) {
        
        List<Account> acct = [SELECT Id, Name,
                             (SELECT Id, FirstName, LastName FROM Contacts) 
                              FROM Account 
                              WHERE BillingState = :estado 
                              LIMIT 200];
        
        List<Contact> c = new List<Contact>();
        
        for (Account acc: acct){
            Contact con = contacto.clone(false,false,false,false);
            con.AccountId = acc.Id;
            c.add(con);
        }
        
        if(c.size() > 0){
            insert c;
        }
        
    }
}