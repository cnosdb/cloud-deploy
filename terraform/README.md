# step 1 - create
terraform init 

# step 2 - deploy

terraform apply

# step 3 - login 

step 2 will give cnosdb public ip, you shoud `chmod 400 /root/.ssh/id_rsa`,
then `ssh ubuntu@<cnosdb-public-ip>` login into the server.

port 22 and 31007 is open, you can add whitelisted ip into the main.tf.
