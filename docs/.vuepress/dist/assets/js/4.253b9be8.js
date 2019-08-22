(window.webpackJsonp=window.webpackJsonp||[]).push([[4],{184:function(t,e,r){t.exports=r.p+"assets/img/pipeline-flowchart.ca996bb1.png"},190:function(t,e,r){"use strict";r.r(e);var n=r(0),a=Object(n.a)({},function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("ContentSlotsDistributor",{attrs:{"slot-key":t.$parent.slotKey}},[n("h1",{attrs:{id:"bioinformatics-components"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#bioinformatics-components","aria-hidden":"true"}},[t._v("#")]),t._v(" Bioinformatics Components")]),t._v(" "),n("p",[t._v("The three main functions of the pipeline are:")]),t._v(" "),n("ol",[n("li",[t._v("Sequencing read alignment")]),t._v(" "),n("li",[t._v("Somatic variant detection")]),t._v(" "),n("li",[t._v("Germline variant detection")])]),t._v(" "),n("p",[t._v("Additionally, various QC metrics are generated. Below are described the separate modules tools used. The following diagram outlines the workflow:")]),t._v(" "),n("img",{attrs:{id:"diagram",src:r(184)}}),t._v(" "),n("p",[n("small",[t._v("Note: The pipeline can be run with already-aligned BAM files as input, which avoids the first of these three modules.")])]),t._v(" "),n("h2",{attrs:{id:"read-alignment"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#read-alignment","aria-hidden":"true"}},[t._v("#")]),t._v(" Read Alignment")]),t._v(" "),n("p",[t._v("Vaporware accepts as input sequencing reads from one or multiple FASTQ file pairs (corresponding to separate sequencing lanes) per sample, as "),n("router-link",{attrs:{to:"/running-the-pipeline.html#the-mapping-file"}},[t._v("described")]),t._v(". These are aligned against the human genome using common practices, which include:")],1),t._v(" "),n("ul",[n("li",[n("strong",[t._v("Alignment")]),t._v(" using "),n("a",{attrs:{href:"http://bio-bwa.sourceforge.net/",target:"_blank",rel:"noopener noreferrer"}},[t._v("BWA mem"),n("OutboundLink")],1),t._v(", followed by conversion to BAM file format and sorting using "),n("a",{attrs:{href:"https://samtools.github.io",target:"_blank",rel:"noopener noreferrer"}},[t._v("samtools"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("Merging")]),t._v(" of BAM files across sequencing lanes using "),n("a",{attrs:{href:"https://samtools.github.io",target:"_blank",rel:"noopener noreferrer"}},[t._v("samtools"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("PCR-duplicate marking")]),t._v(" using "),n("a",{attrs:{href:"https://software.broadinstitute.org/gatk",target:"_blank",rel:"noopener noreferrer"}},[t._v("GATK MarkDuplicates"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("Base-quality score recalibration")]),t._v(" with "),n("a",{attrs:{href:"https://software.broadinstitute.org/gatk/",target:"_blank",rel:"noopener noreferrer"}},[t._v("GATK BaseRecalibrator and ApplyBQSR"),n("OutboundLink")],1),t._v(".")])]),t._v(" "),n("h2",{attrs:{id:"somatic-analyses"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#somatic-analyses","aria-hidden":"true"}},[t._v("#")]),t._v(" Somatic Analyses")]),t._v(" "),n("ul",[n("li",[n("strong",[t._v("SNVs and indels")]),t._v(" are called using "),n("a",{attrs:{href:"https://software.broadinstitute.org/gatk/documentation/tooldocs/4.beta.4/org_broadinstitute_hellbender_tools_walkers_mutect_Mutect2.php",target:"_blank",rel:"noopener noreferrer"}},[t._v("MuTect2"),n("OutboundLink")],1),t._v(" and "),n("a",{attrs:{href:"https://github.com/Illumina/strelka",target:"_blank",rel:"noopener noreferrer"}},[t._v("Strelka2"),n("OutboundLink")],1),t._v(". Subsequently, they are combined, annotated and filtered as described "),n("router-link",{attrs:{to:"/variant-annotation-and-filtering.html#somatic-snvs-and-indels"}},[t._v("in the section on variant annotation and filtering")]),t._v(".")],1),t._v(" "),n("li",[n("strong",[t._v("Structural variants")]),t._v(" are detected by "),n("a",{attrs:{href:"https://github.com/dellytools/delly",target:"_blank",rel:"noopener noreferrer"}},[t._v("Delly"),n("OutboundLink")],1),t._v(" and "),n("a",{attrs:{href:"https://github.com/Illumina/manta",target:"_blank",rel:"noopener noreferrer"}},[t._v("Manta"),n("OutboundLink")],1),t._v(" then combined, filtered and annotated as described "),n("router-link",{attrs:{to:"/variant-annotation-and-filtering.html#somatic-and-germline-svs"}},[t._v("in the section on variant annotation and filtering")]),t._v(".")],1),t._v(" "),n("li",[n("strong",[t._v("Copy-number analysis")]),t._v(" is performed with "),n("a",{attrs:{href:"https://github.com/mskcc/facets",target:"_blank",rel:"noopener noreferrer"}},[t._v("FACETS"),n("OutboundLink")],1),t._v(" and processed using "),n("a",{attrs:{href:"https://github.com/mskcc/facets-suite",target:"_blank",rel:"noopener noreferrer"}},[t._v("facets-suite"),n("OutboundLink")],1),t._v(". Locus-specific copy-number, purity and ploidy estimates are integrated with the SNV/indel calls to perform clonality and zygosity analyses.")]),t._v(" "),n("li",[n("strong",[t._v("Microsatellite instability")]),t._v(" is detected using "),n("a",{attrs:{href:"https://github.com/ding-lab/msisensor",target:"_blank",rel:"noopener noreferrer"}},[t._v("MSIsensor"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("HLA genotyping")]),t._v(" is performed with "),n("a",{attrs:{href:"https://software.broadinstitute.org/cancer/cga/polysolver",target:"_blank",rel:"noopener noreferrer"}},[t._v("POLYSOLVER"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("LOH at HLA loci")]),t._v(" is assessed with "),n("a",{attrs:{href:"https://github.com/mskcc/lohhla",target:"_blank",rel:"noopener noreferrer"}},[t._v("LOHHLA"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("Mutational signatures")]),t._v(" with https://github.com/mskcc/mutation-signatures.")]),t._v(" "),n("li",[n("strong",[t._v("Neoantigen prediction")]),t._v(" using estimates of class I MHC binding affinity is performed with "),n("a",{attrs:{href:"https://www.ncbi.nlm.nih.gov/pubmed/28978689",target:"_blank",rel:"noopener noreferrer"}},[t._v("NetMHC 4.0"),n("OutboundLink")],1),t._v(" and integrated into the set of SNV/indel calls using https://github.com/taylor-lab/neoantigen-dev.")])]),t._v(" "),n("h2",{attrs:{id:"germline-analyses"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#germline-analyses","aria-hidden":"true"}},[t._v("#")]),t._v(" Germline Analyses")]),t._v(" "),n("ul",[n("li",[n("strong",[t._v("SNVs and indels")]),t._v(" are called using "),n("a",{attrs:{href:"https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.8.0/org_broadinstitute_hellbender_tools_walkers_haplotypecaller_HaplotypeCaller.php",target:"_blank",rel:"noopener noreferrer"}},[t._v("HaplotypeCaller"),n("OutboundLink")],1),t._v(" and "),n("a",{attrs:{href:"https://github.com/Illumina/strelka",target:"_blank",rel:"noopener noreferrer"}},[t._v("Strelka2"),n("OutboundLink")],1),t._v(". Subsequently, they are combined, annotated and filtered as described "),n("router-link",{attrs:{to:"/variant-annotation-and-filtering.html#germline-snvs-and-indels"}},[t._v("in the section on variant annotation and filtering")]),t._v(".")],1),t._v(" "),n("li",[n("strong",[t._v("Structural variants")]),t._v(" are detected by "),n("a",{attrs:{href:"https://github.com/dellytools/delly",target:"_blank",rel:"noopener noreferrer"}},[t._v("Delly"),n("OutboundLink")],1),t._v(" and "),n("a",{attrs:{href:"https://github.com/Illumina/manta",target:"_blank",rel:"noopener noreferrer"}},[t._v("Manta"),n("OutboundLink")],1),t._v(" then combined, filtered and annotated as described "),n("router-link",{attrs:{to:"/variant-annotation-and-filtering.html#somatic-and-germline-svs"}},[t._v("in the section on variant annotation and filtering")]),t._v(".")],1)]),t._v(" "),n("h2",{attrs:{id:"quality-control"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#quality-control","aria-hidden":"true"}},[t._v("#")]),t._v(" Quality Control")]),t._v(" "),n("ul",[n("li",[n("strong",[t._v("FASTQ QC metrics")]),t._v(" are generated using "),n("a",{attrs:{href:"https://github.com/OpenGene/fastp",target:"_blank",rel:"noopener noreferrer"}},[t._v("fastp"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("BAM file QC metrics")]),t._v(" are generated using "),n("a",{attrs:{href:"https://github.com/tobiasrausch/alfred",target:"_blank",rel:"noopener noreferrer"}},[t._v("Alfred"),n("OutboundLink")],1),t._v(".")]),t._v(" "),n("li",[n("strong",[t._v("Hybridisation-selection metrics")]),t._v(" are generated using "),n("a",{attrs:{href:"https://software.broadinstitute.org/gatk/documentation/tooldocs/4.beta.6/picard_analysis_directed_CollectHsMetrics.php",target:"_blank",rel:"noopener noreferrer"}},[t._v("CollectHsMetrics"),n("OutboundLink")],1),t._v(". Only for exomes.")]),t._v(" "),n("li",[n("strong",[t._v("Contamination and concordance metrics")]),t._v(" for tumor-normal pairs using Conpair (https://github.com/mskcc/Conpair).")])]),t._v(" "),n("h2",{attrs:{id:"wgs-versus-wes"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#wgs-versus-wes","aria-hidden":"true"}},[t._v("#")]),t._v(" WGS versus WES")]),t._v(" "),n("p",[t._v("Contact us if you are interest in support for other sequencing assays or capture kits.")])])},[],!1,null,null,null);e.default=a.exports}}]);