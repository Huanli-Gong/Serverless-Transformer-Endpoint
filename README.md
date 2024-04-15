# Serverless Transformer Endpoint
This project deploys a sentiment analysis model using the Hugging Face Transformers library. We have selected a model specifically trained for sentiment analysis, implemented through the 'pipeline' interface for text classification. This model is encapsulated in a Docker container and deployed to AWS Lambda, providing an endpoint for real-time sentiment analysis.

## Steps
### Push Docker image to Amazon ECR
Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions
```
docker build -t text-classification .
```

Create a repository on Elastic Container Registry (ECR)
```
aws ecr create-repository --repository-name text-classification --region us-east-1
```
Retrieve an authentication token and authenticate your Docker client to your registry.
Use the AWS CLI:

```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin account_id.dkr.ecr.us-east-1.amazonaws.com
```
After the build completes, tag your image so you can push the image to this repository:
```
docker tag text-classification:latest account_id.dkr.ecr.us-east-1.amazonaws.com/text-classification:latest
```
Run the following command to push this image to your newly created AWS repository:
```
docker push account_id.dkr.ecr.us-east-1.amazonaws.com/text-classification:latest
```
###Integration with AWS Lambda

1. After sucessfuly pushing the docker image to ECR, navigate into `Lambda` under AWS console. 
2. Create a new function with the option `Container image`, enter the Amazon ECR image URL, and choose `arm64` architecture.
3. Then, click into your lambda function, and under `configuration`, navigate into the `General configuration`, and adjust the Memory and timeout setting based on the characteristics of your LLM (token etc.).
4. Then, click into the `functional URL`, create a new function URL with `CORS enabled`.


###Implement query endpoint

Using cURL request against endpoint for testing the functionality of this application.

- run 
```
docker run --rm -p 3030:8080 --entrypoint /usr/local/bin/aws-lambda-rie text-classification /usr/local/bin/python -m awslambdaric app.lambda_handler
```

- request
```
curl -XPOST "http://localhost:3030/2015-03-31/functions/function/invocations" -d "{\"text\":\"This restaurant is awesome\"}"
```


## Screenshots
- AWS ECR Repository 
![ecr](Screenshots/ecr.png)

- AWS Lambda Function
![lambda](Screenshots/lambda.png)

- cURL request against endpoint
![cURL](Screenshots/curl.png)

