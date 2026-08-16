# Tempo/Adagio

This is version and update info for the TEMPO repo that is being used in Adagio version v3.x. Going forward everything the underlying TEMPO is changes we **WILL** bump the major version number. 

## Version 3 - Cordelia

- Working branch: ccs/update-250925
- Base commit: 833d681e
- Base branch: nf-core/markdup_spark
- Date: 2026-08-16

## Updates

- SvABA blacklist (`-B`) and Delly `--exclude` now use adagio-local region files.
- new profile for IRIS cluster.
- `git merge enhancement/separating_hlatyping_and_lohhla_wf`
- `resolve conflict by keeping all code (merge) and just removing conflict marks`


### SvABA and SV exclude regions
- `49773e01 fix(svaba): match -p threads to task.cpus`
- `e591a3e8 feat(svaba): add ENCODE blacklist via -B`
- Delly `--exclude` repointed to the same adagio region set (GRCh37 only)

Adds reference key `svSvABAExcludeRegions` (`conf/references.config`,
`modules/function/define_maps.nf`); `SomaticRunSvABA` and `GermlineRunSvABA`
both pass `-B`. The `-p` fix drops SvABA from `task.cpus * 2` threads to
`task.cpus` -- the cgroup capped the task at `task.cpus` anyway, so the extra
threads bought no throughput and only cost memory.

**NOTE:** these region files live in the adagio repo, not the reference tree.
The paths resolve as `${projectDir}/../rsrc/genomic/hg19/`, so tempo now
requires its parent adagio checkout. A standalone tempo clone fails at startup
in `checkParamReturnFile` for GRCh37.

Known open issues in these modules: `adagio/bugs/BUG_REPORT_SvABA.md`.

### Iris Profile
- `c7a3a026 feat(iris): add iris profile configuration`

### SV-Callers re-updates
- `git merge upstream/feature/upgrade_delly_v126`
- `git merge upstream/update/svaba`

### Neoantigen
- `git merge upstream/enhancement/neoantigen_parallel`

### NDS Patches:
- git merge patch/01-maxRecsInRam (memory optimization for markDups)

Two patches to "fix" markDups memory usage:
- `git am adagio/patches/0001-Add-default-max_records_in_ram-parameter-to-juno.con.patch`
- `git am adagio/patches/0002-Update-MergeBamsAndMarkDuplicates-process-to-use-par.patch`
