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
To use the project you will need an access to the Colombus API. 
For each usage a Vespucci instance will be initialized using the configuration file `.conf` in the root of the pharo image. The config file contain a url to the Colombus api and an api key.
```json
{
  "url": "http://127.0.0.1:8080/", 
  "key": "your-colombus-token"
}
```
It's mandatory while the parsing of local files isnt supported.

### Local 
Fot local usge, you will need a Colombus `project Id` and a `notebook Id`.

To post all the elements throught API :
```lsmalltalk
jsonExport := Vespucci fromApiComputeNotebookId: 'b03ac816-17b0-435d-9062-89f3d65b51f3' fromProject: '4f2b506d-0817-4b73-bcef-247f77d63985'. 
```

If you want the json export :
```smalltalk
jsonExport := Vespucci fromApiExportAsJsonNotebookId: 'b03ac816-17b0-435d-9062-89f3d65b51f3' fromProject: '4f2b506d-0817-4b73-bcef-247f77d63985'.
```

## Deployment usage
The [VespucciNotebookElementAPI](src/VespucciNotebookElementAPI) package contain a server that you can start using :
```smalltalk
serv := VespServer start 
```
or 
```smalltalk
serv := VespServer startOn: 1701 
```

It will now listen for a post on `/compute` 
```bash
curl -X POST http://localhost:1701/compute -d '{"notebookId": "88f4453c-30c7-4341-b3ec-4c0ee03e945e", "projectId": "4f2b506d-0817-4b73-bcef-247f77d63985", "profileName": "test"}' -H "Content-Type: application/json"
```
Each request will trigger the `fromApiCompute ...` methods posting automatically the result.


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


