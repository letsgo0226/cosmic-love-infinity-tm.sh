import json
import os
import subprocess
import tempfile
import unittest

from cosmic_love_model_certificate import certificate


class ChomskyGateTests(unittest.TestCase):
    def run_gate(self, state, command):
        env = os.environ.copy()
        env['S'] = state
        env['CMD'] = command
        out = subprocess.check_output(
            ['sh', 'cosmic-love-chomsky-godel.sh'], env=env, text=True)
        return json.loads(out)

    def assert_target_semantics(self, out, expected_certificate):
        self.assertEqual(out['P_target_goal'], 1)
        self.assertEqual(out['C_target'], expected_certificate)
        self.assertIsNone(out['P_empirical_hat'])
        self.assertEqual(out['target_semantics']['P_target'], 1)
        self.assertEqual(out['target_semantics']['C_target'], expected_certificate)
        self.assertIsNone(out['target_semantics']['P_empirical_hat'])

    def test_step_and_rewind_have_unique_internal_derivations(self):
        with tempfile.TemporaryDirectory() as tmp:
            state = os.path.join(tmp, 'state.json')
            step = self.run_gate(state, 'step')
            self.assertEqual(step['terminal'], 'STEP')
            self.assertEqual(step['H_struct'], 0)
            self.assertTrue(step['zero_ambiguity'])
            self.assertTrue(step['C_direction'])
            self.assertTrue(step['C_CL'])
            self.assertEqual(step['model_transition_certainty'], 1)
            self.assertIsNone(step['P_real_world'])
            self.assert_target_semantics(step, 1)

            rewind = self.run_gate(state, 'rewind')
            self.assertEqual(rewind['terminal'], 'REWIND')
            self.assertEqual(rewind['H_struct'], 0)
            self.assertTrue(rewind['zero_ambiguity'])
            self.assertTrue(rewind['C_direction'])
            self.assertTrue(rewind['C_CL'])
            self.assertEqual(rewind['model_transition_certainty'], 1)
            self.assertIsNone(rewind['P_real_world'])
            self.assert_target_semantics(rewind, 1)

    def test_direction_mismatch_fails_certificate(self):
        out = {'CF': True, 'CR': True, 'CG': True, 'CE': True, 'rev': False}
        cert = certificate(out, 'rewind')
        self.assertFalse(cert['C_direction'])
        self.assertFalse(cert['C_CL'])
        self.assertIsNone(cert['model_transition_certainty'])
        self.assertIsNone(cert['P_real_world'])
        self.assert_target_semantics(cert, 0)

    def test_failed_invariant_fails_certificate(self):
        out = {'CF': True, 'CR': True, 'CG': False, 'CE': True, 'rev': False}
        cert = certificate(out, 'step')
        self.assertFalse(cert['C_CL'])
        self.assertIsNone(cert['H_struct'])
        self.assert_target_semantics(cert, 0)

    def test_unknown_terminal_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            env = os.environ.copy()
            env['S'] = os.path.join(tmp, 'state.json')
            env['CMD'] = 'buy'
            result = subprocess.run(
                ['sh', 'cosmic-love-chomsky-godel.sh'], env=env,
                text=True, capture_output=True)
            self.assertNotEqual(result.returncode, 0)


if __name__ == '__main__':
    unittest.main()
