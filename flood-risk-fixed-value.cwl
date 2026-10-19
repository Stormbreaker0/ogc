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

    requirements:
      SchemaDefRequirement:
        types:
          - name: Confidence
            type: enum
            symbols:
              - low
              - medium
              - high

          - name: SSP
            type: enum
            symbols:
              - ssp126
              - ssp245
              - ssp370
              - ssp585

          - name: StormSurge
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

          - name: ProjectionYear
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

    inputs:
      confidence:
        type: Confidence
        label: Confidence
        doc: Confidence level of the flood model.

      geometry:
        type: string
        label: Area of Interest
        doc: GeoJSON Polygon geometry, serialized as a JSON string.

      ssp:
        type: SSP
        label: SSP Scenario
        doc: Shared Socioeconomic Pathway.

      storm_surge:
        type: StormSurge
        label: Storm Surge Return Period
        doc: Return period identifier.

      year:
        type: ProjectionYear
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
          geometry: geometry
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
        type: Confidence
        inputBinding:
          prefix: --confidence

      geometry:
        type: string
        inputBinding:
          prefix: --geometry

      ssp:
        type: SSP
        inputBinding:
          prefix: --ssp

      storm_surge:
        type: StormSurge
        inputBinding:
          prefix: --storm-surge

      year:
        type: ProjectionYear
        inputBinding:
          prefix: --year

    outputs:
      result:
        type: stdout
```
