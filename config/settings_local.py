# -*- coding: utf-8 -*-

DEBUG = True
API_DEBUG = DEBUG
TEMPLATE_DEBUG = DEBUG

#SCTP_PORT = 56789
SCTP_HOST = 'localhost' # 'ims.ostis.net'

REPO_EDIT_TIMEOUT = 60 # seconds

#DATABASES = {
#    'default': {
#        'ENGINE': 'django.db.backends.sqlite3',
#        'NAME': 'data.db',
#        'USER': '',
#        'PASSWORD': '',
#        'HOST': '',
#        'PORT': '',
#    }
#}

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'sc_web',
        'USER': 'root',
        'PASSWORD': 'root',
        'HOST': '',
        'PORT': '',
    }
}

SITE_URL = 'http://localhost:8000'


