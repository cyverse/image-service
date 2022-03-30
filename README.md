# IMG

img is a highly scalable version of imaginary, that uses cloud native services  such as Kubernetes, HPA, Varnish Cache, Ngninx and Prometheus technologies to deploy a service on demand and a large-scale solution for massive image processing.

Refer to the imaginary repository for supported image operations and additional configuration.

## How it works


IMG runs in high availability mode using multiple Varnish and application pods.



```


                                                        ┌────────────┐
                                                        │            │
                                                   ┌────►  imaginary │
                                                   │    │            │
┌────────────┐   ┌────────────┐     ┌────────────┐ │    └────────────┘
│            │   │            │     │            │ │
│  Ingress ──┼──►│  Varnish   ├────►│ Balancer  ─┼─┤
│            │   │            │     │            │ │    ┌────────────┐
└────────────┘   └────────────┘     └────────────┘ │    │            │
                                                   └────►  imaginary │
                                                        │            │
                                                        └────────────┘


```


## Prerequisites
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Installation

You may want to edit `ansible/playbooks/install_img.yaml` to match your domain name just change this:

``` roles:
role: ansible-imaginary
role: ansible-prometheus
To this:
roles:
role: ansible-imaginary
vars:
 server_domain_names=[YOUR_SERVER_NAME]
role: ansible-prometheus 
```
### Local installation 

```bash
ansible-playbook -u root image-service/ansible/playbooks/install_img.yaml
```

### Remote installation
```bash
ansible-playbook -u root -i inventory_file_with_server_info ansible/playbooks/install_img.yaml
```
### Role variables


The following tables lists optional ansible variables along with the default values if not defined.

#### ansible-imaginary:

Variable Name | Default value if not defined | Description
------------- | ---------------------- | -----------
INSTALL_K3S | true | installs k3s for you
INSTALL_NGINX_INGRESS | true | installs the nginx ingress
imaginary_cpus | 4 | number of cpus imaginary uses
imaginary_cpu | 1600m | 
min_replicas | 2 | minimum number of replicas imaginary creates
max_replicas | 6 | maximum number of replicas imaginary can create
cache_size | 128m | the varnish cache size
imaginary_port | 9000 | The port used by imaginary internally
server_domain_names | [img.cyverse.org] | domain name to use

#### ansible-prometheus:

Variable Name | Default value if not defined | Description
------------- | ---------------------- | -----------
UPGRADE_NGINX_INGRESS | true | installs or upgrades nginx to work with prometheus
prometheus_release_name | monitoring | the name used for prometheus stack pods
prometheus_namespace | monitoring | the namespace the prometheus stack installs under

## Usage

To test our local image, let's process a file. In this case, we're going to crop an existing image from Imaginary's github repository.

```bash

 curl -O "http://localhost:8080/crop?width=500&height=400&url=https://raw.githubusercontent.com/h2non/imaginary/master/testdata/large.jpg"
 
```

This will ask Imaginary to crop, to 100x100, an image stored in the Imaginary Github repository. This should result in a file, large.jpg being written to disc which you can display using your preferred image viewer. MacOS users can simply open large.jpg at the command line.

