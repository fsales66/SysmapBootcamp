@isTest
public with sharing class CaseRequestManagerTest {
  //TestSetup é responsável por gerar o dado que será utilizado nos demais testes
  @TestSetup
  static void dataSetup() {
    Case_Request__c newCase = new Case_Request__c();
    newCase.Name = 'Case 1';
    newCase.Priority__c = 'Low';
    newCase.Subject__c = 'Dado teste';
    newCase.Status__c = 'Closed';
    newCase.Resolution_Notes__c = 'Dados teste';

    insert newCase;
  }

  //test1 cenário em que dá tudo certo, registro existe e o statusCode é 200 (OK)
  @isTest
  public static void test1() {
    Case_Request__c cr = [
      SELECT Id, Status__c, (SELECT Id, SLA_Met__c FROM Case_Histories__r)
      FROM Case_Request__c
      WHERE Name = 'Case 1'
    ];

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/Case_Request__c/' + cr.Id;
    req.httpMethod = 'Get';

    RestContext.request = req;
    RestContext.response = res;
    Test.startTest();
    Case_Request__c result1 = CaseRequestManager.getCaseRequestById();
    Test.stopTest();

    System.assertEquals(200, res.statusCode, 'Status Code incorreto');
    System.assertEquals(cr.Id, result1.Id, 'Id incorreto');
  }

  //test2 cenário em que o ID não retorna um registro válido, statusCode 400
  @isTest
  public static void test2() {
    String idErrado = 'a00gL000006o7hEQA0';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/Case_Request__c/' + idErrado;
    req.httpMethod = 'Get';

    RestContext.request = req;
    RestContext.response = res;
    Test.startTest();
    Case_Request__c result2 = CaseRequestManager.getCaseRequestById();
    Test.stopTest();

    System.assertEquals(400, res.statusCode, 'Status Code incorreto');
  }

  //test3 cenário em que o ID está vazio, statusCode 400
  @isTest
  public static void test3() {
    String idErrado = '';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/Case_Request__c/' + idErrado;
    req.httpMethod = 'Get';

    RestContext.request = req;
    RestContext.response = res;
    Test.startTest();
    Case_Request__c result3 = CaseRequestManager.getCaseRequestById();
    Test.stopTest();

    System.assertEquals(400, res.statusCode, 'Status Code incorreto');
  }
}
