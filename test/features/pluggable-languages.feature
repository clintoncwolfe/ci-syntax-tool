Feature: Pluggable languages

  In order to be able to use the tool on whatever language I need
  As a developer
  I want to be able to extend the tool by adding support for new languages

  Scenario: List available core languages
    Given I have installed the tool
     When I run it on the command line with the list-languages option
     Then I should get a list of the core languages along with a zero exit code

  Scenario: Reject an invalid language
    Given I have installed the tool
     When I run it on the command line with the lang option and the argument foo
     Then I should get an error message and the exit code 3
