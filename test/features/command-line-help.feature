Feature: Command line help

  In order to be able to learn about the options available for syntax checking
  As a developer
  I want to be able to interactively get help on the options from the command line

  Scenario: No arguments
    Given I have installed the tool
     When I run it on the command line with no arguments
     Then the simple usage text should be displayed along with a non-zero exit code

  Scenario: Command help
    Given I have installed the tool
     When I run it on the command line with the help option
     Then the simple usage text should be displayed along with a zero exit code

  Scenario: Display version
    Given I have installed the tool
     When I run it on the command line with the version option
     Then the current version should be displayed
