# Vespucci Notebook Extractor API

This class can retrive a notebook python code from Colombus API, build a FamixPythonModel with it and exports all the founded elements in this model either throught api or json.  

## Load 

```smalltalk
Metacello new
    githubUser: 'JMLF' project: 'VespucciAPI' commitish: 'master' path: 'src';
    baseline: 'VespucciNotebookElementExtractor';
    load
```

## Usage 
You will need a Colombus project id and a notebook Id.

To post all the elements throught API :
```lsmalltalk
jsonExport := Vespucci fromApiComputeNotebookId: 'b03ac816-17b0-435d-9062-89f3d65b51f3' fromProject: '4f2b506d-0817-4b73-bcef-247f77d63985'. 
```

If you want the json export :
```smalltalk
jsonExport := Vespucci fromApiExportAsJsonNotebookId: 'b03ac816-17b0-435d-9062-89f3d65b51f3' fromProject: '4f2b506d-0817-4b73-bcef-247f77d63985'.
```

## Export format 
```json
{
  "sous_graphs": [
	{
      "line_end": int,
      "library": string,
      "notebook_id": uuid,
      "type_sg_id": uuid,
      "function": string,
      "value": { Famix subgraph json export},
      "pos_end": string,
      "line_start": int,
      "step_name": string,
      "source": string,
      "pos_start": string
    }
	],
  "json_profile": {},
  "notebook_id": uuid,
  "project_id": uuid,
  "name": string,
  "compositions": [
    {
      "components": [
        {
      		 "line_end": int,
          "library": string,
          "notebook_id": uuid,
          "type_sg_id": uuid,
          "function": string,
          "value": { Famix subgraph json export},
          "pos_end": string,
          "line_start": int,
          "step_name": string,
          "source": string,
          "pos_start": string
        }
      ],
      "composite": {
         "line_end": int,
         "library": string,
         "notebook_id": uuid,
         "type_sg_id": uuid,
         "function": string,
         "value": { Famix subgraph json export},
         "pos_end": string,
         "line_start": int,
         "step_name": string,
         "source": string,
         "pos_start": string
      }
}
```


