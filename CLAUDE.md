# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Tempo is a Nextflow-based computational pipeline for processing paired-end whole-exome (WES) and whole-genome sequencing (WGS) of human cancer samples with matched normals. The pipeline is containerized and designed to run on Juno HPC cluster at MSKCC and on AWS.

## Repository Structure and Architecture

### Main Pipeline Files
- **dsl2.nf**: Main Nextflow pipeline script (DSL2 syntax)
- **pipeline.nf**: Legacy DSL1 pipeline (deprecated)
- **nextflow.config**: Main configuration file with profiles and parameters

### Key Architecture Components

**Sub-workflows (`modules/subworkflow/`)**:
- `alignment_wf`: Read alignment and BAM processing
- `snv_wf`: Somatic SNV/indel detection (Mutect2, Strelka2)
- `sv_wf`: Somatic structural variant detection (Delly, Manta, SvABA)
- `germlineSNV_wf`: Germline SNV calling (HaplotypeCaller, Strelka2)
- `germlineSV_wf`: Germline structural variant detection
- `facets_wf`: Copy number analysis with FACETS
- `loh_wf`: Loss of heterozygosity analysis (LOHHLA)
- `sampleQC_wf`: Quality control metrics and MultiQC reporting
- `mutSig_wf`: Mutational signature analysis

**Process Modules (`modules/process/`)**:
Organized by functional category:
- `Alignment/`: BWA alignment, BQSR, MarkDuplicates
- `SNV/`: Mutect2, Strelka2, annotation with VCF2MAF
- `SV/`: Delly, Manta, SvABA structural variant callers
- `QC/`: Qualimap, Conpair, CollectHsMetrics, MultiQC
- `Facets/`: FACETS copy number analysis
- `LoH/`: LOHHLA and Polysolver HLA typing

**Configuration (`conf/`)**:
- Profile-specific configs: `juno.config`, `awsbatch.config`
- Resource allocation: `resources_*.config` files for different environments
- Container definitions: `containers.config`
- Reference files: `references.config`
- Assay-specific: `exome.config`, `genome.config`

## Common Commands

### Running the Pipeline

**Basic command structure:**
```bash
nextflow run dsl2.nf \
    --mapping input_mapping.tsv \
    --pairing input_pairing.tsv \
    -profile juno \
    --assayType exome \
    --workflows="snv,qc,facets" \
    --outDir results/
```

**Key parameters:**
- `--mapping`: TSV file with FASTQ file paths and sample metadata
- `--bamMapping`: Alternative for starting with BAM files
- `--pairing`: TSV file defining tumor-normal pairs
- `--assayType`: Either "exome" or "genome"
- `--workflows`: Comma-separated list of sub-workflows to run
- `-profile`: Execution environment (juno, awsbatch, docker, singularity)

**Common workflow combinations:**
```bash
# Full somatic analysis
--workflows="snv,sv,facets,qc,msisensor"

# QC only
--workflows="qc"

# Somatic + germline
--workflows="snv,sv,germSNV,germSV,facets,qc"

# Analysis with aggregation
--workflows="snv,facets" --aggregate true
```

### Development and Testing

**Test run:**
```bash
nextflow run dsl2.nf -profile test_singularity --workflows="snv,qc"
```

**Resume failed run:**
```bash
nextflow run dsl2.nf -resume [original parameters]
```

**Generate execution reports:**
```bash
nextflow run dsl2.nf [parameters] -with-timeline -with-report
```

## Branch-Specific Information (eos-devs)

This branch includes WGS-specific optimizations:

### Key Optimizations
- **Conditional execution**: LoH (LOHHLA) and neoantigen processes only run for exome samples
- **Memory management**: Standardized memory parameters across BAM processing workflows
- **WGS performance**: Optimized resource allocation for large WGS datasets

### Configuration Changes
- Added `max_records_in_ram` parameter in juno.config
- Memory allocation optimizations in QcQualimap and MergeBamsAndMarkDuplicates
- Fixed BAM mapping conditions in QcPileup

## Input File Formats

### Mapping File (--mapping)
TSV format with columns: SAMPLE_ID, LANE_ID, FASTQ_PE1, FASTQ_PE2, LIBRARY_ID, RUN_ID, PLATFORM, PLATFORM_UNIT, CENTER, TARGET

### Pairing File (--pairing)
TSV format with columns: SAMPLE_ID, TUMOR_ID, NORMAL_ID, COHORT

### BAM Mapping File (--bamMapping)
TSV format with columns: SAMPLE_ID, BAM, BAI, TARGET

## Environment Setup

### Juno Cluster
```bash
export NXF_SINGULARITY_CACHEDIR=/juno/work/taylorlab/cmopipeline/singularity_images
export TMPDIR=/scratch/username
module load singularity/3.1.1
```

### Reference Files
- Base path: `/juno/work/tempo/cmopipeline` (juno profile)
- Genome versions supported: GRCh37 (primary), GRCh38 (limited), smallGRCh37 (testing)
- Container registry: `cmopipeline/*` on Docker Hub

## Output Organization

Results are organized by sample and analysis type:
- `alignment/`: BAM files and alignment QC
- `somatic/`: Somatic variant calls and annotations
- `germline/`: Germline variant calls
- `facets/`: Copy number analysis results
- `qc/`: Quality control reports and MultiQC summaries
- `cohort_level/`: Aggregated results across samples

## Key Development Considerations

- Pipeline uses Nextflow DSL2 syntax
- All processes are containerized using Singularity on Juno
- Resource allocation varies by assay type (exome vs genome)
- The eos-devs branch contains optimizations for WGS processing
- Configuration is environment-specific via Nextflow profiles
- Extensive documentation is available in the `docs/` directory

## Testing

Test inputs are provided in `test_inputs/` directory. Use `-profile test_singularity` for testing on Juno.

## Performance Considerations

- **WGS samples**: Use `--assayType genome` for appropriate resource allocation
- **Exome samples**: Default `--assayType exome` is optimized for smaller datasets
- **Memory management**: BAM processing uses configurable `max_records_in_ram` parameter
- **Conditional execution**: Some processes (LOHHLA, neoantigen) skip automatically for WGS to avoid performance issues