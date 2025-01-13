import logging
import os

import boto3
from botocore.exceptions import ClientError, NoCredentialsError
from dotenv import load_dotenv


class S3Manager:
    def __init__(self):
        # Load environment variables from .env file
        load_dotenv()

        # Configure logging
        logging.basicConfig(
            level=logging.INFO,
            format="%(asctime)s - %(levelname)s - %(message)s",
            handlers=[logging.StreamHandler()],  # Outputs logs to stdout
        )

        # Get AWS credentials from environment variables
        self.aws_access_key_id = os.environ.get("AWS_ACCESS_KEY_ID")
        self.aws_secret_access_key = os.environ.get("AWS_SECRET_ACCESS_KEY")
        self.aws_region = os.environ.get(
            "AWS_DEFAULT_REGION", "us-east-1"
        )  # Default to 'us-east-1'

        # Create an S3 client using environment credentials
        session = boto3.Session(
            aws_access_key_id=self.aws_access_key_id,
            aws_secret_access_key=self.aws_secret_access_key,
            region_name=self.aws_region,
        )

        self.s3 = session.client("s3")

    def upload_file_to_s3(self, file_path, bucket_name, s3_key=None):
        """Upload a file to an S3 bucket.

        :param file_path: Path of the file to upload
        :param bucket_name: Target S3 bucket
        :param s3_key: S3 key (file name in S3). If not specified, the local file name will be used.
        :return: True if file was uploaded successfully, else False
        """
        # If s3_key is not specified, use the file name from the file_path
        if s3_key is None:
            s3_key = os.path.basename(file_path)

        try:
            # Upload the file
            self.s3.upload_file(file_path, bucket_name, s3_key)
            logging.info(f"File {file_path} uploaded to s3://{bucket_name}/{s3_key}")
            return True
        except FileNotFoundError:
            logging.error(f"The file {file_path} was not found")
            return False
        except NoCredentialsError:
            logging.error("AWS credentials are not available")
            return False
        except ClientError as e:
            logging.error(f"Error occurred while uploading to S3: {e}")
            return False

    def upload_folder_to_s3(self, folder_path, bucket_name, s3_folder_prefix=""):
        """Upload an entire folder to an S3 bucket.

        :param folder_path: Path of the folder to upload
        :param bucket_name: Target S3 bucket
        :param s3_folder_prefix: The folder path within the S3 bucket where the files will be uploaded
        """
        for root, dirs, files in os.walk(folder_path):
            for file_name in files:
                # Generate the full file path
                file_path = os.path.join(root, file_name)

                # Define the S3 key (file's path in the bucket)
                s3_key = os.path.relpath(file_path, folder_path)

                # Prepend the S3 folder prefix if provided
                if s3_folder_prefix:
                    s3_key = os.path.join(s3_folder_prefix, s3_key)

                # Upload the file to S3
                self.upload_file_to_s3(file_path, bucket_name, s3_key)

    def remove_local_file(self, file_path):
        """Remove the local file after it has been uploaded.

        :param file_path: Path of the file to delete.
        :return: True if file was deleted successfully, else False
        """
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
                logging.info(f"Local file {file_path} deleted successfully")
                return True
            else:
                logging.error(f"File {file_path} does not exist")
                return False
        except Exception as e:
            logging.error(f"Error occurred while deleting file {file_path}: {e}")
            return False
