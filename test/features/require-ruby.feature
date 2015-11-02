Feature: Load extra Ruby files

  In order to be able to use the tool with custom plugins
  As a developer
  I want to be able to load additional ruby files

  Scenario: Load a valid ruby file
    Given I have installed the tool
     When I run it on the command line with the require option and a valid ruby file
     Then the valid ruby file should have been loaded
     And I should get a 0 exit code

  Scenario: Reject a missing file with a nice message
    Given I have installed the tool
     When I run it on the command line with the require option and a missing ruby file
     Then I should get an error message about the missing require file
     And I should get a 5 exit code

  Scenario: Reject an invalid file with a nice message
    Given I have installed the tool
     When I run it on the command line with the require option and a invalid ruby file
     Then I should get an error message about the invalid require file
     And I should get a 5 exit code

Scenario: Reject an invalid file with a stacktrace when debug flag is present
    Given I have installed the tool
     When I run it on the command line with the require option and the debug option and a invalid ruby file
     Then I should get a stack trace about the invalid require file
     And I should get a 5 exit code

  Scenario: Accept multiple requires
    Given I have installed the tool
     When I run it on the command line with two requires
     Then the first ruby file should have been loaded
     And the second ruby file should have been loaded      
     And I should get a 0 exit code


