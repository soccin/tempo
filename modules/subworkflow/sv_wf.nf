include { SomaticDellyCall }           from '../process/SV/SomaticDellyCall' 
include { DellyCombine
            as SomaticDellyCombine }   from '../process/SV/DellyCombine'
include { SomaticRunSvABA }            from '../process/SV/SomaticRunSvABA' 
include { brass_wf }                   from './brass_wf' addParams(referenceMap: params.referenceMap)
include { SomaticMergeSVs }            from '../process/SV/SomaticMergeSVs' 
include { SomaticSVVcf2Bedpe }         from '../process/SV/SomaticSVVcf2Bedpe'
include { SomaticAnnotateSVBedpe }     from '../process/SV/SomaticAnnotateSVBedpe'

workflow sv_wf
{
  take:
    bamFiles
    manta4Combine
    sampleStatistics

  main:
    referenceMap = params.referenceMap
    targetsMap   = params.targetsMap

    Channel.from("DUP", "BND", "DEL", "INS", "INV").set{ svTypes }
    SomaticDellyCall(
    	svTypes, 
    	bamFiles,
	Channel.value([
		referenceMap.genomeFile, 
		referenceMap.genomeIndex, 
		referenceMap.svCallingExcludeRegions
	])
    )

    // Put manta output and delly output into the same channel so they can be processed together in the group key
    // that they came in with i.e. (`idTumor`, `idNormal`, and `target`)
  SomaticDellyCombine(
    SomaticDellyCall.out.dellyFilter4Combine
      .groupTuple(by: [0,1,2], size: 5)
      .map{tumor_id, normal_id, target, vcf, tbi ->
        [ tumor_id, normal_id, target, vcf.sort(), tbi.sort() ]
      }
    , "somatic"
  )

    if (params.assayType == "genome" && workflow.profile != "test") {
      SomaticRunSvABA(
        bamFiles,
        referenceMap.genomeFile, 
        referenceMap.genomeIndex,
        referenceMap.genomeDict,
        referenceMap.bwaIndex
      )

      brass_wf(
        bamFiles, 
        sampleStatistics // from ascat
      )
      
      SomaticDellyCombine.out
        .combine(manta4Combine, by: [0,1,2])
        .combine(SomaticRunSvABA.out.SvABA4Combine, by: [0,1,2])
        .combine(brass_wf.out.BRASS4Combine, by: [0,1,2])
        .map{ t,n,target,dellyvcf,dellytbi,mantavcf,mantatbi,svabavcf,svabatbi,brassvcf,brasstbi ->
          [t,n,target,[dellyvcf,mantavcf,svabavcf,brassvcf],[dellytbi,mantatbi,svabatbi,brasstbi],["delly","manta","svaba","brass"]]
        }.set{allSvCallsCombineChannel}
    } else {
      SomaticDellyCombine.out
        .combine(manta4Combine, by: [0,1,2])
        .map{ t,n,target,dellyvcf,dellytbi,mantavcf,mantatbi ->
          [t,n,target,[dellyvcf,mantavcf],[dellytbi,mantatbi],["delly","manta"]]
        }.set{allSvCallsCombineChannel}
    }
    
    // --- Process SV VCFs 
    // Merge VCFs
    SomaticMergeSVs(
      allSvCallsCombineChannel,
      workflow.projectDir + "/containers/bcftools-vt-mergesvvcf"
    )

    // Convert VCF to Bedpe
    SomaticSVVcf2Bedpe(
      SomaticMergeSVs.out.SVCallsCombinedVcf
    )

    // Annotate Bedpe
    SomaticAnnotateSVBedpe(
      SomaticSVVcf2Bedpe.out.SomaticCombinedUnfilteredBedpe,
      referenceMap.repeatMasker,
      referenceMap.mapabilityBlacklist,
      referenceMap.spliceSites,
      workflow.projectDir + "/containers/iannotatesv",
      params.genome
    )

  emit:
    SVAnnotBedpe         = SomaticAnnotateSVBedpe.out.SVAnnotBedpe
    SVAnnotBedpePass     = SomaticAnnotateSVBedpe.out.SVAnnotBedpePass
    sv4Aggregate         = SomaticMergeSVs.out.SVCallsCombinedVcf
}
