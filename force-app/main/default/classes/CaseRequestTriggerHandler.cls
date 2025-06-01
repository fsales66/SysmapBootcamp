public with sharing class CaseRequestTriggerHandler {
  // Método que cria registros do objeto Case_History
  public static void createCaseHistory(
    List<Case_Request__c> crListNew,
    List<Case_Request__c> crListOld
  ) {
    List<Case_History__c> caseHistories = new List<Case_History__c>();

    // Mapeia a lista antiga (Trigger.old) por Id para facilitar comparação
    Map<Id, Case_Request__c> oldCaseMap = new Map<Id, Case_Request__c>();
    for (Case_Request__c oldCr : crListOld) {
      oldCaseMap.put(oldCr.Id, oldCr);
    }

    for (Case_Request__c newCr : crListNew) {
      Case_Request__c oldCr = oldCaseMap.get(newCr.Id);

      // Verifica se o Status foi alterado de diferente de Closed para Closed
      if (oldCr.Status__c != 'Closed' && newCr.Status__c == 'Closed') {
        datetime dateTimeAtual = datetime.now();

        Case_History__c ch = new Case_History__c(
          Case__c = newCr.Id,
          Time_Closed__c = dateTimeAtual
        );

        // Se o caso tiver sido fechado dentro da Deadline, SLA Met é verdadeiro
        if (newCr.SLA_Deadline__c >= dateTimeAtual) {
          ch.SLA_Met__c = true;
        }

        caseHistories.add(ch);
      }
    }

    if (!caseHistories.isEmpty()) {
      insert caseHistories;
    }
  }
}
