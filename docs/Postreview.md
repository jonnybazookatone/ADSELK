# ADS Elastic/Logstash/Kibana Stack Specification Review

## Bullet Points Aims

  1. Simple infrastructure to ensure little management
  1. Light-weight for deployment
  1. Reliable and robust (extendable)
  1. Easy to setup new log shippers (DevOps, well documented)

Some extra points to add afterwards:

  1. Review of the stack and alternatives
  1. Deployment to production
  1. Well documented

## Initial estimate (guestimate)

  1. Research, design, review: `1 week`
  1. Working prototype on VM, `3 weeks`, week per stack entity
  1. Deployment of prototype on AWS, `2 weeks`
  1. Documentation, `3 days`

Total: 6 weeks 3 days

## Time taken

  1. Research: `1 week`
  1. Working prototype on VM: `1 week`
  1. Deployment of prototype on AWS: `8 days`
  1. Documentation: `3 days`

Total: 3 weeks 4 days

## Overview of achievements

  1. **DONE** Simple infrastructure to ensure little management
    * There are 3 pieces to the stack (ELK) and given that the logstash-forwarder does not need a queue system, there are no intermediate pieces of software in the stack. For deployment the pieces of the stack are in their own docker containers, and there are also build scripts for when they are deployed within the AWS. This ensures there is as little as much to do by the user, as possible.
  1. **DONE** Light-weight for deployment
    * Currently, two machines are required: 1 for logstash, the other for elasticsearch+kibana. All other services need only install logstash-forwarder to send their logs.
  1. **DONE** Reliable and robust (extendable)
    * Well used and well supported stack has been used. Each part of the stack, can be upgraded/replaced for another piece of software. The whole stack can actually be replaced, using the same infrastructure that is in place. There are no real issues that would stop any of the stack being replaced, and aslong as they meet our requirements, this is not a problem.
  1. **DONE** Easy to setup new log shippers (DevOps, well documented)
    * The forwarder has its own docker container and deployment script. Documentation has been included to show the user how they would setup their logging. It assumes a standard location for logs and so should require little (if at all) any configuration.
  1. **DONE** Review of the stack and alternatives
    * Extensive overview of alternatives and why we should or should not use them in place of the ELK stack.
  1. **DONE** Deployment to production
    * Currently deployed on the AWS and logging to elasticsearch and S3 storage
  1. **DONE** Well documented
    * Contains documentation on the overview of the system, and a post review of the work done.
