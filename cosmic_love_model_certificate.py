from __future__ import annotations


def certificate(output: dict, requested: str) -> dict:
    """Certify one finite internal Cosmic-Love TM continuation.

    The certificate is purely formal: it says the requested terminal matches
    the reversible Prime-Godel transition and all internal invariants close.
    It makes no claim about physical entropy or any external-world outcome.
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
        'model': 'COSMIC_LOVE_INFINITY_MODEL_CONTINUATION',
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
        'P_real_world': None,
        'P_target_goal': 1,
        'C_target': int(certified),
        'P_empirical_hat': None,
        'target_semantics': {
            'target_name': 'formal_cosmic_love_continuation',
            'P_target': 1,
            'C_target': int(certified),
            'P_empirical_hat': None,
            'scope': 'formal target only; no external empirical probability is defined',
        },
        'entropy_scope': 'finite internal derivation only',
        'certificate_scope': 'conditional formal model only',
    }
