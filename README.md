# OpenBSD Ports

Documentation for the ports tree: [ports(7)](http://man.openbsd.org/ports),
[packages(7)](http://man.openbsd.org/packages),
[mirroring-ports(7)](http://man.openbsd.org/mirroring-ports),
[library-specs(7)](http://man.openbsd.org/library-specs),
[bsd.port.mk(5)](http://man.openbsd.org/bsd.port.mk),
[bsd.port.arch.mk(5)](https://man.openbsd.org/bsd.port.arch.mk),
[port-modules(5)](https://man.openbsd.org/port-modules).

[dpb(1)](https://man.openbsd.org/dpb), [bulk(8)](https://man.openbsd.org/bulk) for bulk builds.

See also the [OpenBSD Porter's Handbook](http://www.openbsd.org/faq/ports/).

## Using GitHub for ports development

```
$ git clone git@github.com:openbsd/ports
$ cd ports
$ git config core.hooksPath .hooks
# Shut up and hack!
```

This will enable a set of pre-commit hooks that do various checks to make sure
a port is in order.
