@RestResource(urlMapping='/Case_Request__c/*')
global with sharing class CaseRequestManager {
  //Anotação Get define que nosso método irá Ler/recuperar registro
  @HttpGet
  global static Case_Request__c getCaseRequestById() {
    //Definições do request e response
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    //String que irá receber o parametro de Id passado pelo request externo
    String caseRequestId = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );

    //Bloco try-catch para pegar exception relacionada a SOQL
    try {
      if (!String.isBlank(caseRequestId)) {
        Case_Request__c result = [
          SELECT Id, Status__c, (SELECT Id, SLA_Met__c FROM Case_Histories__r)
          FROM Case_Request__c
          WHERE Id = :caseRequestId
          LIMIT 1
        ];

        {
          // Caso o Id tenha sido passado e exista na Org, retornamos statusCode 200 e o registro
          //200 = OK
          response.statusCode = 200;
          return result;
        }
      } else {
        // Caso o Id esteja vazio retornamos null com o statusCode 400
        //400 = BAD_REQUEST
        response.statusCode = 400;
        return null;
      }
    }
    // Caso o Id esteja incorreto ou tenhamos um problema na consulta SOQL retornamos null com o statusCode 400
    //400 = BAD_REQUEST
    catch (Exception e) {
      response.statusCode = 400;
    }
    return null;
  }
}
