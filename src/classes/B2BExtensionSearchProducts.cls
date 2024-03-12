/**
 * Created by mattia.pettenati on 17/01/2024.
 */

// This class extends Commerce_Endpoint_Search_Products
public without sharing class B2BExtensionSearchProducts extends ConnectApi.BaseEndpointExtension {

    public override ConnectApi.EndpointExtensionRequest beforeGet(ConnectApi.EndpointExtensionRequest request) {
        System.debug('1.0\n' + request.getKeys());
        System.debug('1.1\n' + request.getParam('categoryId'));
        //System.debug('1.2\n' + request.getParam('fields')); FIXME  this throws the exception FATAL_ERROR|System.UnexpectedException: Salesforce System Error: 430674140-11260 (1756198237) (1756198237)
        System.debug('1.3\n' + request.getParam('includeQuantityRule'));
        System.debug('1.4\n' + request.getParam('page'));
        //request.setParam('fields', new List<String>{'Weight__c'}); FIXME  this throws the exception FATAL_ERROR|System.UnexpectedException: Salesforce System Error: 120490577-12779 (1389016374) (1389016374)
        return request;
    }

    public override ConnectApi.EndpointExtensionResponse afterGet(ConnectApi.EndpointExtensionResponse response, ConnectApi.EndpointExtensionRequest request) {
        System.debug('2.0\n' + request.getKeys());
        System.debug('2.1\n' + request.getParam('categoryId'));
        //System.debug('2.2\n' + request.getParam('fields')); FIXME  this throws the exception FATAL_ERROR|System.UnexpectedException: Salesforce System Error: 120371138-12117 (-2051602154) (-2051602154)
        System.debug('2.3\n' + request.getParam('includeQuantityRule'));
        System.debug('2.4\n' + request.getParam('page'));
        ConnectApi.CommerceProductSearchResults productSearchResults = (ConnectApi.CommerceProductSearchResults) response.getResponseObject();
        ConnectApi.CommerceProductSummaryPage commerceProductSummaryPage = productSearchResults.productsPage;
        System.debug('2.5\n' + JSON.serializePretty(commerceProductSummaryPage.products));
        Set<Id> productIds = new Set<Id>();
        for (ConnectApi.CommerceProductSummary commerceProductSummary : commerceProductSummaryPage.products) {
            productIds.add(commerceProductSummary.id);
        }
        Map<Id, Product2> productsByIds = new Map<Id, Product2>([SELECT Id, Name, Description FROM Product2 WHERE Id IN :productIds]);
        for (Integer i = 0; i < commerceProductSummaryPage.products.size(); i++) {
            Map<String, ConnectApi.FieldValue> fieldsByNames = commerceProductSummaryPage.products[i].fields;
            //ConnectApi.FieldValue fieldValue = new ConnectApi.FieldValue(); FIXME FATAL_ERROR|System.UnsupportedOperationException: ConnectApi.FieldValue cannot be constructed directly outside of a test
            ConnectApi.FieldValue fieldValue = (ConnectApi.FieldValue) fieldsByNames.get('Name').clone();
            //fieldValue.value = productsByIds.get(commerceProductSummaryPage.products[i].id).Description; FIXME this throws the exception FATAL_ERROR|System.UnsupportedOperationException: Output properties may only be written in objects built for tests
            fieldsByNames.put('Description', fieldValue);
        }
        return response;
    }
}