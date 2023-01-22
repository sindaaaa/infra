import boto3
import os

client = boto3.client(
    's3',
    aws_access_key_id="AWS_ACCES_KEY",
    aws_secret_access_key="AWS_SECRET_ACCES_KEY"
)

bucket_name = 'cbdprojectjoinbucket'
file_path = 'join.sh'

# Upload the file to the S3 bucket
client.upload_file(file_path, bucket_name, file_path)
