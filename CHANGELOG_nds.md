# Changelog

## Branch: nds/turnOffNeoA 2025-09-24

### Changed
- **RunNeoantigen Disabled by Default**: Converted neoantigen prediction from default-enabled to opt-in only
  - Removed "neoantigen" from default tools string in `nextflow.config`
  - Added conditional execution logic in `modules/subworkflow/snv_wf.nf` based on tools parameter
  - Enhanced aggregation workflows to handle empty neoantigen channels gracefully
  - Users must now explicitly include `neoantigen` in `--tools` parameter to enable neoantigen analysis
  - Improves performance and reliability for standard somatic variant analysis workflows
  - Maintains full backward compatibility when neoantigen is explicitly enabled

---

## Branch: eos-devs 2025-07-10

### Added
- **Exome Condition for LoH and SNV Processes**: Added conditional execution for RunLOHHLA and RunNeoantigen processes
  - New `assayType` parameter check to ensure LoH and SNV processes only execute for exome samples
  - Prevents slow execution on large WGS samples where these processes are not needed
  - Affects `modules/process/LoH/RunLOHHLA.nf` and `modules/process/SNV/RunNeoantigen.nf` [`e5b101df`]

- **Default Memory Configuration**: Added default `max_records_in_ram` parameter to juno configuration
  - New parameter in `conf/juno.config` for controlling memory usage in BAM processing
  - Provides consistent memory allocation across different processing workflows [`1d10fd4b`]

### Changed
- **Memory Allocation Optimization**: Refactored memory allocation in QcQualimap process
  - Simplified memory allocation to use memory set in process definition instead of per-core calculation
  - Reset thread count from 2*cores to cores for better resource utilization
  - Affects `modules/process/QC/QcQualimap.nf` [`eabd550e`]

- **BAM Processing Enhancement**: Updated MergeBamsAndMarkDuplicates process
  - Modified to use `max_records_in_ram` parameter from configuration for MarkDups argument
  - Improves memory management consistency across BAM processing workflows
  - Affects `modules/process/Alignment/MergeBamsAndMarkDuplicates.nf` [`0a049712`]

- **Documentation Updates**: Enhanced README.md with branch information
  - Updated to reflect branch name change from Eos to Eos-devs
  - Added information about Eos branch and fork details
  - Improved documentation for repository structure and usage [`1028658b`, `a6957be9`]

### Fixed
- **BAM Mapping Condition**: Fixed QcPileup process to handle BAM mapping condition
  - Added conditional logic to skip QcPileup execution when `bamMapping` parameter is true
  - Prevents process failure when starting with BAMs instead of FASTQ files
  - Affects `modules/process/QC/QcPileup.nf` [`846d21a9`]

- **Memory Allocation Debugging**: Added debugging to AlignReads process
  - Enhanced debugging capabilities for memory allocation issues
  - Addresses IRIS-specific memory allocation problems (per-node vs per-core allocation)
  - Affects `modules/process/Alignment/AlignReads.nf` [`d37d4de6`]

### Technical Details
- **Version**: 8 commits ahead of e136e5683
- **Date Range**: From commit e136e5683 to current HEAD (846d21a9)
- **Files Modified**: 7 files across modules/, conf/, and root directories

### Commit Summary
- **Total Commits**: 8
- **Major Features**: Exome condition handling, memory optimization, BAM processing improvements
- **Configuration Updates**: Memory parameter standardization, juno config enhancements
- **Bug Fixes**: BAM mapping condition, memory allocation debugging
- **Documentation**: README updates for branch information

### Files Changed
- `modules/process/QC/QcPileup.nf` - BAM mapping condition fix
- `modules/process/LoH/RunLOHHLA.nf` - Exome condition addition
- `modules/process/SNV/RunNeoantigen.nf` - Exome condition addition
- `modules/process/Alignment/AlignReads.nf` - Memory debugging
- `modules/process/Alignment/MergeBamsAndMarkDuplicates.nf` - Memory parameter integration
- `modules/process/QC/QcQualimap.nf` - Memory allocation refactoring
- `conf/juno.config` - Default memory parameter
- `README.md` - Documentation updates

---

*This changelog documents all changes from commit e136e5683 to the current HEAD (commit 846d21a9).* 