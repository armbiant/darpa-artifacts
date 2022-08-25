# TERArium-Store
Creates/Bootstraps default mappings for ElasticSearch.


## Setup and dependencies
Requires python 3.8+

```
pip install -r requirements.txt
```

## Usage
```
ES=<elasticsearch url> ES_USERNAME=<username> ES_PASSWORD=<password> python ./create_mappings.py
```

## Docker
The Docker file will create an ElasticSearch image prepopulated with the default mappings and sample test data.


