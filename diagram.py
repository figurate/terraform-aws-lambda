from diagrams import Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.security import IAMRole

with Diagram("AWS Lambda Function", show=False, direction="TB"):

    Lambda("lambda function") << IAMRole("lambda role")
