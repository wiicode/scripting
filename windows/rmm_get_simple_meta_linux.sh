instancename=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
instanceregion=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export AWS_PROFILE=describetags
echo "The instance-name of this instance is:"
echo $instancename
echo "The hostname of this instance is:"
hostname
echo "The ip-address of this instance is:"
hostname -I | awk '{print $1}'
echo "The other useful metadata for this instance is:"
/DATA/ops/ec2-metadata
echo "The tags for this instance are:"
aws ec2 describe-tags --region $instanceregion --filters "Name=resource-id,Values=$instancename" --profile describetags


aws ec2 describe-tags --region us-east-1 --filters "Name=resource-id,Values=i-421421421" --profile describetags

[profile describetags]
role_arn = arn:aws:iam::1231231231231:role/corp-aws-machines
credential_source = Ec2InstanceMetadata
