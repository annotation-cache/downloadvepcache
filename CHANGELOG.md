# annotation-cache/downloadvepcache: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project uses the same versioning scheme as [Ensembl VEP](https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html).

## dev

### Added

- [#29](https://github.com/annotation-cache/downloadvepcache/pull/29) - Add pre-flight CHECKSUMS verification for VEP cache download

### Changed

- [#19](https://github.com/annotation-cache/downloadvepcache/pull/19) - Update `ensemblvep/download` to `115.2`
- [#20](https://github.com/annotation-cache/downloadvepcache/pull/20) - Template update for nf-core/tools version `3.5.1`
- [#21](https://github.com/annotation-cache/downloadvepcache/pull/21) - Switch to topic channels for version reporting
- [#25](https://github.com/annotation-cache/downloadvepcache/pull/25) - Template update for nf-core/tools version `3.5.2`
- [#26](https://github.com/annotation-cache/downloadvepcache/pull/26) - Update nf-core subworkflows
- [#31](https://github.com/annotation-cache/downloadvepcache/pull/31) - Updated dependencies

### Fixed

- [#24](https://github.com/annotation-cache/downloadvepcache/pull/24) - Fix divergence between dev and main branches

### Dependencies

| Dependency      | Old       | New       |
| --------------- | --------- | --------- |
| `Nextflow`      | `25.10.4` | `26.04.0` |
| `nf-core-utils` | `0.4.0`   | `0.5.0`   |
| `nf-core`       | `3.5.2`   | `4.0.2`   |
| `nf-schema`     | `2.6.1`   | `2.7.2`   |
| `nf-test`       | `0.9.4`   | `0.9.5`   |
| `nft-utils`     | `0.0.8`   | `1.0.0`   |

### Parameters

| Old name | New name            |
| -------- | ------------------- |
| -        | preflight_check     |
| hook_url | -                   |

## [115.0](https://github.com/annotation-cache/downloadvepcache/releases/tag/115.0) - Crimson Chaussettes

- [#15](https://github.com/annotation-cache/downloadvepcache/pull/15) - Update `ensemblvep/download` to `115.0`
- [#17](https://github.com/annotation-cache/downloadvepcache/pull/17) - Minor code polishing
- [#17](https://github.com/annotation-cache/downloadvepcache/pull/17) - Prepare for `115` version of the cache, with VEP `115.0`
- [#18](https://github.com/annotation-cache/downloadvepcache/pull/18) - Fix pipeline version

## [114.2](https://github.com/annotation-cache/downloadvepcache/releases/tag/114.2) - Beige Blouse

- [#11](https://github.com/annotation-cache/downloadvepcache/pull/11) - Template update for nf-core/tools version 3.3.2
- [#12](https://github.com/annotation-cache/downloadvepcache/pull/12) - Prepare for `114` version of the cache, with VEP `114.2`
- [#14](https://github.com/annotation-cache/downloadvepcache/pull/14) - Minor code polishing

## [113](https://github.com/annotation-cache/downloadvepcache/releases/tag/113) - Burgundy Béret

- [#8](https://github.com/annotation-cache/downloadvepcache/pull/8) - Back to dev
- [#8](https://github.com/annotation-cache/downloadvepcache/pull/8) - Template update for nf-core/tools version 3.0.2
- [#9](https://github.com/annotation-cache/downloadvepcache/pull/9) - Prepare for `113` version of the cache, with VEP `113.0`

## [111](https://github.com/annotation-cache/downloadvepcache/releases/tag/111) - Carmen Culotte

- [#4](https://github.com/annotation-cache/downloadvepcache/pull/4) - Back to dev
- [#6](https://github.com/annotation-cache/downloadvepcache/pull/6) - Prepare for `111` version of the cache, with VEP `111.0`

## [110](https://github.com/annotation-cache/downloadvepcache/releases/tag/110) - Magenta Marinière

- [#2](https://github.com/annotation-cache/downloadvepcache/pull/2) - Build for `110` version of the cache, with VEP `110.0`
- [#1](https://github.com/annotation-cache/downloadvepcache/pull/1) - Initial release of annotation-cache/downloadvepcache, created with the [nf-core](https://nf-co.re/) template.
