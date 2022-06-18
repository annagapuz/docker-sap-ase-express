# Run SAP ASE Express Edition in a Docker Container

## Download

### SAP ASE Evaluation Install
You have to create a free SAP account in order to download the tarball.
The evaluation install allows you to select the "Express Edition". SAP ASE Express Edition for Linux x86-64 is a free, full use license available for use on up to 4 engines and 50 GB databases.

https://www.sap.com/cmp/td/sap-ase-enterprise-edition-trial.html

### SAP JVM 8 for 64-bit Linux
Although the JRE comes packaged with the evaluation install, it didn't work

https://tools.hana.ondemand.com/#cloud
https://tools.hana.ondemand.com/additional/sapjvm-8.1.088-linux-x64.zip

## Build and Run Docker Container

### Note Before You Start
The file `install_response.txt` contains all of the installation responses needed to run a silent installation. You can edit the admin password in that file, which is defaulted to `password`.

If you want a different starting installation, you need to generate a new response file. Remove the execution of `setup.bin` from the `Dockerfile` and then run the image in interactive shell mode.

Linux installation instructions are here:
https://help.sap.com/viewer/23c3bb4a29be443ea887fa10871a30f8/LATEST/en-US/a6612e5fbc2b10149d8a80b52f34dc5a.html

### Build Image
`sudo docker build -t <image-name-of-your-choice>.`

### Run Image in Interactive Shell Mode
`sudo docker run --hostname 127.0.0.1 -p127.0.0.1:5001:5000 -it <image-name> /bin/sh`

SAP ASE will not be running unless you run the start script `/opt/sap/start_SYBASE.sh`

### Run Image with SAP ASE Running
`sudo docker run --hostname 127.0.0.1 -p127.0.0.1:5001:5000 <image-name>`

Internally, SAP ASE runs on port 5000, but you can change the externally facing port on your host machine

-p127.0.0.1:**5001**:5000

### Create a Reusable and Writable Container
#### Create the container
`sudo docker create --name <container-name-of-your-choice> --hostname 127.0.0.1 -p127.0.0.1:<port-of-your-choice>:5000 <image-name>`

#### Start the container
`sudo docker container start <container-name>`

#### Stop the container
`sudo docker container stop <container-name>`

By design, running an image creates an ephemeral container. By creating an explicit container, any objects added to the SAP ASE database server will persist and be available the next time you start the container.

#### Get the JDBC Client Library
The container must be running in order to copy out the jConnect library

`sudo docker cp <container-name>:/opt/sap/jConnect-16_0/classes/jconn4.jar .`

#### JDBC Connection String
`jdbc:jtds:sybase://127.0.0.1:<container-port>/master`

User: sa

Password: password
