#!/bin/bash

ES_HOST='https://search-meshlastic-jzohajyndq6bowz24ic2jnf3vu.us-west-2.es.amazonaws.com'
INDEX='meshblu_dispatcher'
NEW_VERSION=1

curl -XPUT "${ES_HOST}/${INDEX}_v${NEW_VERSION}" -d '{
  "mappings": {
    "dispatcher": {
      "dynamic": false,
      "_timestamp": {
        "enabled": true,
        "store": true
      },
      "properties": {
         "date": {
           "type": "date"
         },
         "elapsedTime": {
            "type": "long"
         },
         "request": {
            "properties": {
               "metadata": {
                  "properties": {
                     "auth": {
                        "properties": {
                           "uuid": {
                              "type": "string",
                              "fields": {
                                "raw" : {
                                  "type": "string",
                                  "index": "not_analyzed"
                                }
                              }
                           }
                        }
                     },
                     "fromUuid": {
                        "type": "string",
                        "fields": {
                          "raw" : {
                            "type": "string",
                            "index": "not_analyzed"
                          }
                        }
                     },
                     "jobType": {
                        "type": "string",
                        "fields": {
                          "raw" : {
                            "type": "string",
                            "index": "not_analyzed"
                          }
                        }
                     },
                     "responseId": {
                        "type": "string",
                        "fields": {
                          "raw" : {
                            "type": "string",
                            "index": "not_analyzed"
                          }
                        }
                     },
                     "toUuid": {
                        "type": "string",
                        "fields": {
                          "raw" : {
                            "type": "string",
                            "index": "not_analyzed"
                          }
                        }
                     }
                  }
               }
            }
         }
      }
    }
  }
}'

read -r -d '' alias_command <<EOF
  {
    "actions": [
      {
        "add": {
            "alias": "${INDEX}",
            "index": "${INDEX}_v${NEW_VERSION}"
        }
      }
    ]
  }
EOF
curl -XPOST "${ES_HOST}/_aliases" -d "$alias_command"
