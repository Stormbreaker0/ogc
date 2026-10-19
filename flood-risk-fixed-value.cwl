cwlVersion: v1.2
$namespaces:
  s: https://schema.org/
s:softwareVersion: 1.0.0
$graph:
- class: Workflow
  id: flood-risk-fixed-value
  label: Flood Risk Fixed Value
  doc: Flood exposure metrics for a polygon under an SSP scenario, storm surge return period and year.
  inputs:
    confidence:
      type:
        type: enum
        symbols:
        - low
        - medium
        - high
      label: Confidence
      doc: Confidence level of the flood model.
    bbox:
      type: string
      label: Area of Interest
      doc: Bounding box, serialized as a string.
    ssp:
      type:
        type: enum
        symbols:
        - ssp126
        - ssp245
        - ssp370
        - ssp585
      label: SSP Scenario
      doc: Shared Socioeconomic Pathway.
    storm_surge:
      type:
        type: enum
        symbols:
        - '0_0'
        - '0_5'
        - '1_0'
        - '1_5'
        - '2_0'
        - '3_0'
        - '5_0'
        - all
      label: Storm Surge Return Period
      doc: Return period identifier.
    year:
      type:
        type: enum
        symbols:
        - '2020'
        - '2040'
        - '2060'
        - '2080'
        - '2100'
        - '2120'
        - '2150'
        - all
      label: Year
      doc: Target year for the flood projection.
  outputs:
    result:
      type: File
      outputSource: node_flood/result
  steps:
    node_flood:
      run: '#flood-risk-cl'
      in:
        confidence: confidence
        bbox: bbox
        ssp: ssp
        storm_surge: storm_surge
        year: year
      out:
      - result
- class: CommandLineTool
  id: flood-risk-cl
  requirements:
    DockerRequirement:
      dockerPull: localhost/flood-risk-processor:1.0.0
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 512
      coresMin: 1
  baseCommand:
  - python
  - /app/flood-risk-fixed-value-processor.py
  stdout: output.json
  inputs:
    confidence:
      type: string
      inputBinding:
        prefix: --confidence
    geometry:
      type: string
      inputBinding:
        prefix: --geometry
    ssp:
      type: string
      inputBinding:
        prefix: --ssp
    storm_surge:
      type: string
      inputBinding:
        prefix: --storm-surge
    year:
      type: string
      inputBinding:
        prefix: --year
  outputs:
    result:
      type: stdout
