from botocore.exceptions import ClientError
from appconfig_helper import AppConfigHelper
from fastapi import FastAPI, status
import logging
import os

# Set AWS Region
os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'

# Instantiate logger
logger = logging.basicConfig(
    filename='/usr/src/app/api.log',
    format='[%(asctime)s] %(levelname)s %(name)s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S'
    )

# Fetch configuration from AWS AppConfig
appconfig = AppConfigHelper(
    "POC-Application", #Application
    "POC-DEV", #Environment
    "UpdateAttribute", #Configuration Profile
    45  # Minimum interval between update checks (in seconds)
)

app = FastAPI()

@app.get("/")
async def root():
    api_json_list = [
        {
            'Name': 'Stairway to Heaven - Led Zeppelin'
        },
        {
            'Name': 'Bohemian Rhapsody - Queen'
        },
        {
            'Name': 'Hey Jude - Beatles'
        },
        {
            'Name': 'All Along the Watchtower -  Jimi Hendrix'
        },
        {
            'Name': 'Satisfaction - Rolling Stones'
        },
        {
            'Name': 'Come As You Are - Nirvana'
        },
        {
            'Name': 'Boulevard of Broken Dreams - Green Day'
        },
        {
            'Name': 'Sweet Child O Mine - Guns N Roses'
        },
        {
            'Name': 'One - Metallica'
        },
        {
            'Name': 'Back In Black - AC/DC'
        }
    ]
    
    try:
        # Log when new configuration is received:
        if appconfig.update_config():
            logging.info("New configuration Received")
        
        # If limiting is enabled, return limited json list:
        if appconfig.config.get("EnableLimit", True):
            limit = appconfig.config["ResultLimit"]
            if limit > (len(api_json_list)):
                error_message = "Index out of range, max allow: {}".format((len(api_json_list)))
                logging.error(error_message)
                return {
                        'statusCode': 400,
                        'response_from': 'ECS',
                        'body': error_message
                        }
            else:
                try:
                    new_json = slice(limit)
                    return {
                        'statusCode': 200,
                        'response_from': 'ECS',
                        'body': api_json_list[new_json]
                        }
                except Exception as error:
                    logging.error(error)
        
        # If limiting not enabled, return full json list:
        else:
            return {
                'statusCode': 200,
                'response_from': 'ECS',
                'body': api_json_list
                }

    #If Boto3 Client Error: Keep the server running, log the error and return the error message.
    except ClientError as error:
        logging.error(error)
        return {
            'statusCode': 500,
            'response_from': 'ECS',
            'body': error
            }

@app.get('/status', status_code=status.HTTP_200_OK)
async def perform_healthcheck():
        return {
            'statusCode': 200,
            'response_from': 'ECS',
            'healthcheck': 'WSGI OK!'
        }