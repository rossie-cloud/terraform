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



## Description

An in-depth paragraph about your project and overview of use.

![diagram](https://github.com/rossie-cloud/terraform/blob/main/gcp-templates/modules/http-load-balancer/http-lb-diagram.png)

## Getting Started

### Dependencies

* Describe any prerequisites, libraries, OS version, etc., needed before installing program.
* ex. Windows 10

### Installing

* How/where to download your program
* Any modifications needed to be made to files/folders

### Executing program

* How to run the program
* Step-by-step bullets
```
code blocks for commands
```

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Contributors names and contact info

ex. Dominique Pizzie  
ex. [@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)