A bundle for deploying a Brigade project for [Brigade v2](https://github.com/brigadecore/brigade/tree/v2)
to Kubernetes via Helm.

The intention is that each installation of this bundle aligns with a specific Brigade v2 project.  To that end,
the naming of the project hinges off of the installation name, which should be explicitly set
(otherwise, the default/generic bundle name of `brigade-project` will be used.)

For example, here we install with the specific installation name of `my-brigade-project`,
supplying the corresponding credential set and parameter set as well.

```
$ porter install my-brigade-project -c my-brigade-project -p my-brigade-project
```

The project will then be named `my-brigade-project`, despite what the `metadata.id` field might be
in the provided `project-file` parameter.