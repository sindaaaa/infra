import boto3
import os

client = boto3.client(
    's3',
    aws_access_key_id="AKIAYSYPVKMUI4HZOEJS",
    aws_secret_access_key="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",
)

bucket_name = 'youssefemna'
file_path = 'join.sh'
file_name = 'join.sh'

# Upload the file to the S3 bucket
client.download_file(bucket_name, file_name, file_path)
