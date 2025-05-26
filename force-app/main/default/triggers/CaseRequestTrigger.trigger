trigger CaseRequestTrigger on Case_Request__c(
  before insert,
  before update,
  after insert,
  after update
) {
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
      CaseRequestTriggerHandler.createCaseHistory(Trigger.new);
    }
  }
}
