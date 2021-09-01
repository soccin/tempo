process RunMsiSensor {
  tag {idTumor + "__" + idNormal}

  input:
    tuple val(idTumor), val(idNormal), val(target), path(bamTumor), path(baiTumor), path(bamNormal), path(baiNormal)
    tuple path(genomeFile), path(genomeIndex), path(genomeDict), path(msiSensorList) 
    val(tools)
    val(runSomatic)

  output:
    tuple val(idTumor), val(idNormal), val(target), path("${outputPrefix}.msisensor.tsv"), emit: msi4MetaDataParser

  when: "msisensor" in tools && runSomatic

  script:
  outputPrefix = "${idTumor}__${idNormal}"
  """
  msisensor msi \
    -d ${msiSensorList} \
    -t ${bamTumor} \
    -n ${bamNormal} \
    -o ${outputPrefix}.msisensor.tsv
  """
}