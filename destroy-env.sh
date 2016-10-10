#!bin/bash
aws autoscaling update-auto-scaling-group --auto-scaling-group-name itmo544-hw4  --min-size 0 --max-size 0 --desired-capacity 0
echo "Reducing outscaling groups"

#Grab instances ids
ID=$(aws ec2 describe-instances | awk {'print $8'}| grep 'i-0*')

#Deregister instances from the load balancer
aws elb deregister-instances-from-load-balancer --load-balancer-name itmo544-dr --instances $ID
echo "Deregister load balancer"

#Detach from autoscaling group
aws autoscaling detach-load-balancers --load-balancer-names itmo544-dr --auto-scaling-group-name itmo544-hw4
echo "Detach load balancer from autoscaling group"

#Delete Load balancer
aws elb delete-load-balancer --load-balancer-name itmo544-dr
echo "Delete load balancer"


#Terminate all instances and wait until terminated
aws ec2 terminate-instances --instance-ids $ID
echo "Waiting..."
aws ec2 wait instance-terminated --instance-ids $ID

#Delete autoscaling group
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name itmo544-hw4
echo "Deleting autoscaling group"

#delete launch config
aws autoscaling delete-launch-configuration --launch-configuration-name itmo544-dr-hw4
echo "Deleteing Launch Configuration"



echo "Done"
