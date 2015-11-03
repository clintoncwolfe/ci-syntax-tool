Feature: Pluggable formatters

  In order to be able to check YAML files for errors
  As a developer
  I want to be able to run the tool on yaml files

  Scenario: Use YAML explicitly on clean files
    Given I have installed the tool
     When I run it on the command line specifying the YAML language and clean files
     Then I should get a 0 exit code
     And the output should show only files for YAML
     And the output should have 0 warnings
     And the output should have 0 errors


  Scenario: Run all lamnguages on clean files
    Given I have installed the tool
     When I run it on the command line specifying all languages and clean files
     Then I should get a 0 exit code
     And the output should include files for YAML
     And the output should have 0 warnings
     And the output should have 0 errors


  Scenario: Use YAML explicitly on error files
    Given I have installed the tool
     When I run it on the command line specifying the YAML language and error files
     Then I should get a 1 exit code
     And the output should show only files for YAML
     And the output should have 0 warnings
     And the output should have 3 errors



