import os
import requests


class SalesforceAPI:
    def __init__(self, local_directory="./data/salesforce"):
        self.github_api_url = "https://api.github.com/repos/shrestic/temp_data/contents/salesforce"
        self.raw_base_url = "https://raw.githubusercontent.com/shrestic/temp_data/master/salesforce/"
        self.local_directory = local_directory

        # Ensure local directory exists
        if not os.path.exists(self.local_directory):
            os.makedirs(self.local_directory)

    def get_github_files(self):
        """Fetch the list of files from the GitHub repository folder."""
        response = requests.get(self.github_api_url)

        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to get file list. HTTP Status Code: {response.status_code}")
            return []

    def download_csv_from_github(self, file_name):
        """Download a CSV file from GitHub to the local directory."""
        file_url = f"{self.raw_base_url}{file_name}"
        local_file_path = os.path.join(self.local_directory, file_name)

        response = requests.get(file_url)

        if response.status_code == 200:
            with open(local_file_path, "wb") as file:
                file.write(response.content)
            print(f"Downloaded: {local_file_path}")
        else:
            print(f"Failed to download file: {file_name}. HTTP Status Code: {response.status_code}")

    def download_all_csvs(self):
        """Fetch all files from the GitHub folder and download only CSV files."""
        files = self.get_github_files()

        for file_info in files:
            if file_info["name"].endswith(".csv"):
                file_name = file_info["name"]
                local_file_path = os.path.join(self.local_directory, file_name)

                # Download only if the file doesn't already exist locally
                if not os.path.exists(local_file_path):
                    print(f"New CSV file detected: {file_name}")
                    self.download_csv_from_github(file_name)
                else:
                    print(f"File already exists: {file_name}, skipping download.")
