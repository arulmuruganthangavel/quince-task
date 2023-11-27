import boto3

def find_open_security_groups():
    ec2 = boto3.client('ec2')

    response = ec2.describe_security_groups()

    for group in response['SecurityGroups']:
        for permission in group['IpPermissions']:
            if (
                (permission.get('IpProtocol') == '-1') or
                (permission.get('IpProtocol') == 'tcp' and permission.get('FromPort') == 0 and permission.get('ToPort') == 65535)
            ):
                print(f"Security Group {group['GroupId']} is open.")

if __name__ == "__main__":
    find_open_security_groups()
