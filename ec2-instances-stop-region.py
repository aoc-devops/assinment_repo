#This script is used to stop all running instances across all regions

import boto3
def lambda_handler(event, context):
    ec2 = boto3.resource('ec2')
    regions = []
    for region in ec2.meta.client.describe_regions()['Regions']:
        regions.append(region['RegionName'])  #to print region names for ec2 service
    # print(ec2.meta.client.describe_regions()['Regions'])
    for region in regions:
        ec2 = boto3.resource("ec2", region_name=region) #targeting resorces of perticular region
        print("EC2 region is:", region)

        ec2_instance = {"Name": "instance-state-name", "Values": ["running"]}
    #here filter name is ec2_instance in this we have to define name and values
        instances = ec2.instances.filter(Filters=[ec2_instance])
    # here instances is collective command to target running instances
    #this for loop is inside regions loop
        for instance in instances:
            instance.stop()
            print("The following EC2 instances is now in stopped state", instance.id)

        for instance in instances:
            instance.terminate()
            print("The following EC@ instances are terminated", instance.id)

     return {
        'statusCode': 200,
        'body': 'EC2 instances stopped and terminated successfully!'
    }