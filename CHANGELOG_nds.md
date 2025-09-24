# Changelog

## Branch: merge/ccs-markdup_spark 2025-09-24

### Added
- **nf-core Framework Integration**: Merged nf-core/markdup_spark branch bringing comprehensive framework standardization
  - Complete nf-core directory structure with GitHub workflows, templates, and documentation
  - Standard nf-core configuration files and schema validation
  - Integrated testing framework with nf-test and CI/CD workflows
  - Affects root directory structure and adds extensive nf-core infrastructure [`506d1c75`]

- **Spark-based MarkDuplicates**: New GATK Spark modules for improved performance
  - Added `modules/nf-core/gatk4spark/markduplicates/` with Spark-optimized duplicate marking
  - New `modules/local/gatk4spark/setnmmdanduqtags/` for NM/MD/UQ tag processing
  - Parallelized SETNMMDANDUQTAGS step with interval splitting for better performance
  - Affects alignment workflow with Spark-based BAM processing [`41d08955`, `4a1ffc91`, `11821735`]

- **BQSR Scatter/Gather Framework**: Enhanced base quality score recalibration
  - Added `modules/nf-core/gatk4/splitintervals/` for interval-based parallelization
  - New `modules/nf-core/gatk4spark/baserecalibrator/` with Spark optimization
  - Added `modules/nf-core/gatk4spark/applybqsr/` for applying recalibration
  - Comprehensive BQSR workflow with scatter/gather pattern [`e7fcdaa2`]

- **Claude Code Integration**: Documentation and guidance files
  - Added `CLAUDE.md` files for AI-assisted development
  - Checkpoint and documentation files for development workflow
  - Enhanced project structure documentation [`69a25e60`]

### Changed
- **Neoantigen Analysis**: Converted from default-enabled to opt-in only
  - Removed 'neoantigen' from default tools in `nextflow.config`
  - Added conditional execution logic in `snv_wf.nf` based on tools parameter
  - Enhanced aggregation workflows to handle empty neoantigen channels gracefully
  - Maintains backward compatibility when explicitly enabled via --tools
  - Affects `modules/subworkflow/snv_wf.nf` and aggregation workflows [`b6199634`]

- **Alignment Workflow Enhancement**: Major refactoring of BAM processing
  - Updated `modules/subworkflow/alignment_wf.nf` with Spark-based modules
  - Integrated new GATK Spark tools for markduplicates and BQSR
  - Added parallelization for tag setting and merging operations
  - Improved resource allocation and performance for large datasets [`173 lines changed`]

- **Configuration Updates**: Extended nextflow.config for nf-core compatibility
  - Added comprehensive parameter definitions and schema validation
  - Integrated nf-core base configurations and resource management
  - Enhanced container definitions and module configurations
  - Added new parameters for Spark optimization and resource control [`231 lines changed`]

### Fixed
- **Debug Code Cleanup**: Removed debugging and temporary code
  - Removed debug view commands and temporary files
  - Cleaned up development artifacts and checkpoint files
  - Streamlined codebase for production use [`833d681e`, `9f892c8a`]

- **File Organization**: Renamed and reorganized documentation
  - Renamed `CHANGELOG.md` to `CHANGELOG_nds.md` for branch-specific tracking
  - Removed temporary documentation files (`DISABLE_NEOANTI.md`, `CHECKPOINT_CLAUDE.md`)
  - Improved documentation structure and accessibility [`ed47d01d`, `e45ac557`, `113267a7`]

### Technical Details
- **Version**: 38+ commits ahead of eos-devs branch
- **Date Range**: September 2025 development cycle
- **Major Integration**: nf-core framework with Spark optimization
- **Performance Focus**: Spark-based processing for improved scalability

### Commit Summary
- **Total New Commits**: 38+ commits since eos-devs
- **Major Features**: nf-core integration, Spark optimization, neoantigen control
- **Framework Updates**: Complete nf-core standardization with testing and CI/CD
- **Performance Improvements**: Parallelized processing and Spark-based tools
- **Documentation**: Enhanced project documentation and AI integration

### Key Files Added/Modified
- **New nf-core Infrastructure**: 130+ new files for framework compliance
- **Spark Modules**: `gatk4spark/markduplicates`, `gatk4spark/applybqsr`, `gatk4spark/baserecalibrator`
- **Local Modules**: `gatk4spark/setnmmdanduqtags` for tag processing
- **Workflows**: Enhanced `alignment_wf.nf` and `snv_wf.nf`
- **Configuration**: Extensive updates to `nextflow.config` and resource configs
- **Documentation**: `CLAUDE.md`, usage documentation, and nf-core templates

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
