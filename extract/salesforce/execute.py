from extract.salesforce.api import SalesforceAPI
from utils.aws.s3_manager import S3Manager


s3_manager = S3Manager()
api = SalesforceAPI()
api.download_all_csvs()
folder_path = api.local_directory

if __name__ == "__main__":
    s3_manager.upload_folder_to_s3(
        folder_path=folder_path,
        bucket_name="s3-raw-data-19",
        s3_folder_prefix="salesforce",
    )

# Run this file:  PYTHONPATH=path-of-project python3 path-of-file-to-execute
