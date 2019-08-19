import os
import sys
import logging
import boto3
import urllib
import traceback
import time
import json
import gzip
import datetime

from botocore.exceptions import ClientError
from io import BytesIO, StringIO
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
from datetime import datetime
from botocore.vendored import requests

DOWNLOADED_SNAPSHOT_FILE_NAME = "/tmp/configsnapshot" + \
                                str(time.time()) + ".json.gz"

ignore_resources = ["AWS::Config::ResourceCompliance", "AWS::IAM::Policy", "AWS::SSM::AssociationCompliance", "AWS::SSM::ManagedInstanceInventory"]

def getObject(bucket_name, object_name):

    # Retrieve the object
    s3 = boto3.client('s3')
    s3conn = boto3.resource('s3',region_name=os.environ['AWS_REGION'])
    
    try:
         s3conn.meta.client.download_file(bucket_name,object_name,DOWNLOADED_SNAPSHOT_FILE_NAME)
    except ClientError as e:
        # AllAccessDisabled error == bucket or object not found
        logging.error(e)
        return None
    # Return an open StreamingBody object
    return DOWNLOADED_SNAPSHOT_FILE_NAME

def loadIntoES(jsonPayLoadFile):
    data = None
    with gzip.open(jsonPayLoadFile, 'r') as dataFile:
        try:
            data = json.load(dataFile)
        except Exception:
            pass
        
    if data is not None:
        try:
            session = boto3.Session()
            credentials = session.get_credentials()
            region = os.environ['AWS_REGION']
            awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, 'es', session_token=credentials.token)
            indexNamePreFix = os.environ['INDEX_PREFIX']
            
            # Connect to the Elasticsearch server
            es = Elasticsearch(hosts=[{'host': os.environ['ES_HOST'], 'port': 443}],http_auth=awsauth,
                use_ssl=True,verify_certs=True, connection_class=RequestsHttpConnection )
            # Load Payload in ES
            for record in data["configurationItems"]:
                print(record.get("resourceType"))
                indexname = record.get("resourceType").replace("::","-")
                typename = record.get("awsRegion").lower()
                recordJson = json.dumps(record)
                #indexName = indexNamePreFix + datetime.now().strftime("%Y-%m-%d")
                # create an index in elasticsearch, ignore status code 400 (index already exists)
                #res = es.index(index=indexName, doc_type='record', id=record["relationships"]["resourceType"], body=recordJson)
                if record["resourceType"] not in ignore_resources:
                    res = es.index(index=indexname.lower(), doc_type=typename, body=recordJson)
        except ClientError as e:
            logging.error(e)
            return None
    return res
        

def lambda_handler(event, context):
    
    # Extract s3 bucket name and key
    s3_bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    s3_bucket_key = event["Records"][0]["s3"]["object"]["key"]
    
    # Set up logging
    logging.basicConfig(level=logging.DEBUG,format='%(levelname)s: %(asctime)s: %(message)s')
    logger = logging.getLogger()
    
    # Retrieve the object
    dwonloadedSnapshotFileName = getObject(s3_bucket_name, s3_bucket_key)
    
    # ES Load
    response = loadIntoES(dwonloadedSnapshotFileName)
    
    logger.info(response)