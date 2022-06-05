# Tags management

If you need to tag:

```shell
git tag -a 1.0.0 -m "First version"
git push origin --tags
```

If you need to delete the tag:

```shell
git tag -d 1.0.0
git push origin :refs/tags/1.0.0
```

Check the tags on the remote:

```shell
git ls-remote --tags
```
