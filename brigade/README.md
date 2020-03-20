An example bundle exercising @MChorfa's work in https://github.com/deislabs/porter-helm/pull/61

Specifically, the addition of Helm repo support in the `helm` mixin:

```yaml
mixins:
  - helm:
      repositories:
        brigadecore:
          url: "https://brigadecore.github.io/charts"
```