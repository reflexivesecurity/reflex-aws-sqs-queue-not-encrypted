# reflex-aws-enforce-sqs-queue-encryption
Enforces SQS queue encryption. Will encrypt queues with the default KMS key.

## Usage
To use this rule either add it to your `reflex.yaml` configuration file:  
```
version: 0.1

providers:
  - aws

measures:
  - reflex-aws-enforce-sqs-queue-encryption
```

or add it directly to your Terraform:  
```
...

module "reflex-aws-enforce-sqs-queue-encryption" {
  source           = "github.com/cloudmitigator/reflex-aws-enforce-sqs-queue-encryption"
  email            = "example@example.com"
}

...
```

## License
This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-enforce-sqs-queue-encryption/blob/master/LICENSE) 
