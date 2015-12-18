Feature: Python Language support

  In order to be able to check Python files for errors
  As a developer
  I want to be able to run the tool on yaml files

  Scenario: Use Python explicitly on clean files
    Given I have installed the tool
     When I run it on the command line specifying the Python language and clean files
     Then I should get a 0 exit code
     And the output should show only files for Python
     And the output should have 0 warnings
     And the output should have 0 errors


  Scenario: Run all lamnguages on clean files
    Given I have installed the tool
     When I run it on the command line specifying all languages and clean files
     Then I should get a 0 exit code
     And the output should include files for Python
     And the output should have 0 warnings
     And the output should have 0 errors


  Scenario: Use Python explicitly on error files
    Given I have installed the tool
     When I run it on the command line specifying the Python language and error files
     Then I should get a 1 exit code
     And the output should show only files for Python
     And the output should have 0 warnings
     And the output should have 3 errors



