#!/usr/bin/env nextflow

/*
================================================================================
--------------------------------------------------------------------------------
 Processes overview
 - AlignReads - Map reads with BWA mem output SAM
 - ConvertSAMtoBAM - Convert SAM to BAM with samtools
 - SortBAM - Sort BAM with samtools
 - MarkDuplicates - Mark Duplicates with GATK4
 - CreateRecalibrationTable - Create Recalibration Table with BaseRecalibrator
 - RecalibrateBam - Recalibrate Bam with PrintReads
*/

/*
================================================================================
=                           C O N F I G U R A T I O N                          =
================================================================================
*/

// tsvPath 


// Evan comment: this is a silly thing to keep, 
// but it reminds me that this could be so much more flexible with complex conditionals

tsvPath = ''
if (params.sample) tsvPath = params.sample

referenceMap = defineReferenceMap()

fastqFiles = Channel.empty()

tsvFile = file(tsvPath)

fastqFiles = extractFastq(tsvFile)

/*
================================================================================
=                               P R O C E S S E S                              =
================================================================================
*/

// tag
// https://www.nextflow.io/docs/latest/process.html#tag
// The tag directive allows you to associate each process executions with a custom label, 
// so that it will be easier to identify them in the log file or in the trace execution report.

// AlignReads - Map reads with BWA mem output SAM

process AlignReads {
  tag {idPatient + "-" + idRun}   // The tag directive allows you to associate each process executions with a custom label

  input:
    set idPatient, gender, status, idSample, idRun, file(fastqFile1), file(fastqFile2) from fastqFiles
    set file(genomeFile), file(bwaIndex) from Channel.value([referenceMap.genomeFile, referenceMap.bwaIndex])

  output:
    set idPatient, status, idSample, idRun, file("${idRun}.sam") into (alignedSam)

  script:
  readGroup = "@RG\\tID:Seq01p\\tSM:Seq01\\tPL:ILLUMINA\\tPI:330"
  """
  bwa mem -R \"${readGroup}\" -t ${task.cpus} -M ${genomeFile} ${fastqFile1} ${fastqFile2} > ${idRun}.sam
  """
}

// ConvertSAMtoBAM - Convert SAM to BAM with samtools, 'samtools view'

process ConvertSAMtoBAM {
  tag {idPatient + "-" + idSample}

  input:
    set idPatient, status, idSample, idRun, file("${idRun}.sam") from alignedSam

  output:
    set idPatient, status, idSample, idRun, file("${idRun}.bam") into unsortedBam

  script:
  """
  samtools view -S -b -@ ${task.cpus} ${idRun}.sam > ${idRun}.bam
  """
}

// SortBAM - Sort unsorted BAM with samtools, 'samtools sort'
// samtools sort
// setting these parameters as fixed `-m 2G` 

process SortBAM {
  tag {idPatient + "-" + idSample}

  input:
    set idPatient, status, idSample, idRun, file("${idRun}.bam") from unsortedBam

  output:
    set idPatient, status, idSample, idRun, file("${idRun}.sorted.bam") into sortedBam

  script:
  // Refactor when https://github.com/nextflow-io/nextflow/pull/1035 is merged
  if(params.mem_per_core) { 
    mem = task.memory.toString().split(" ")[0]
  }
  else {
    mem = task.memory.toString().split(" ")[0].toInteger()/task.cpus
  }
  """
  samtools sort -m ${mem}G -@ ${task.cpus} -o ${idRun}.sorted.bam ${idRun}.bam
  """
}

singleBam = Channel.create()
groupedBam = Channel.create()
sortedBam.groupTuple(by:[0,1,2])
  .choice(singleBam, groupedBam) {it[3].size() > 1 ? 1 : 0}
singleBam = singleBam.map {
  idPatient, status, idSample, idRun, bam ->
  [idPatient, status, idSample, bam]
}

process MergeBams {
  tag {idPatient + "-" + idSample}

  input:
    set idPatient, status, idSample, idRun, file(bam) from groupedBam

  output:
    set idPatient, status, idSample, idRun, file("${idSample}.merged.bam") into mergedBam

  // when: step == 'mapping' && !params.onlyQC

  script:
  """
  samtools merge --threads ${task.cpus} ${idSample}.merged.bam ${bam.join(" ")}
  """
}

if (params.verbose) singleBam = singleBam.view {
  "Single BAM:\n\
  ID    : ${it[0]}\tStatus: ${it[1]}\tSample: ${it[2]}\n\
  File  : [${it[4].fileName}]"
}

if (params.verbose) mergedBam = mergedBam.view {
  "Merged BAM:\n\
  ID    : ${it[0]}\tStatus: ${it[1]}\tSample: ${it[2]}\n\
  File  : [${it[4].fileName}]"
}

mergedBam = mergedBam.mix(singleBam)

if (params.verbose) mergedBam = mergedBam.view {
  "BAM for MarkDuplicates:\n\
  ID    : ${it[0]}\tStatus: ${it[1]}\tSample: ${it[2]}\n\
  File  : [${it[4].fileName}]"
}

// GATK MarkDuplicates

process MarkDuplicates {
  tag {idPatient + "-" + idSample}

  // The publishDir directive allows you to publish the process output files to a specified folder

  // publishDir params.outDir, mode: params.publishDirMode,
  //  saveAs: {
  //    if (it == "${idRun}.bam.metrics") "${directoryMap.markDuplicatesQC.minus(params.outDir+'/')}/${it}"
  //    else "${directoryMap.duplicateMarked.minus(params.outDir+'/')}/${it}"
  //  }

  // when: step == 'mapping' && !params.onlyQC

  input:
    set idPatient, status, idSample, idRun, file("${idSample}.merged.bam") from mergedBam

  output:
    set idPatient, file("${idSample}_${status}.md.bam"), file("${idSample}_${status}.md.bai"), idSample, idRun into duplicateMarkedBams
    set idPatient, status, idSample, val("${idSample}_${status}.md.bam"), val("${idSample}_${status}.md.bai") into markDuplicatesTSV
    file ("${idSample}.bam.metrics") into markDuplicatesReport

  script:
  """
  gatk MarkDuplicates --java-options ${params.markdup_java_options}  \
    --MAX_RECORDS_IN_RAM 50000 \
    --INPUT ${idSample}.merged.bam \
    --METRICS_FILE ${idSample}.bam.metrics \
    --TMP_DIR . \
    --ASSUME_SORT_ORDER coordinate \
    --CREATE_INDEX false \
    --OUTPUT ${idSample}_${status}.md.bam
  """
}

duplicateMarkedBams = duplicateMarkedBams.map {
    idPatient, bam, bai, idSample, idRun ->
    tag = bam.baseName.tokenize('.')[0]
    /// status   = tag[-1..-1].toInteger()  X
    status = 0
    // idSample = tag.take(tag.length()-2)
    [idPatient, status, idSample, bam, bai]
}

(mdBam, mdBamToJoin) = duplicateMarkedBams.into(2)

if (params.verbose) mdBamToJoin = mdBamToJoin.view {
  "MD Bam to Join BAM:\n\
  ID    : ${it[0]}\tStatus: ${it[1]}\tSample: ${it[2]}\n\
  File  : [${it[4].fileName}]"
}

if (params.verbose) mdBam = mdBam.view {
  "BAM for MarkDuplicates:\n\
  ID    : ${it[0]}\tStatus: ${it[1]}\tSample: ${it[2]}\n\
  File  : [${it[4].fileName}]"
}

process CreateRecalibrationTable {
  tag {idPatient + "-" + idSample}

  input:
    set idPatient, status, idSample, file(bam), file(bai) from mdBam 

    set file(genomeFile), file(genomeIndex), file(genomeDict), file(dbsnp), file(dbsnpIndex), file(knownIndels), file(knownIndelsIndex), file(intervals) from Channel.value([
      referenceMap.genomeFile,
      referenceMap.genomeIndex,
      referenceMap.genomeDict,
      referenceMap.dbsnp,
      referenceMap.dbsnpIndex,
      referenceMap.knownIndels,
      referenceMap.knownIndelsIndex,
      referenceMap.intervals,
    ])

  output:
    set idPatient, status, idSample, file("${idSample}.recal.table") into recalibrationTable
    set idPatient, status, idSample, val("${idSample}_${status}.md.bam"), val("${idSample}_${status}.md.bai"), val("${idSample}.recal.table") into recalibrationTableTSV

  script:
  known = knownIndels.collect{ "--known-sites ${it}" }.join(' ')

  """
  gatk BaseRecalibrator \
    --tmp-dir /tmp \
    --reference ${genomeFile} \
    --known-sites ${dbsnp} \
    ${known} \
    --verbosity INFO \
    --input ${bam} \
    --output ${idSample}.recal.table
  """
}

recalibrationTable = mdBamToJoin.join(recalibrationTable, by:[0, 1, 2])

process RecalibrateBam {
  tag {idPatient + "-" + idSample}

  // The publishDir directive allows you to publish the process output files to a specified folder
  publishDir params.outDir, mode: params.publishDirMode

  input:
    set idPatient, status, idSample, file(bam), file(bai), file(recalibrationReport) from recalibrationTable

    set file(genomeFile), file(genomeIndex), file(genomeDict), file(intervals) from Channel.value([
      referenceMap.genomeFile,
      referenceMap.genomeIndex,
      referenceMap.genomeDict,
      referenceMap.intervals,
    ])

  output:
    set idPatient, status, idSample, file("${idSample}.recal.bam"), file("${idSample}.recal.bai") into recalibratedBam, recalibratedBamForStats
    set idPatient, status, idSample, val("${idSample}.recal.bam"), val("${idSample}.recal.bai") into recalibratedBamTSV

  script:
  """
  gatk ApplyBQSR \
    --reference ${genomeFile} \
    --create-output-bam-index true \
    --bqsr-recal-file ${recalibrationReport} \
    --input ${bam} \
    --output ${idSample}.recal.bam
  """
}

/*
================================================================================
=                               AWESOME FUNCTIONS                             =
================================================================================
*/

def checkParamReturnFile(item) {
  params."${item}" = params.genomes[params.genome]."${item}"
  return file(params."${item}")
}

def defineReferenceMap() {
  if (!(params.genome in params.genomes)) exit 1, "Genome ${params.genome} not found in configuration"
  return [
    'dbsnp'            : checkParamReturnFile("dbsnp"),
    'dbsnpIndex'       : checkParamReturnFile("dbsnpIndex"),
    // genome reference dictionary
    'genomeDict'       : checkParamReturnFile("genomeDict"),
    // FASTA genome reference
    'genomeFile'       : checkParamReturnFile("genomeFile"),
    // genome .fai file
    'genomeIndex'      : checkParamReturnFile("genomeIndex"),
    // BWA index files
    'bwaIndex'         : checkParamReturnFile("bwaIndex"),
    // intervals file for spread-and-gather processes
    'intervals'        : checkParamReturnFile("intervals"),
    // VCFs with known indels (such as 1000 Genomes, Mill’s gold standard)
    'knownIndels'      : checkParamReturnFile("knownIndels"),
    'knownIndelsIndex' : checkParamReturnFile("knownIndelsIndex"),
  ]
}

def extractFastq(tsvFile) {
  // Channeling the TSV file containing FASTQ.
  // Format is: "subject gender status sample lane fastq1 fastq2"
  Channel.from(tsvFile)
  .splitCsv(sep: '\t')
  .map { row ->
    SarekUtils.checkNumberOfItem(row, 7)
    def idPatient  = row[0]
    def gender     = row[1]
    def status     = SarekUtils.returnStatus(row[2].toInteger())
    def idSample   = row[3]
    def idRun      = row[4]
    def fastqFile1 = SarekUtils.returnFile(row[5])
    def fastqFile2 = SarekUtils.returnFile(row[6])

    SarekUtils.checkFileExtension(fastqFile1,".fastq.gz")
    SarekUtils.checkFileExtension(fastqFile2,".fastq.gz")

    [idPatient, gender, status, idSample, idRun, fastqFile1, fastqFile2]
  }
}
