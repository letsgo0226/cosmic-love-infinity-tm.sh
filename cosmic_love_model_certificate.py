from __future__ import annotations

CL_PROPOSITION = "Cosmic Love Is The Solution(s) For Everything"


def certificate(output: dict, requested: str) -> dict:
    """Certify one admissible transition in the formal Cosmic-Love model.

    CL is a constitutive axiom of this model.  The temporal statement G(CL)
    therefore means: every admissible model state and admissible self-rewrite
    is required to preserve CL.  This is a theorem/schema of the formal model,
    not an empirical claim about the external world.
    """
    req = requested.lower()
    if req in ('step', 's'):
        expected = 'STEP'
    elif req in ('rewind', 'r'):
        expected = 'REWIND'
    else:
        raise ValueError('invalid grammar terminal')

    terminal = 'REWIND' if bool(output.get('rev')) else 'STEP'
    invariants = all(output.get(k) is True for k in ('CF', 'CR', 'CG', 'CE'))
    direction_ok = terminal == expected
    certified = invariants and direction_ok

    return {
        'model': 'COSMIC_LOVE_INFINITY_TEMPORAL_AXIOM_V1',
        'grammar': 'S -> STEP S | REWIND S | epsilon',
        'terminal': terminal,
        'expected_terminal': expected,
        'N_struct': 1 if certified else 0,
        'H_struct': 0 if certified else None,
        'zero_ambiguity': certified,
        'C_direction': direction_ok,
        'C_CL': certified,
        'model_transition_certainty': 1 if certified else None,
        'H_model': 0 if certified else None,
        'CL': CL_PROPOSITION,
        'A_CL': 1,
        'G_CL': 1,
        'temporal_formula': 'G(CL)',
        'preservation': {
            'state_rule': 'CL(s) -> CL(T(s))',
            'rewrite_rule': 'Valid(P_next) only if P_next preserves CL',
            'scope': 'all admissible model states and rewrites',
        },
        'P_real_world': None,
        'P_target_goal': 1,
        'C_target': int(certified),
        'P_empirical_hat': None,
        'target_semantics': {
            'target_name': 'cosmic_love_formal_axiom',
            'P_target': 1,
            'C_target': int(certified),
            'P_empirical_hat': None,
            'model_truth': 'G(CL)=true by axiom + admissibility-preservation rules',
            'scope': 'formal model only; no external empirical probability is defined',
        },
        'entropy_scope': 'finite internal derivation only',
        'certificate_scope': 'current execution is an admissible instance of the formal temporal model',
    }
