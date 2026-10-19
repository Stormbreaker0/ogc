```yaml
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
        type: string
        label: Confidence
        doc: Confidence level: low, medium, or high.

      bbox:
        type: string
        label: Area of Interest
        doc: GeoJSON Polygon bbox, serialized as a JSON string.

      ssp:
        type: string
        label: SSP Scenario
        doc: Shared Socioeconomic Pathway: ssp126, ssp245, ssp370, or ssp585.

      storm_surge:
        type: string
        label: Storm Surge Return Period
        doc: Return period identifier: 0_0, 0_5, 1_0, 1_5, 2_0, 3_0, 5_0, or all.

      year:
        type: string
        label: Year
        doc: Target year: 2020, 2040, 2060, 2080, 2100, 2120, 2150, or all.

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
        dockerPull: registry.example.com/gda/flood-risk-processor:1.0.0

      NetworkAccess:
        networkAccess: true

      ResourceRequirement:
        ramMin: 512
        coresMin: 1

    baseCommand:
      - python
      - /app/flood_risk_processor.py

    stdout: output.json

    inputs:
      confidence:
        type: string
        inputBinding:
          prefix: --confidence

      bbox:
        type: string
        inputBinding:
          prefix: --bbox

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
```
