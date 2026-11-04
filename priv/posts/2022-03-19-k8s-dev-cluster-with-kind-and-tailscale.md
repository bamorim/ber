%{title: "K8s dev cluster with Kind and Tailscale"}
---
Recently at my work we started using [Kind](https://kind.sigs.k8s.io/) and [ctlptl](https://github.com/tilt-dev/ctlptl) to bring up a local Kubernetes cluster to use in development together with [Tilt](https://tilt.dev/).

This setup worked perfectly fine. However, when you want to run too many things (like our entire observability stack with Grafana, Prometheus, Loki and Tempo) it can take a hit on your CPU. Even then, albeit the MacBook Pro fan going wild, it was still usable.

That's until I tried to stream a workshop using [mmhmm](https://www.mmhmm.app/), being transmitted through Zoom. Suddenly, the local Kubernetes cluster, mmhmm and Zoom started competing for CPU and the stream frames-per-second went down by a lot (like maybe less than 1 FPS).

At that point, I had an option:

- I could do the workshop in my Linux desktop (which has a way more powerful CPU) but replace mmhmm with something like [OBS](https://obsproject.com/)
- I could stay on Mac, use mmhmm but run the Kubernetes cluster somewhere else (ideally on my Linux desktop).

I didn't liked the first option because mmhmm makes the whole presentation more entertaining. So I started exploring the second option.

## The Plan

I wanted to be able to have a development cluster on my Linux desktop running but still be able to access it from outside my home network. This is where [Tailscale](https://tailscale.com/) comes in. Tailscale basically provides a WireGuard based VPN without any complex configuration.

So my plan was:

- Setup a Tailscale network with both my desktop and my Macbook Pro
- Setup a Kind cluster in my desktop
- Expose that cluster to the Tailscale IP for my desktop
- Setup configuration so Tilt can correctly detect the registry

## Making it work

I had to do and redo the plan a few times, but this is how I managed to make it work:

On my desktop I setup Tailscale first and then got my tailscale ip with

```sh
tailscale ip -4
```

Then I created a file describing my shared cluster:

```yaml
apiVersion: ctlptl.dev/v1alpha1
kind: Registry
port: 35000
listenAddress: "<DESKTOP-TAILSCALE-IP>"
name: shared-registry
---
apiVersion: ctlptl.dev/v1alpha1
kind: Cluster
product: kind
registry: shared-registry
kindV1Alpha4Cluster:
  name: shared-cluster
  networking:
    apiServerAddress: "<DESKTOP-TAILSCALE-IP>"
    apiServerPort: 35443
```

Then I created the cluster with

```sh
ctlptl apply -f shared-cluster.yaml
```

After this was setup, I thought I was done, but after some tasks I realized I need to do some more things to allow Tilt on the other side to work properly.

The way Tilt automatically finds the registry configuration for a cluster is using [KEP-1755](https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry). The way it works is that it have a ConfigMap in the `kube-public` namespace named `local-registry-hosting`. However, even though I specified `listenAddress` to ctlptl, it still created it with the wrong configuration (host was set to `localhost:35000`). So I edited the config map to look like this:

```yaml
apiVersion: v1
data:
  localRegistryHosting.v1: |
    host: <DESKTOP-TAILSCALE-IP>:35000
    hostFromClusterNetwork: shared-registry:5000
    hostFromContainerRuntime: shared-registry:5000
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
```

After that, I needed to setup on my MacBook that the registry `<DESKTOP-TAILSCALE-IP>:35000` is an insecure registry. It basically means ensuring the Docker config has the `insecure-registries` config:

```json
{
  "insecure-registries": ["<DESKTOP-TAILSCALE-IP>:35000"]
}
```

You can check the [Docker documentation about Insecure Registries](https://docs.docker.com/registry/insecure/#deploy-a-plain-http-registry) for that.

If you don't plan to build docker images and push from the desktop itself, you can instead of setting the insecure registries, you can add `hostFromContainerRuntime: localhost:35000` to the `localRegistryHosting.v1` config as any `localhost` registries are already treated as insecure.

## Another learning: Tilt is smarter than I thought

For a long time I've been setting the image when deploying with Tilt to be something like `localhost:35000/my-image:latest`. However, I just figured out Tilt is smarter than that when it can discover the registry for the cluster using KEP-1755 you just need to make sure the image name on the `docker_build` command is the same on your Kubernetes manifest and it will automatically replace with a image in the local registry it discovered.
