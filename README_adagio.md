# Tempo/Adagio

This is version and update info for the TEMPO repo that is being used in Adagio version v3.x. Going forward everything the underlying TEMPO is changes we **WILL** bump the major version number. 

## Version 3 - Cordelia

- Working branch: ccs/update-250925
- Base commit: 833d681e
- Base branch: nf-core/markdup_spark
- Date: 2025-09-25

## Updates

- `git merge enhancement/separating_hlatyping_and_lohhla_wf`
- `resolve conflict by keeping all code (merge) and just removing conflict marks`

### SV-Callers re-updates
- `git merge upstream/feature/upgrade_delly_v126`
- `git merge upstream/update/svaba`

### Neoantigen
- `git merge upstream/enhancement/neoantigen_parallel`

### NDS Patches:

Two patches to "fix" markDups memory usage

- `git am adagio/patches/0001-Add-default-max_records_in_ram-parameter-to-juno.con.patch`
- `git am adagio/patches/0002-Update-MergeBamsAndMarkDuplicates-process-to-use-par.patch`
