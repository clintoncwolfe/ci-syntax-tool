Feature: Pluggable formatters

  In order to be able to use the tool with whatever CI engine I need
  As a developer
  I want to be able to output the results of language checks in various formats

  Scenario: List available core formats
    Given I have installed the tool
     When I run it on the command line with the list-formats option
     Then I should get a list of the core formats along with a zero exit code

  Scenario: Reject an invalid format
    Given I have installed the tool
     When I run it on the command line with the format option and the argument foo
     Then I should get an error message and the exit code 4

  Scenario: Reject multiple formats without destination
    Given I have installed the tool
     When I run it on the command line with two format options and 0 destinations
     Then I should get an error message and the exit code 4

  Scenario: Reject multiple formats with ambiguous destination count
    Given I have installed the tool
     When I run it on the command line with two format options and 1 destinations
     Then I should get an error message and the exit code 4

  Scenario: Use multiple formatters with corrrect nnumber of destinations
    Given I have installed the tool
     When I run it on the command line with two format options and 2 destinations
     Then I should get a 0 exit code


