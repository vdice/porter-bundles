This Porter bundle is for installing the [gh-build-badge](https://github.com/technosophos/gh-build-badge) Helm chart to Kubernetes.

As of writing, the chart itself isn't served via a chart repo, so we clone the repo into the installer image at build-time via the custom Dockerfile.
