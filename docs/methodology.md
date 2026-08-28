# Methodology

## Problem Framing

The project approaches a complex allocation problem as a constraint optimization problem.

The decision-maker must determine:

* Who should participate
* Where each participant should be assigned
* How alternative scenarios affect requirements
* How to balance positive relationships with potential conflicts

The model separates the problem into hard constraints and optimization preferences.

---

## Hard Constraints

Hard constraints represent conditions that cannot be violated.

Examples include:

* Maximum table capacity
* Fixed invitation limits
* Mandatory participants
* Required stakeholder groups
* Scenario-specific requirements
* Reserved assignments

Any solution violating a hard constraint is considered not possible.

---

## Optimization Preferences

Preferences represent desirable outcomes rather than mandatory requirements.

The model assigns scores to outcomes based on factors such as:

* Group cohesion
* Relationship compatibility
* Conflict avoidance

This enables the system to compare multiple feasible solutions and identify the highest-value option.

---

## Scenario Analysis

A scenario-level decision variable allows the model to evaluate alternative high-level decisions.

Changing the scenario dynamically affects downstream constraints and participant requirements.

This demonstrates an important characteristic of decision support systems: the ability to evaluate how major decisions affect the broader system.

---

## Objective Function

The model maximizes an overall decision score.

Conceptually:

```text
Overall Decision Value =
Positive Relationship Value
− Conflict Penalties
```

The weighting framework allows high-priority risks to receive greater importance than lower-priority preferences.

---

## Decision Output

The model produces a structured recommendation that can include:

* Selected scenario
* Participant assignments
* Excluded participants
* Optimization score
* Conflict penalties
* Constraint-compliant allocation

The resulting output provides both a recommendation and a transparent explanation of the underlying decision logic.
