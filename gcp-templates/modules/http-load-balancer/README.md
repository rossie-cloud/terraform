# Module - HTTP(s) load balancer

Building block for an external classic application load balancer  that routes requests to serverless backends (specifically Cloud Functions).

* Global static external IP address: Required when using custom domains and is also required for Google-managed SSL certificated (as is the case in this module).
* SSL Certificate. This module uses Google-managed certificates.
* The backend will use a serverless NEG (network endpoint group). These don't have any network endpoints such as ports or IP addresses. They can only point to an existing Cloud Run, App Engine, API Gateway, or Cloud Functions service residing in the same region as the NEG.

Important things to consider:
* Internal load balancers for serverless NEG are *only* supported for Cloud Run.
* Health checks are not supported for backend services with serverless NEG backends.

A load balancer using a serverless NEG backend requires special configuration only for the backend service that is ilustrated in the diagram below:

![diagram](https://github.com/rossie-cloud/terraform/blob/main/gcp-templates/modules/http-load-balancer/http-lb-diagram.png)


