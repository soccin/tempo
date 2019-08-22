(window.webpackJsonp=window.webpackJsonp||[]).push([[14],{197:function(e,t,a){"use strict";a.r(t);var r=a(0),s=Object(r.a)({},function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("ContentSlotsDistributor",{attrs:{"slot-key":e.$parent.slotKey}},[a("h1",{attrs:{id:"outputs"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#outputs","aria-hidden":"true"}},[e._v("#")]),e._v(" Outputs")]),e._v(" "),a("p",[e._v("All paths below are relative to the base directory "),a("code",[e._v("outDir")]),e._v(" as described in the "),a("router-link",{attrs:{to:"/running-the-pipeline.html"}},[e._v("run instructions")]),e._v(".")],1),e._v(" "),a("div",{staticClass:"language-shell extra-class"},[a("pre",{pre:!0,attrs:{class:"language-text"}},[a("code",[e._v("outDir\n├── bams\n├── qc\n├── somatic\n└── germline\n")])])]),a("h2",{attrs:{id:"bam-files"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#bam-files","aria-hidden":"true"}},[e._v("#")]),e._v(" BAM Files")]),e._v(" "),a("p",[e._v("The "),a("code",[e._v("bams")]),e._v(" folder contains the final aligned and post-processed BAM files along with index files.")]),e._v(" "),a("h2",{attrs:{id:"qc-outputs"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#qc-outputs","aria-hidden":"true"}},[e._v("#")]),e._v(" QC Outputs")]),e._v(" "),a("p",[e._v("FASTQ file, read alignment and basic BAM file QC is in the "),a("code",[e._v("qc")]),e._v(" directory:")]),e._v(" "),a("div",{staticClass:"language-shell extra-class"},[a("pre",{pre:!0,attrs:{class:"language-text"}},[a("code",[e._v("qc\n├── alfred\n├── collecthsmetrics\n├── conpair\n├── fastp\n└── alignment_qc.txt\n")])])]),a("p",[e._v("These outputs are:")]),e._v(" "),a("ul",[a("li",[a("code",[e._v("fastp")]),e._v(" (folder): An HTML report for each FASTQ file pair per sample.")]),e._v(" "),a("li",[a("code",[e._v("alfred")]),e._v(" (folder): A per-sample and per-readgroup BAM file alignment metrics in text and PDF files.")]),e._v(" "),a("li",[a("code",[e._v("collectshsmetrics")]),e._v(" (folder): For exomes, per-sample hybridisation-selection metrics in the.")]),e._v(" "),a("li",[a("code",[e._v("conpair")]),e._v(" (folder): Per tumor-normal-pair contamination and sample concordance estimates.")]),e._v(" "),a("li",[a("code",[e._v("alignment_qc.txt")]),e._v(": Aggregated read-alignments statistics file, from the "),a("code",[e._v("alfred")]),e._v(" and "),a("code",[e._v("collectshsmetrics")]),e._v(" folders.")])]),e._v(" "),a("h2",{attrs:{id:"somatic-data"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#somatic-data","aria-hidden":"true"}},[e._v("#")]),e._v(" Somatic data")]),e._v(" "),a("p",[e._v("The result of the somatic analyses is output in summarized forms in the "),a("code",[e._v("somatic")]),e._v(" folder:")]),e._v(" "),a("div",{staticClass:"language-shell extra-class"},[a("pre",{pre:!0,attrs:{class:"language-text"}},[a("code",[e._v("somatic\n├── facets\n├── mutsig\n├── merged_all_neoantigen_predictions.txt\n├── merged_armlevel.tsv\n├── merged_genelevel_TSG_ManualReview.txt\n├── merged_hisens.cncf.txt\n├── merged_hisensPurity_out.txt\n├── merged_hisens.seg\n├── merged.maf\n├── merged_metadata.tsv\n├── merged_purity.cncf.txt\n├── merged_purity.seg\n└── merged.vcf.gz\n")])])]),a("p",[e._v("These outputs are:")]),e._v(" "),a("ul",[a("li",[a("code",[e._v("facets")]),e._v(" (folder): Individual copy-number profiles from FACETS, per tumor-normal pair.")]),e._v(" "),a("li",[a("code",[e._v("mutsig")]),e._v(" (folder): Individual mutational signature decomposition per tumor-normal pair.")]),e._v(" "),a("li",[a("code",[e._v("merged_all_neoantigen_predictions.txt")]),e._v(": Neoantigen predictions from NetMHCpan for all samples.")]),e._v(" "),a("li",[a("code",[e._v("merged_armlevel.tsv")]),e._v(", "),a("code",[e._v("merged_genelevel_TSG_ManualReview.txt")]),e._v(", "),a("code",[e._v("merged_hisens.cncf.txt")]),e._v(", "),a("code",[e._v("merged_hisensPurity_out.txt")]),e._v(", "),a("code",[e._v("merged_purity.cncf.txt")]),e._v(", and "),a("code",[e._v("merged_purity.seg")]),e._v(", summarized arm- and gene-level output from Facets, as well as FACETS- and IGV-style segmentation files.")]),e._v(" "),a("li",[a("code",[e._v("merged.maf")]),e._v(": Filtered mutations from MuTect2 and Strelka2, annotated with mutational effects, neoantigen predictions, and zygosity, as "),a("router-link",{attrs:{to:"/variant-annotation-and-filtering.html#somatic-snvs-and-indels"}},[e._v("described elsewhere")]),e._v(".")],1),e._v(" "),a("li",[a("code",[e._v("merged.vcf.gz")]),e._v(": All structural variants detected by Delly and Manta.")])]),e._v(" "),a("h2",{attrs:{id:"germline-data"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#germline-data","aria-hidden":"true"}},[e._v("#")]),e._v(" Germline data")]),e._v(" "),a("p",[e._v("The result of the somatic analyses is output in summarized forms in the "),a("code",[e._v("germline")]),e._v(" folder:")]),e._v(" "),a("div",{staticClass:"language-shell extra-class"},[a("pre",{pre:!0,attrs:{class:"language-text"}},[a("code",[e._v("germline/\n├── merged.maf\n└── merged.vcf.gz\n")])])]),a("p",[e._v("These outputs are:")]),e._v(" "),a("ul",[a("li",[a("code",[e._v("merged.maf")]),e._v(": Filtered mutations from HaplotypeCaller and Strelka2, annotated with mutational effects and zygosity, as "),a("router-link",{attrs:{to:"/variant-annotation-and-filtering.html#germline-snvs-and-indels"}},[e._v("described elsewhere")]),e._v(".")],1),e._v(" "),a("li",[a("code",[e._v("merged.vcf.gz")]),e._v(": All structural variants Delly and Manta.")])]),e._v(" "),a("h2",{attrs:{id:"extended-outputs"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#extended-outputs","aria-hidden":"true"}},[e._v("#")]),e._v(" Extended Outputs")]),e._v(" "),a("p",[e._v("TBD")])])},[],!1,null,null,null);t.default=s.exports}}]);