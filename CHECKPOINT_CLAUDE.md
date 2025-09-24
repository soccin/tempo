# RunNeoantigen Disable Implementation Summary

## Context
User requested to disable RunNeoantigen process by default for both exome and WGS samples due to causing problems. The goal was to make it completely opt-in only.

## Implementation Completed
Successfully converted RunNeoantigen from default-enabled to opt-in only via tools parameter.

## Files Modified

### 1. `nextflow.config` (line 30)
- **Removed** "neoantigen" from default tools string
- **Before**: `tools = 'lohhla,delly,facets,mutect2,manta,strelka2,msisensor,haplotypecaller,polysolver,mutsig,neoantigen,pileup,conpair'`
- **After**: `tools = 'lohhla,delly,facets,mutect2,manta,strelka2,msisensor,haplotypecaller,polysolver,mutsig,pileup,conpair'`

### 2. `modules/subworkflow/snv_wf.nf`
- **Added** tools parameter parsing (line 23): `tools = params.tools ? params.tools.split(',').collect{it.trim().toLowerCase()} : []`
- **Made RunNeoantigen conditional** (lines 80-87): Wrapped in `if (tools.contains('neoantigen'))` block
- **Added fallback** for SomaticFacetsAnnotation when neoantigen disabled
- **Modified emit section** (line 95): `NetMhcStats4Aggregate = tools.contains('neoantigen') ? RunNeoantigen.out.NetMhcStats4Aggregate : Channel.empty()`

### 3. `modules/subworkflow/AggregateFromProcess.nf`
- **Added comment** (line 249) about automatic empty channel handling
- No functional changes needed - empty channels automatically prevent process execution

### 4. `modules/subworkflow/AggregateFromResult.nf`
- **Made NetMhcStats4Aggregate conditional** (lines 53-54): Check if neoantigen files exist before including
- **Added filtering** (line 88): `filter{ it.size() > 0 }` to prevent processing empty channels

## Result
- **Default behavior**: RunNeoantigen completely disabled
- **To enable**: User must add `--tools="snv,qc,facets,neoantigen"` (or whatever combination they want)
- **Backward compatible**: All existing functionality preserved when enabled
- **Clean handling**: Empty channels prevent downstream errors

## Status
Implementation complete and tested. Ready for user to enable neoantigen only when explicitly needed.