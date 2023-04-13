# Automate EC2 AMI cross region copy for Disaster Recovery.

Are you looking for a way to automate the process of copying your Amazon Machine Images (AMIs) across AWS regions? 🌏 Look no further! I've got an efficient AWS Lambda function written in Python that does just that! 🚀

The Lambda function leverages the powerful Boto3 library to interact with the AWS EC2 service, allowing you to manage your AMIs with ease. With a primary focus on replicating AMIs created on the current date, this script ensures that the latest AMIs are available across your specified regions. This can be particularly useful when you want to maintain up-to-date backups or deploy applications in multiple regions.

### 🔑 Key features of the script:

* Retrieves source and destination region names from environment variables.
* Initializes Boto3 EC2 clients for both regions to facilitate API interactions.
* Filters available images in the source region based on ownership and state.
* Compares each image's creation date with today's date to identify matching AMIs.
* Copies any matching AMIs to the destination region while preserving image metadata.

### 📋 Here's a high-level overview of the script's execution:

* It starts by importing the required libraries, including os, boto3, and datetime.
* The lambda_handler function handles the core logic and receives AWS Lambda event and context parameters.
* Source and destination region names are fetched from environment variables.
* Boto3 EC2 clients are initialized for both regions.
* The script describes images in the source region, filtering for images owned by the current account and in an 'available' state.
* It compares each image's creation date to today's date to find matching AMIs.
* If any AMIs match today's date, the script initiates the copy process to the destination region.
* If no matching AMIs are found, the script prints an informative message.
* Finally, the script returns a status code and a message indicating the completion of the AMI copy process.
* In conclusion, this AWS Lambda function provides a seamless and automated way to keep your AMIs up to date across multiple regions. Deploy the function and configure the necessary triggers to start taking advantage of this powerful automation tool today! 🌟

