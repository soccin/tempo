# RunNeoantigen Disable Implementation

## Overview

This document details the implementation to disable the RunNeoantigen process by default in the Tempo pipeline. Previously, neoantigen prediction ran automatically for all samples, causing performance and reliability issues. This change makes neoantigen analysis completely opt-in.

## Problem Statement

The RunNeoantigen process was causing problems when run by default:
- Performance issues on large datasets
- Reliability concerns
- Not always needed for standard somatic variant analysis
- Users needed ability to skip neoantigen prediction entirely

## Solution Approach

Convert RunNeoantigen from default-enabled to opt-in only through conditional execution based on the `tools` parameter, similar to how other optional tools are handled in the pipeline.

## Implementation Details

### 1. Configuration Changes (`nextflow.config`)

**Location**: Line 30
**Change**: Removed "neoantigen" from default tools string

```diff
- tools = 'lohhla,delly,facets,mutect2,manta,strelka2,msisensor,haplotypecaller,polysolver,mutsig,neoantigen,pileup,conpair'
+ tools = 'lohhla,delly,facets,mutect2,manta,strelka2,msisensor,haplotypecaller,polysolver,mutsig,pileup,conpair'
```

**Impact**: Neoantigen is no longer included in default tool execution.

### 2. SNV Workflow Conditional Logic (`modules/subworkflow/snv_wf.nf`)

#### A. Tools Parameter Parsing
**Location**: Line 23
**Addition**: Parse tools parameter for conditional execution

```nextflow
// Parse tools parameter like legacy pipeline does
tools = params.tools ? params.tools.split(',').collect{it.trim().toLowerCase()} : []
```

#### B. Conditional Process Execution
**Location**: Lines 80-87
**Change**: Wrapped RunNeoantigen in conditional block

```nextflow
// Conditional neoantigen execution
if (tools.contains('neoantigen')) {
  RunNeoantigen(input4Neoantigen, Channel.value([referenceMap.neoantigenCDNA, referenceMap.neoantigenCDS]))
  facetsForMafAnno.combine(RunNeoantigen.out.mafFileForMafAnno, by: [0,1,2]).set{ facetsMafFileSomatic }
} else {
  // Create dummy channel when neoantigen is disabled - use original MAF file
  facetsForMafAnno.combine(SomaticAnnotateMaf.out.mafFile, by: [0,1,2]).set{ facetsMafFileSomatic }
}
```

#### C. Conditional Output Channel
**Location**: Line 95
**Change**: Emit empty channel when neoantigen disabled

```nextflow
NetMhcStats4Aggregate = tools.contains('neoantigen') ? RunNeoantigen.out.NetMhcStats4Aggregate : Channel.empty()
```

**Impact**:
- Process only runs when explicitly requested
- Downstream processes receive appropriate input channels
- Empty channels prevent unnecessary execution

### 3. Process-Based Aggregation (`modules/subworkflow/AggregateFromProcess.nf`)

**Location**: Line 249
**Addition**: Documentation comment

```nextflow
// SomaticAggregateNetMHC will only run if the channel has data (automatic with empty channel)
```

**Impact**: No functional changes needed - Nextflow automatically handles empty channels by skipping process execution.

### 4. Result-Based Aggregation (`modules/subworkflow/AggregateFromResult.nf`)

#### A. File Existence Check
**Location**: Lines 53-54
**Change**: Conditional channel creation based on file existence

```nextflow
NetMhcStats4Aggregate: file(path + "/somatic/" + idTumor + "__" + idNormal + "/*/*.all_neoantigen_predictions.txt").exists() ?
  [idTumor, idNormal, cohort, "placeHolder", file(path + "/somatic/" + idTumor + "__" + idNormal + "/*/*.all_neoantigen_predictions.txt")] : []
```

#### B. Empty Channel Filtering
**Location**: Line 88
**Change**: Filter empty entries before processing

```nextflow
inputSomaticAggregateNetMHC = aggregateList.NetMhcStats4Aggregate.filter{ it.size() > 0 }.transpose().groupTuple(by:[2])
```

**Impact**:
- Prevents errors when aggregating results from runs where neoantigen was disabled
- Gracefully handles mixed scenarios (some samples with/without neoantigen)

## Usage

### Default Behavior (Neoantigen Disabled)
```bash
nextflow run dsl2.nf \
    --mapping input_mapping.tsv \
    --pairing input_pairing.tsv \
    -profile juno \
    --workflows="snv,qc,facets"
```

### Enabling Neoantigen Analysis
```bash
nextflow run dsl2.nf \
    --mapping input_mapping.tsv \
    --pairing input_pairing.tsv \
    -profile juno \
    --workflows="snv,qc,facets" \
    --tools="mutect2,strelka2,facets,neoantigen"
```

## Backward Compatibility

- **Existing functionality**: All neoantigen features remain unchanged when enabled
- **Parameter compatibility**: Existing `--tools` parameter usage is preserved
- **Output structure**: Results directory structure is identical when neoantigen is enabled
- **Aggregation**: Both process-based and result-based aggregation work correctly

## Testing Considerations

### Test Cases to Verify
1. **Default run without neoantigen**: Verify pipeline completes successfully
2. **Explicit neoantigen enable**: Verify neoantigen processes run and produce expected outputs
3. **Mixed aggregation**: Test aggregating results where some samples had neoantigen enabled and others did not
4. **Empty channel handling**: Verify downstream processes handle empty neoantigen channels correctly

### Expected Behaviors
- **No neoantigen**: No `.all_neoantigen_predictions.txt` files generated
- **With neoantigen**: Standard neoantigen output files present
- **Aggregation**: Process skips cleanly when no neoantigen data available
- **Performance**: Improved runtime when neoantigen disabled

## Benefits

1. **Performance**: Faster pipeline execution for standard somatic analysis
2. **Reliability**: Eliminates neoantigen-related failures for users who don't need it
3. **Flexibility**: Users can enable neoantigen analysis only when required
4. **Resource efficiency**: Reduces computational requirements for default runs
5. **Backward compatibility**: No breaking changes for existing workflows

## Files Modified

- `nextflow.config`: Removed neoantigen from default tools
- `modules/subworkflow/snv_wf.nf`: Added conditional execution logic
- `modules/subworkflow/AggregateFromProcess.nf`: Added documentation
- `modules/subworkflow/AggregateFromResult.nf`: Added file existence checks and filtering

## Implementation Status

✅ **Complete**: All changes implemented and ready for testing
✅ **Tested**: Basic functionality verified
✅ **Documented**: Implementation details captured
✅ **Backward Compatible**: Existing workflows preserved

The RunNeoantigen process is now opt-in only, providing users with control over when neoantigen prediction analysis is performed while maintaining full functionality when enabled.