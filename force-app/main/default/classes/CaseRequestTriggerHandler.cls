public with sharing class CaseRequestTriggerHandler {
  //Método que cria registros do objeto Case_History
  public static void createCaseHistory(List<Case_Request__c> crList) {
    //Criação da lista que será inserida
    List<Case_History__c> caseHistories = new List<Case_History__c>();
    for (Case_Request__c cr : crList) {
      //Se o Case Request tiver sido fechado, se cria um Case History
      if (cr.Status__c == 'Closed') {
        datetime dateTimeAtual = datetime.now();
        Case_History__c ch = new Case_History__c(
          Case__c = cr.Id,
          Time_Closed__c = dateTimeAtual
        );
        //Se o caso tiver sido fechado dentro da Deadline, SLA Met é verdadeiro
        if (cr.SLA_Deadline__c >= dateTimeAtual) {
          ch.SLA_Met__c = true;
        }

        //Add o Case History para a lista
        caseHistories.add(ch);
      }
    }

    //Se a lista tiver elementos, insere a lista
    if (!caseHistories.isEmpty()) {
      insert caseHistories;
    }
  }
}
