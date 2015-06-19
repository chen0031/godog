Feature: run features
  In order to test application behavior
  As a test suite
  I need to be able to run features

  Scenario: should run a normal feature
    Given a feature "normal.feature" file:
      """
      Feature: normal feature

        Scenario: parse a scenario
          Given a feature path "features/load.feature:6"
          When I parse features
          Then I should have 1 scenario registered
      """
    When I run feature suite
    Then the suite should have passed
    And the following steps should be passed:
      """
      a feature path "features/load.feature:6"
      I parse features
      I should have 1 scenario registered
      """

  Scenario: should skip steps after failure
    Given a feature "failed.feature" file:
      """
      Feature: failed feature

        Scenario: parse a scenario
          Given a failing step
          When I parse features
          Then I should have 1 scenario registered
      """
    When I run feature suite
    Then the suite should have failed
    And the following step should be failed:
      """
      a failing step
      """
    And the following steps should be skipped:
      """
      I parse features
      I should have 1 scenario registered
      """

  Scenario: should skip all scenarios if background fails
    Given a feature "failed.feature" file:
      """
      Feature: failed feature

        Background:
          Given a failing step

        Scenario: parse a scenario
          Given a feature path "features/load.feature:6"
          When I parse features
          Then I should have 1 scenario registered
      """
    When I run feature suite
    Then the suite should have failed
    And the following step should be failed:
      """
      a failing step
      """
    And the following steps should be skipped:
      """
      a feature path "features/load.feature:6"
      I parse features
      I should have 1 scenario registered
      """

  Scenario: should skip steps after undefined
    Given a feature "undefined.feature" file:
      """
      Feature: undefined feature

        Scenario: parse a scenario
          Given a feature path "features/load.feature:6"
          When undefined action
          Then I should have 1 scenario registered
      """
    When I run feature suite
    Then the suite should have passed           # we do not treat undefined scenarios as fails
    And the following step should be passed:
      """
      a feature path "features/load.feature:6"
      """
    And the following step should be undefined:
      """
      undefined action
      """
    And the following step should be skipped:
      """
      I should have 1 scenario registered
      """
