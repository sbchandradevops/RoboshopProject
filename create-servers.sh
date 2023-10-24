#!/bin/bash

##### Change these values ###
ZONE_ID="Z0927899ZBM4L1UQ4QXM"
DOMAIN="sustainableforexea.shop"
SG_NAME="Blue-Vpc-SG"
env=dev
VPC_ID="vpc-0a9a921460f8a224d"          # Replace with your VPC ID
SUBNET_ID="subnet-044c3d17cb6298721"    # Replace with your Subnet ID
#############################

create_ec2() {
  INSTANCE_INFO=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t3.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}, {Key=Monitor,Value=yes}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]"  \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
      --security-group-ids ${SGID} \
      --subnet-id ${SUBNET_ID}    # Specify the Subnet
  )

  INSTANCE_ID=$(echo "${INSTANCE_INFO}" | jq -r '.Instances[0].InstanceId')
  if [ -z "$INSTANCE_ID" ]; then
    echo "Failed to launch the instance for ${COMPONENT}"
    exit 1
  fi

  PRIVATE_IP=$(aws ec2 describe-instances --instance-ids "${INSTANCE_ID}" | jq -r '.Reservations[0].Instances[0].PrivateIpAddress')

  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" -e "s/DOMAIN/${DOMAIN}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Server Created - SUCCESS - DNS RECORD - ${COMPONENT}.${DOMAIN}"
  else
     echo "Server Created - FAILED - DNS RECORD - ${COMPONENT}.${DOMAIN}"
     exit 1
  fi
}

## Main Program
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq -r '.Images[0].ImageId')
if [ -z "${AMI_ID}" ]; then
  echo "AMI_ID not found"
  exit 1
fi

SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq -r  '.SecurityGroups[0].GroupId')
if [ -z "${SGID}" ]; then
  echo "Given Security Group does not exist"
  exit 1
fi

for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch; do
  COMPONENT="${component}-${env}"
  create_ec2
done
