import boto3
import config


class aws:
    def __init__(self, aws_access_key_id=None, aws_secret_access_key=None):
        aws_access_key_id = aws_access_key_id or config.aws_access_key_id
        aws_secret_access_key = aws_secret_access_key or config.aws_secret_access_key
        self.session = boto3.Session(
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
        )
        self.ec2_client = self.session.client('ec2', region_name="ap-northeast-1")

    def 重启所有实列(self):
        for instance in self.获取所有实列():
            self.ec2_client.reboot_instances(
                InstanceIds=[instance.get("InstanceId")]
            )

    def 获取所有实列(self):
        response = self.ec2_client.describe_instances()
        return response['Reservations']
