# API Configuration
#accesslog = '/usr/src/app/app.log'
loglevel = 'debug'
bind = '0.0.0.0:8082'
daemon = True
workers = 4
worker_class = 'uvicorn.workers.UvicornWorker'
threads = 2