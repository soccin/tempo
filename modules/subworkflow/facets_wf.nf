include { DoFacets }                   from '../process/Facets/DoFacets' 
include { DoFacetsPreviewQC }          from '../process/Facets/DoFacetsPreviewQC' 

workflow facets_wf
{
  take:
    bamFiles

  main:
    referenceMap = params.referenceMap
    targetsMap   = params.targetsMap
    
    DoFacets(
      bamFiles, 
      referenceMap.facetsVcf,
      workflow.projectDir + "/containers/facets-suite-preview-htstools"  
    )

    DoFacetsPreviewQC(DoFacets.out.Facets4FacetsPreview)

    DoFacets.out.FacetsRunSummary.combine(DoFacetsPreviewQC.out.FacetsPreviewOut, by:[0,1]).set{ FacetsQC4Aggregate }      // idTumor, idNormal, summaryFiles, qcFiles
    DoFacets.out.FacetsRunSummary.combine(DoFacetsPreviewQC.out.FacetsPreviewOut, by:[0,1]).set{ FacetsQC4SomaticMultiQC } // idTumor, idNormal, summaryFiles, qcFiles
    FacetsQC4Aggregate.map{ idTumor, idNormal, summaryFiles, qcFiles ->
      ["placeholder",idTumor, idNormal, summaryFiles, qcFiles]
    }.set{ FacetsQC4Aggregate }

  emit:
    snpPileupOutput            = DoFacets.out.snpPileupOutput
    FacetsOutput               = DoFacets.out.FacetsOutput
    facets4Aggregate           = DoFacets.out.facets4Aggregate
    facetsPurity               = DoFacets.out.facetsPurity
    facetsForMafAnno           = DoFacets.out.facetsForMafAnno
    Facets4FacetsPreview       = DoFacets.out.Facets4FacetsPreview
    FacetsArmGeneOutput        = DoFacets.out.FacetsArmGeneOutput
    FacetsQC4MetaDataParser    = DoFacets.out.FacetsQC4MetaDataParser
    FacetsRunSummary           = DoFacets.out.FacetsRunSummary
    FacetsPreviewOut           = DoFacetsPreviewQC.out.FacetsPreviewOut
    FacetsQC4Aggregate         = FacetsQC4Aggregate
    FacetsQC4SomaticMultiQC    = FacetsQC4SomaticMultiQC
    FacetsCNV4HrDetect         = DoFacets.out.FacetsCNV4HrDetect
    FacetsCNV4HrDetectFiltered = DoFacets.out.FacetsCNV4HrDetectFiltered
    FacetsSampleStatistics4BRASS = DoFacets.out.FacetsSampleStatistics4BRASS
}
