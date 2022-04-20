### Creating a Docker Image
This documentation show how to create a nginx docker image an push to dockerhub

We have already created a `Dockerfile` which container all the necessary configuration to help us run a `hello world` web-application.
The following command will build the image with images tag.
```
docker build -t cloudcomputing17/nginx-application:0.4
```

Run this command to properly tag the docker image before pushing to dockerhub
```
docker tag cloudcomputing17/nginx-application cloudcomputing17/nginx-application:0.4
```
Before pushing the image to dockerhub, we need to login to our dockerhub account.
```
docker login --username <USERNAME> --password <PASSWORD>
```
Once you are successfully login to dockerhub, use the following command to push the image to dockerhub.
```
docker push cloudcomputing17/nginx-application:0.4
```
In order to test the application, run the following command.
```
docker run --name docker-nginx -p 8080:8080 -d cloudcomputing17/nginx-application:0.4
```
Finally use the following commnad to verify the web-application in terminal
```
curl 127.0.0.1:8080
```
 Or navigate to the browser and use the following url to access the web-application
 ```
 http://127.0.0.1:8080/
 ```
