provider "aws" {
  region = "us-east-1"
}

module "enforce_sqs_queue_encryption" {
  source           = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe_lambda?ref=v0.5.8"
  rule_name        = "EnforceSQSQueueEncryption"
  rule_description = "Rule to enforce SQS queue encryption"

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

  function_name            = "EnforceSQSQueueEncryption"
  source_code_dir          = "${path.module}/source"
  handler                  = "enforce_sqs_queue_encryption.lambda_handler"
  lambda_runtime           = "python3.7"
  environment_variable_map = { SNS_TOPIC = var.sns_topic_arn }
  custom_lambda_policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:GetQueueAttributes",
        "sqs:SetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF


  queue_name    = "EnforceSQSQueueEncryption"
  delay_seconds = 0

  target_id = "EnforceSQSQueueEncryption"

  sns_topic_arn = var.sns_topic_arn
  sqs_kms_key_id = var.reflex_kms_key_id
}
