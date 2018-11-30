#!/usr/bin/python
import pprint
import duo_client
import random
import string
# ikey, skey, and api-hostname
admin_api = duo_client.Admin("ikey", "skey", "domain.duosecurity.com")


password=''.join(random.SystemRandom().choice(string.ascii_uppercase +string.ascii_lowercase+ string.digits) for _ in range(16))
parameters = {"email": "email","name": "Full Name","phone": "Phone Number","role": "Role","password":password}
url = admin_api.json_api_call("POST", "/admin/v1/admins", parameters)
pprint.pprint(url)
