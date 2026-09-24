import json
import os
import subprocess
import tempfile
import unittest


class ChomskyGateTests(unittest.TestCase):
    def run_gate(self, state, command):
        env = os.environ.copy()
        env['S'] = state
        env['CMD'] = command
        out = subprocess.check_output(
            ['sh', 'cosmic-love-chomsky-godel.sh'], env=env, text=True)
        return json.loads(out)

    def test_step_and_rewind_have_unique_internal_derivations(self):
        with tempfile.TemporaryDirectory() as tmp:
            state = os.path.join(tmp, 'state.json')
            step = self.run_gate(state, 'step')
            self.assertEqual(step['terminal'], 'STEP')
            self.assertEqual(step['H_struct'], 0)
            self.assertTrue(step['zero_ambiguity'])
            rewind = self.run_gate(state, 'rewind')
            self.assertEqual(rewind['terminal'], 'REWIND')
            self.assertEqual(rewind['H_struct'], 0)
            self.assertTrue(rewind['zero_ambiguity'])

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
