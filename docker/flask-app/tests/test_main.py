import unittest
from main import app

class FlaskAppTestCase(unittest.TestCase):

    def setUp(self):
        # Create a test client
        self.app = app.test_client()
        self.app.testing = True

    def test_hello_route(self):
        # Send a GET request to the '/' route
        response = self.app.get('/')

        # Assert that the status code is 200 (OK)
        self.assertEqual(response.status_code, 200)

        # Assert that the response data is 'Hello, World!'
        self.assertEqual(response.data.decode('utf-8'), 'Hello, World!')

if __name__ == '__main__':
    unittest.main()