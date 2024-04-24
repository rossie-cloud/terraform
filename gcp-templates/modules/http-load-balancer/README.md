# Module - HTTP(s) load balancer

Building block for an external classic application load balancer  that routes requests to serverless backends (specifically Cloud Functions).

The image below contains the elements of the HTTP(s) load balancer.
* Global static external IP address: Required when using custom domains and is also required for Google-managed SSL certificated (as is the case in this module).
* SSL Certificate. This module uses Google-managed certificates, but you can also use self-signed certificates.
* 

Important things to consider:
* Internal load balancers for serverless NEG are *only* supported for Cloud Run.
* Health checks are not supported for backend services with serverless NEG backends.
* 

![diagram](https://github.com/rossie-cloud/terraform/blob/main/gcp-templates/modules/http-load-balancer/http-lb-diagram.png)


