trigger CaseRequestTrigger on Case_Request__c(after update) {
  // Chama o método createCaseHistory da classe Handler
  // Passa como parametro a lista dos registros que acionaram o trigger
  CaseRequestTriggerHandler.createCaseHistory(Trigger.new, Trigger.old);

}
