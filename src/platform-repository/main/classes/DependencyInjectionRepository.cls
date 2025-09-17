public with sharing class DependencyInjectionRepository extends RepositoryBase {
    public String getApexClassByInterface(String interfaceName) {
        String query =
            'SELECT ApexClass__c FROM DependencyInjectionMapping__mdt WHERE Interface__c = \'' +
            interfaceName +
            '\' LIMIT 1';

        List<DependencyInjectionMapping__mdt> mappings = (List<DependencyInjectionMapping__mdt>) new CustomMetadataDAO()
            .getCustomMetadataRecords(query);

        if (mappings.isEmpty()) {
            return null;
        }

        return mappings[0].ApexClass__c;
    }
}
