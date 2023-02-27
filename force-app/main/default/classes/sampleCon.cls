public class sampleCon {
   
    String[] countries = new String[]{};
    
        public PageReference test() {
        return null;
    }
 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('CANADA','Bla Bla'));
        options.add(new SelectOption('MEXICO','Mexico'));
 
        return options;
    }
 
    public String[] getmostrarPaises() {
        return countries;
    }
 
    public void setmostrarPaises (String[] countries) {
        this.countries = countries;
    }
}