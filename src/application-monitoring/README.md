# application-monitoring

## Application Log

This package contains an application logging framework that can be used for logging various events either på utilizing the _LoggerUtility_ apex class, or by generating _Application_Log\_\_c_ records via process builder, flow, workflow etc. The logger has four log levels: (Error, Warning, Info, Critical). It is highly recommended to also pass a _CRM_ApplicationDomain.Domain_ parameter, which defines which area of the application is both creating the log entry and is responsible for follow up. Calling the respective logger methods can be done as shown:

```Apex
LoggerUtility logger = new LoggerUtility();
logger.Info('Message', SObjectRef, domain);
logger.Warning('Message', SObjectRef, domain);
logger.Error('Message', SObjectRef, domain);
logger.Critical('Message', SObjectRef, domain);

logger.Exception(ex, domain) //Used for logging catched exceptions
logger.publish();
```

The logger framework automatically adds the stacktrace, source function and source class to the log record when creating a log entry. To allow for application logging while also rolling back a transaction the framework includes also an _Application_Event\_\_e_ platform event counterpart that can be published even when rolling back transactions, _the standard publish() will generate a platform event_. Each log entry generates an unique UUID at runtime that can be handy for i.e. callouts requiring unique callout references in the callout chain. This examples returns the UUID of the last logged event:
`logger.peek().UUID__c`

The data model is available in [platform-data-model](src/platform-data-model/README.md).

|         |     |
| ------- | --- |
| Apex    | ✅  |
| LWC     | ✅  |
| Flow    | ✅  |
| Trigger | ✅  |

````

## Dependencies

- [platform-datamodel](src/platform-data-model/feature-flag-custom-metadata) - data model

```mermaid
---
title: Package dependencies
---
graph TD
    application-monitoring --> platform-datamodel;
````
