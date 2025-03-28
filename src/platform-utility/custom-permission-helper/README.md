# custom-permission-helper

Denne pakken inneholder en hjelpeklasse for å håndtere custom permissions.

Salesforce har fra før metoden `FeatureManagement.checkPermission` som kan sjekke dette, men den er begrenset til å kun kjøre for running user og kan heller ikke mockes/stubbes. Denne har også muligheten til å verifisere om en custom setting eksisterer (eller om du skriver inn feil navn).

Hjelpeklassen her er tiltenkt å brukes når:

- Sjekke flere custom permissions.
- Sjekke custom permissions i en test kontekts
- Sjelle custom permissions for andre enn kjørende bruker.

## Hvordan ta i bruk

I utgangspunktet så er det bare å kalle på klassen og starte å bruke public metodene. En ting å være klar over er at man må kalle på `setCustomPermissionsMaps()` dersom man skal benytte seg av en del av metodene. Om ikke vil det kastes en exception.

### Eksempler

#### Sjekke en custom permissison

```java
// Check if running user has the custom permission
new CustomPermissionHelper().hasCustomPermission('MyPermission');
```

#### Sjekke en custom permissison for en annen bruker

```java
new CustomPermissionHelper()
    .setCustomPermissionMaps() // Load all custom permissions
    .validateCustomPermission('MyPermission') // Validate that the custom permission exists
    .hasCustomPermission(userId, 'MyPermission'); // Check if the user has the custom permission
```

#### Få liste over _mine_ custom permissions

```java
CustomPermissionHelper().setCustomPermissionMaps().;
```

### Bruke stub klassen i testing

Stub klassen implementerer `System.StubProvider` og kan brukes til å mocke responsen fra `CustomPermissionHelper`.

I stub klassen kan man på forhånd sette verdiene sånn at man enkelt kan kjøre testene.

Resultatene legges inn i en liste, noe som muliggjør at man kan lage en mock som returnerer ulike verdier iløpet av en kjøring.

```java
CustomPermissionHelperStub stub = new CustomPermissionHelperStub();
stub.addHasCustomPermission(true);
CustomPermissionHelper customPermissionHelper = stub.getMock();

System.Assert.isTrue(customPermissionHelper.hasCustomPermission('MyPermission'));
```

Alternativt hvor man ønsker flere ulike responser etter hverandre:

```java
CustomPermissionHelper customPermissionHelper = new CustomPermissionHelperStub()
                                                    .addHasCustomPermission(true)
                                                    .addHasCustomPermission(false)
                                                    .addHasCustomPermission(true)
                                                    .getMock();

System.Assert.isTrue(customPermissionHelper.hasCustomPermission('MyPermission'));
System.Assert.isFalse(customPermissionHelper.hasCustomPermission('MyPermission'));
System.Assert.isTrue(customPermissionHelper.hasCustomPermission('MyPermission'));
```
