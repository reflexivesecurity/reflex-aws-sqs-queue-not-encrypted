module "cwe" {
  source      = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe?ref=v2.1.0"
  name        = "SqsQueueNotEncrypted"
  description = "Rule to enforce SQS queue encryption"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.sqs"
  ],
  "detail": {
    "eventSource": [
      "sqs.amazonaws.com"
    ],
    "eventName": [
      "CreateQueue",
      "SetQueueAttributes"
    ]
  }
}
PATTERN

}
