resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}_cloudwatch-alerts"
}

resource "aws_sns_topic_subscription" "sms" {
  count     = var.alert_sms == "" ? 0 : 1

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "sms"
  endpoint  = var.alert_sms
}
