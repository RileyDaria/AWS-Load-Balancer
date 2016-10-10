#!bin/bash
aws autoscaling update-auto-scaling-group --auto-scaling-group-name itmo544-hw4  --min-size 0 --max-size 0 --desired-capacity 0
echo "Reducing outscaling groups"

ID=$(aws ec2 describe-instances | awk {'print $8'}| grep 'i-0*')
aws elb deregister-instances-from-load-balancer --load-balancer-name itmo544-dr --instances $ID
echo "Detach load balancer"

aws autoscaling detach-load-balancers --load-balancer-names itmo544-dr --auto-scaling-group-name itmo544-hw4
echo "Detach load balancer from autoscaling group"

aws elb delete-load-balancer --load-balancer-name itmo544-dr
echo "Delete load balancer"



aws ec2 terminate-instances --instance-ids $ID
echo "Waiting..."
aws ec2 wait instance-terminated --instance-ids $ID


aws autoscaling delete-auto-scaling-group --auto-scaling-group-name itmo544-hw4
echo "Deleting autoscaling group"


aws autoscaling delete-launch-configuration --launch-configuration-name itmo544-dr-hw4
echo "Deleteing Launch Configuration"



echo "Done"
