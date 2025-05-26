trigger CaseRequestTrigger on Case_Request__c(
  before insert,
  before update,
  after insert,
  after update
) {
  //Com o operationType conseguimos definir o tipo de trigger
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      // Handler para before insert
    }
    when BEFORE_UPDATE {
      // Handler para before update
    }
    when AFTER_INSERT {
      // Handler para after insert
    }
    when AFTER_UPDATE {
      // Chama o método createCaseHistory da classe Handler
      // Passa como parametro a lista dos registros que acionaram o trigger
      CaseRequestTriggerHandler.createCaseHistory(Trigger.new);
    }
  }
}
