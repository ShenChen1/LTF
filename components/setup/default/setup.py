import unittest
import os

class Test___setup___default(unittest.TestCase):
    def test_setup(self):
        self.assertEqual(0,os.system("./mksetup.sh"))

if __name__ == '__main__':
    unittest.main()