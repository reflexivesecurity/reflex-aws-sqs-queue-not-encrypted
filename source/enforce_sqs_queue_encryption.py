""" Module for PublicAMIRule """

import json

import boto3

from reflex_core import AWSRule


class EncryptSQSQueueRule(AWSRule):
    """ AWS rule for ensuring SQS queues are encrypted """

    client = boto3.client("sqs")

    def __init__(self, event):
        super().__init__(event)

    def extract_event_data(self, event):
        """ Extract required data from the CloudWatch event """
        self.raw_event = event
        if event["detail"]["eventName"] == "SetQueueAttributes":
            self.sqs_queue_url = event["detail"]["requestParameters"]["queueUrl"]
        else:  # event["detail"]["eventName"] == "CreateQueue"
            self.sqs_queue_url = event["detail"]["responseElements"]["queueUrl"]

    def resource_compliant(self):
        """ Determines if the SQS queue is encrypted, and if so returns True and False otherwise """
        is_compliant = True
        response = self.client.get_queue_attributes(
            QueueUrl=self.sqs_queue_url, AttributeNames=["KmsMasterKeyId"]
        )

        try:
            response["Attributes"]["KmsMasterKeyId"]
        except KeyError:
            is_compliant = False

        return is_compliant

    def remediate(self):
        """ Makes the EBS snapshot private """
        self.client.set_queue_attributes(
            QueueUrl=self.sqs_queue_url, Attributes={"KmsMasterKeyId": "alias/aws/sqs"},
        )

    def get_remediation_message(self):
        """ Returns a message about the remediation action that occurred """
        message = f"The SQS queue with URL: {self.sqs_queue_url} was unencrypted. "
        if self.should_remediate():
            message += "Encrypted with default KMS key."

        return message


def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    rule = EncryptSQSQueueRule(json.loads(event["Records"][0]["body"]))
    rule.run_compliance_rule()
