process QcQualimap {
  tag "${idSample}"
  
  publishDir "${params.outDir}/bams/${idSample}/qualimap", mode: params.publishDirMode, pattern: "*.{html,tar.gz}"
  publishDir "${params.outDir}/bams/${idSample}/qualimap", mode: params.publishDirMode, pattern: "*/*"

  input:
    tuple val(idSample), val(target), path(bam), path(bai), path(targetsBed)

  output:
    tuple val(idSample), path("${idSample}_qualimap_rawdata.tar.gz"), emit: qualimap4Process
    tuple val(idSample), path("*.html"), path("css/*"), path("images_qualimapReport/*"), emit: qualimapOutput
  

  script:
  if (params.assayType == "exome"){
    gffOptions = "-gff ${targetsBed}"
    nr = 750
    nw = 300
  } else { 
    gffOptions = "-gd HUMAN" 
    nr = 500
    nw = 300
  }
  availMem = task.cpus * task.memory.toString().split(" ")[0].toInteger()
  // javaMem = availMem > 20 ? availMem - 4 : ( availMem > 10 ? availMem - 2 : ( availMem > 1 ? availMem - 1 : 1 ))
  javaMem = availMem > 20 ? (availMem * 0.75).round() : ( availMem > 1 ? availMem - 1 : 1 )
  if (workflow.profile == "juno") {
    if (bam.size() > 200.GB) {
      task.time = { params.maxWallTime }
    }
    else if (bam.size() < 100.GB) {
      task.time = task.exitStatus.toString() in params.wallTimeExitCode ? { params.medWallTime } : { params.minWallTime }
    }
    else {
      task.time = task.exitStatus.toString() in params.wallTimeExitCode ? { params.maxWallTime } : { params.medWallTime }
    }
    task.time = task.attempt < 3 ? task.time : { params.maxWallTime }
  }
  //
  // --skipQualimap: emit the declared outputs without running qualimap bamqc.
  //
  // qualimap bamqc is structurally serial and runs 19-25h on a deep WGS BAM,
  // then OOMs on the largest ones: BamStats.insertSizeArray retains one boxed
  // Integer per read (~24 bytes) for the whole run and sorts it at the end
  // purely to report a median that MultiQC recomputes for itself from
  // insert_size_histogram.txt. Nothing in the caller path (snv, sv, facets,
  // mutsig) consumes any of it, and QcConpair publishes its own concordance
  // and contamination files independently of this process.
  //
  // The stub must be a VALID empty tar, not a touched file: all three MultiQC
  // processes open with `tar -xzf` over *_qualimap_rawdata.tar.gz, and a
  // zero-byte archive exits 2 and kills them. `--files-from /dev/null` gives a
  // 45-byte archive that extracts cleanly to nothing. The html/css/images
  // stubs exist only to satisfy the qualimapOutput declaration, which has no
  // consumer in the DSL2 path.
  //
  // Downstream effect: SampleRunMultiQC and SomaticRunMultiQC still run and
  // still carry conpair, facets and alfred content; they lose the Coverage,
  // % Aligned, Error rate and Ins. size columns and the qualimap plots.
  // NOTE the % Aligned criterion disappears silently from QC_Status rather
  // than failing -- general_stats_parse.py skips absent columns and defaults
  // sampleStatus to "pass". Conpair criteria are unaffected.
  //
  if (params.skipQualimap)
  """
  mkdir -p css images_qualimapReport
  echo "QcQualimap skipped: params.skipQualimap = true" > css/placeholder.txt
  echo "QcQualimap skipped: params.skipQualimap = true" > images_qualimapReport/placeholder.txt
  echo "<html><body><p>QcQualimap was skipped (params.skipQualimap = true).</p></body></html>" > ${idSample}_qualimapReport.html
  tar -czf ${idSample}_qualimap_rawdata.tar.gz --files-from /dev/null
  """
  else
  """
  qualimap bamqc \
  -bam ${bam} \
  ${gffOptions} \
  -outdir ${idSample} \
  -nt ${ task.cpus } \
  -nw ${nw} \
  -nr ${nr} \
  --java-mem-size=${javaMem}G

  mv ${idSample}/* . 
  tar -czf ${idSample}_qualimap_rawdata.tar.gz genome_results.txt raw_data_qualimapReport/* 
  """
}
