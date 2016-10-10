#!bin/bash
aws elb create-load-balancer --load-balancer-name itmo544-dr --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --subnets subnet-79296f0f --security-groups sg-9e7e8de7
echo " Load Balancer Created"

#Create autoscaling launch configurations
aws autoscaling create-launch-configuration --launch-configuration-name itmo544-dr-hw4 --image-id ami-06b94666 --security-groups sg-9e7e8de7 --key-name MyKeyPair --instance-type t2.micro --user-data file://installenv.sh
echo "Autoscaling Launch Configured"

#Create Autoscaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name itmo544-hw4 --launch-configuration itmo544-dr-hw4 --availability-zone us-west-2b --load-balancer-name itmo544-dr --max-size 5 --min-size 2 --desired-capacity 4
echo "Autoscaling group created"

#Attach instances to the load balancer
aws autoscaling attach-load-balancers --load-balancer-names itmo544-dr --auto-scaling-group-name itmo544-hw4
echo "Instances attached"




