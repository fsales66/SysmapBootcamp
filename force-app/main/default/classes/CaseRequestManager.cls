@RestResource(urlMapping='/Case_Request__c/*')
global with sharing class CaseRequestManager {
  @HttpGet
  global static Case_Request__c getCaseRequestById() {
    RestRequest request = RestContext.request;

    String caseRequestId = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );

    Case_Request__c result = [
      SELECT Id, Status__c, (SELECT Id, SLA_Met__c FROM Case_Histories__r)
      FROM Case_Request__c
      WHERE Id = :caseRequestId
    ];

    return result;
  }
}
