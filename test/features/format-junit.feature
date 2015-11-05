Feature: jUnit / SureFire format

  In order to be able to use the tool with many popular CI tools
  As a developer
  I want to be able to have output formatted as jUnit-style XML reports

  Scenario: List available core formats
    Given I have installed the tool
     When I run it on the command line with the list-formats option
     Then JUnit should be included in the listed formats

  Scenario: Use JUnit format on clean files
    Given I have installed the tool
     When I run it on the command line with the JUnit format on clean files
     Then I should get a 0 exit code
     And the generated files should be valid XML
     And the JUnit files should have the correct structure
     And the JUnit files should have 0 errors
     And the JUnit files should have 0 warnings

  Scenario: Use JUnit format on error files
    Given I have installed the tool
     When I run it on the command line with the JUnit format on error files
     Then I should get a 1 exit code
     And the generated files should be valid XML
     And the JUnit files should have the correct structure
     And the JUnit files should have 3 errors
     And the JUnit files should have 0 warnings

