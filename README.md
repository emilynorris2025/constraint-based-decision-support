# Constraint-Based Decision Support System

## Overview

This project demonstrates how constraint programming and optimization can support complex decisions involving competing requirements, capacity limitations, stakeholder relationships, and alternative scenarios.

The project uses MiniZinc to model a fictional event-planning problem involving participant selection and seating assignments.

While the case study is a wedding scenario, the underlying framework demonstrates decision-support techniques applicable to resource
allocation, scheduling, logistics, workforce planning, and other constraint-based optimization problems.

---

## The Challenge

The system must determine an optimal seating and invitation plan across:

- 76 potential participants
- 66 available invitations
- 9 tables
- fixed table capacities
- mandatory participants
- group preferences
- interpersonal conflicts
- scenario-dependent requirements

The model must satisfy all hard constraints while maximizing the overall quality of the solution.

---

## Decision Scenarios

The model evaluates alternative scenarios through a Boolean decision variable.

The selected scenario dynamically changes:

- mandatory participants
- reserved seating
- family constraints
- optimization requirements

This allows the model to demonstrate scenario-aware decision support rather than solving a single static problem.

---

## Technical Approach

### Decision Variables

Each participant is assigned to:

- Table 1–9
- Or excluded from the event

A separate Boolean variable controls the scenario being evaluated.

### Hard Constraints

The model enforces:

- table capacity limits
- a fixed number of invited participants
- reserved seating requirements
- mandatory participant groups
- scenario-specific family constraints
- mandatory stakeholders

### Optimization Objective

The objective function balances:

**Social cohesion**

Participants from the same group receive positive value when seated together.

**Conflict avoidance**

Known incompatible pairings receive a significant penalty when assigned to the same table.

The model solves:

```text
- maximize
- social cohesion
− conflict penalties

---

## Results
The system automatically produces:

- selected scenario
- total optimization score
- conflict penalty score
- table assignments
- excluded participants

The model provides a transparent and explainable approach to solving a complex decision problem with competing priorities.

---

### Technologies

- MiniZinc
- Constraint Programming
- Optimization
- Decision Support Systems

---

### Potential Applications

The same framework could be adapted for:

- workforce scheduling
- resource allocation
- logistics planning
- supply chain optimization
- event planning
- portfolio prioritization
- stakeholder allocation

