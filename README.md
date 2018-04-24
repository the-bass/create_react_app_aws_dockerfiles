# Create React App / AWS Dockerfile

This image is meant to be used for *developing* React apps using

- `create-react-app`
- `yarn`

and manage their deployment to S3 using

- `aws`

## Building the image

From the directory the Dockerfile is in, build the image using

```sh
docker build -t the_bass/create_react_app_aws .
```

## Developing your app

All commands are assumed to be executed from the directory of your react app.

### Start the development server

Start a local development server on port `3000`. If a relevant file gets changed, the page will now automatically reload to reflect these changes.

```sh
docker run -it --rm \
  -w /app \
  -v `pwd`:/app \
  -p 3000:3000 \
  the_bass/create_react_app_aws \
  yarn start
```

### Start the test runner

The test runner makes sure all relevant tests get run when files in your app change.

```sh
docker run -it --rm \
  -w /app \
  -v `pwd`:/app \
  the_bass/create_react_app_aws \
  yarn test
```

### Run bash

In some cases it might be convenient to run an interactive bash session inside a container.

```sh
docker run -it --rm \
  -w /app \
  -v `pwd`:/app \
  the_bass/create_react_app_aws \
  bash
```

### Create a production build

Create an optimized version of your app inside the `./bundle` folder.

```sh
docker run -it --rm \
  -w /app \
  -v `pwd`:/app \
  the_bass/create_react_app_aws \
  yarn build
```

## Deployment to S3

You might want to check out [this blog post](https://medium.com/@omgwtfmarc/deploying-create-react-app-to-s3-or-cloudfront-48dae4ce0af) for a more in-depth tutorial.

### Configure the AWS client

Go to your AWS management console, create a new IAM user and attach the policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::itsme.com"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::itsme.com/*"
            ]
        }
    ]
}
```
to it. Make sure to replace `itsme.com` with your own bucket name in the policy above, though. Afterwards, run the below command using the credentials of this user. Note, that your aws configuration will be stored in `./.aws` after you've finished the configuration process of the aws cli. So you won't have to do that twice.

```sh
docker run -it --rm \
  -v `pwd`/.aws:/root/.aws \
  the_bass/create_react_app_aws \
  aws configure
```

### Upload your bundle into your S3 bucket

Upload the contents of `./bundle` (check section *Create a production build* on how to bundle above) into your S3 bucket. Make sure to replace `itsme.com` with the name of your own bucket in this command.

```sh
docker run -it --rm \
  -w /app \
  -v `pwd`:/app \
  -v `pwd`/.aws:/root/.aws \
  the_bass/create_react_app_aws \
  aws s3 sync build/ s3://itsme.com
```
