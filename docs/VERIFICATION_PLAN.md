# Verification plan

For each function, verify:

1. **Nominal behaviour:** representative values produce expected outputs.
2. **Boundary behaviour:** minimum, maximum, zero, and saturation conditions.
3. **Invalid inputs:** NaN, Inf, out-of-range signals, inconsistent limits, and missing struct fields are rejected.
4. **Numerical behaviour:** outputs remain finite over the intended operating envelope.
5. **Regression:** rerun the complete test suite after every functional change.

## Suggested next-level verification
- Add requirement IDs and traceability from requirement to test.
- Add parameter sweeps and boundary-value tests.
- Compare MATLAB outputs against an independently calculated reference.
- Add MIL/SIL equivalence tests after a Simulink implementation exists.
- For HIL, define signal scaling, sample times, latency budgets, fault injection, and safe test limits.

Passing these unit tests does not establish vehicle safety or production readiness.
