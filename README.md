Apache Flink Stateful Functions Docker Images
=============================================

This repo contains Dockerfiles for building Docker images for [Apache Flink Stateful Functions](https://github.com/apache/flink-statefun).

These Dockerfiles are maintained by the Apache Flink community.

Workflow for new releases
-------------------------

### Release workflow

When a new release of Flink Stateful Functions is available, the Dockerfiles in this repo should be updated.

Updating the Dockerfiles involves 3 steps:

1. Add the GPG key ID of the key used to sign the new release to the `gpg_keys.txt` file.
    * Entry format: <statefun_version>=<signing_key>, e.g., 2.0.0=1C1E2394D3194E1944613488F320986D35C33D6A
    * Commit this change with message `[release] Add GPG key for x.y.z release`.
2. Run `add-version.sh` with the appropriate arguments (`-s statefun-version -f flink-version`)
    * e.g. `./add-version.sh -s 2.0.0 -f 1.10.0`
    * Commit these changes with message `[release] Update Dockerfiles for x.y.z release`.

A pull request can then be opened on this repo with the changes.

### Release checklist

- [ ] The GPG key ID of the key used to sign the new release has been added to `gpg_keys.txt` and
      committed with the message `[release] Add GPG key for x.y.z release`
- [ ] `./add-version.sh -s x.y.z -f a.b.c` has been run, and the new Dockerfiles committed with
      the message `[release] Update Dockerfiles for x.y.z release`
- [ ] A pull request with the above changes has been opened on this repo and merged

License
-------

Licensed under the Apache License, Version 2.0: https://www.apache.org/licenses/LICENSE-2.0

Apache Flink, Flink®, Apache®, the squirrel logo, the Stateful Functions logo, and the Apache feather logo are either
registered trademarks or trademarks of The Apache Software Foundation.
