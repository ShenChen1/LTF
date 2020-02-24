import unittest
import os

class Test___teardown___default(unittest.TestCase):
    def test_teardown(self):
        self.assertEqual(0,os.system("./mkteardown.sh"))

if __name__ == '__main__':
    unittest.main()