# Instructions for sf-platform

This is a monorepo for multiple unlocked Salesforce packages.

The code inside the src folder is written in apex and lightning web components

Do not use SFDX CLI commands only SF CLI commands, SFDX CLI is deprecated.

Prettier is used for styling and our prettier settings are described in .prettierrc

Code can be found in the src and src-temp folders

When writing test always include System.Test.startTest(); and System.Test.stopTest();. First we prepare the data. The actual test should be placed in side start and stop test. Then we confirm the test results with asserts.

We use github actions and out action and workflow files can be found in .github

Tests are defined by the @IsTest annotation.

When writing tests, the class we're testing often has the same filename as the test class except "Test"

When assisting with code, use the sources listed below:

- Apex developer guide: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dev_guide.htm
- Apex reference guide: https://developer.salesforce.com/docs/atlas.en-us.254.0.apexref.meta/apexref/apex_ref_guide.htm
- Salesforce web component library: https://developer.salesforce.com/docs/component-library/overview
- Lightning web component developer guide: https://developer.salesforce.com/docs/platform/lwc/guide
- Salesforce CLI Command reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_top.htm
- sfp CLI: https://docs.flxbl.io/flxbl/sfp
