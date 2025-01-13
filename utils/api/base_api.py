import os

import requests


class BaseAPI:
    def __init__(self, source):
        self._github_api_url = (
            f"https://api.github.com/repos/shrestic/temp_data/contents/{source}"
        )
        self.saved_data_directory = f"./data/{source}"
        self.source = source
        # Ensure local directory exists
        if not os.path.exists(self.saved_data_directory):
            os.makedirs(self.saved_data_directory)

    def get_github_files(self, url):
        """Fetch the list of files from the GitHub repository folder."""
        response = requests.get(url)

        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to get file list. HTTP Status Code: {response.status_code}")
            return []

    def download_csv_from_github(self, file_url, local_file_path):
        """Download a CSV file from GitHub to the local directory."""
        response = requests.get(file_url)

        if response.status_code == 200:
            with open(local_file_path, "wb") as file:
                file.write(response.content)
            print(f"Downloaded: {local_file_path}")
        else:
            print(
                f"Failed to download file: {local_file_path}. HTTP Status Code: {response.status_code}"
            )

    def fetch_data(self, url=None, local_dir=None):
        """Fetch all files recursively from the GitHub folder and download only CSV files."""
        url = url or self._github_api_url
        local_dir = local_dir or self.saved_data_directory

        files = self.get_github_files(url)
        for file_info in files:
            if file_info["type"] == "file" and file_info["name"].endswith(".csv"):
                file_name = file_info["name"]
                file_url = file_info["download_url"]
                local_file_path = os.path.join(local_dir, file_name)

                # Download only if the file doesn't already exist locally
                if not os.path.exists(local_file_path):
                    print(f"New CSV file detected: {file_name}")
                    self.download_csv_from_github(file_url, local_file_path)
                else:
                    print(f"File already exists: {file_name}, skipping download.")

            elif file_info["type"] == "dir":
                # Create the corresponding local subdirectory
                sub_dir_path = os.path.join(local_dir, file_info["name"])
                if not os.path.exists(sub_dir_path):
                    os.makedirs(sub_dir_path)

                # Recursively download CSVs from subdirectories
                self.fetch_data(file_info["url"], sub_dir_path)
