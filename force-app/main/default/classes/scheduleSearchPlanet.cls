public with sharing class scheduleSearchPlanet implements Queueable {

    Integer count;
    String acessCode;
    String caseId;

    public scheduleSearchPlanet(String acessCodeP, Integer countP, String caseIdP){
        this.count = countP - 1;
        this.acessCode = acessCodeP;
        this.caseId = caseIdP;
    }

    public void execute(QueueableContext context)
    {
        System.debug('acessCode Quereable: ' +acessCode);
        WSSearchPlanet.searchPlanetCallOutRetries(acessCode,count,caseId);
    }
}