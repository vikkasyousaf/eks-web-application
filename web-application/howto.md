### Creating a Docker Image
This documentation show how to create a nginx docker image an push to dockerhub

We have already created a `Dockerfile` which container all the necessary configuration to help us run a `hello world` web-application.
The following commnad will build the image with images tag.
```
docker build -t <USERNAME>/nginx-application:0.2 .
```

Run this command to properly tag the docker image before pushing to dockerhub
```
docker tag <USERNAME>/nginx-application <USERNAME>/nginx-application:0.2
```
Before pushing the image to dockerhub, we need to login to our dockerhub account.
```
docker login --username <USERNAME> --password <PASSWORD>
```

Once you are successfully login to dockerhub, use the following command to push the image to dockerhub.
```
docker push <USERNAME>/nginx-application:0.2
```
In order to test the application, run the following command.
```
docker run --name docker-nginx -p 8081:8081 -d <USERNAME>/nginx-application:0.2
```
Finally use the following commnad to verify the web-application in terminal
```
curl 127.0.0.1:8081
```
 Or navigate to the brower and use the following ure to access the web-application
 ```
 http://127.0.0.1:8081/
 ```
