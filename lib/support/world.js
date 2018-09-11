'use strict';

const _ = require('lodash');
const http = require('request-promise');
const config = require('../config.js')

function World() {
    const self = this;
    var tokens = {'paOperatorToken': ""};
    
    /**
     * Returns the list of tokens
     */
    this.getTokens = function () { 
    	return tokens;
    }
    
    /**
     * Sets the token for user 'tokenKey' to value 'tokenValue'
     */
    this.setToken = function (tokenKey, tokenValue) {
    	if (tokenKey == "paOperatorToken") {
    		tokens.paOperatorToken = tokenValue;
    	}
    }

    /**
     * Performs an HTTP GET request to the given uri
     */
    this.httpGet = function (uri, auth) {
        return _httpRequest({ method: 'GET', uri: uri , auth: auth});
    };

    /**
     * Performs an HTTP DELETE request to the given uri
     */
    this.httpDelete = function (uri) {
        return _httpRequest({ method: 'DELETE', uri: uri });
    };

    /**
     * Performs an HTTP POST request to the given uri
     */
    this.httpPost = function (uri, auth) {
        return _httpRequest({ method: 'POST', uri: uri , auth: auth});
    };

    /**
     * Gets the value of a property by its path
     */
    this.getValue = function(path){
        return _.get(self.actualResponse, path);
    };
    
    /**
     * Return console formatted json for humanz
     */
    this.prettyPrintJSON = function(json){
        return JSON.stringify(json, null, '  ');
    };
    
    /**
     * Formats the assertion in a humanz readable way
     */
    this.prettyPrintError = function(actualValue, expectedValue){
        return `\r\nExpected: ${expectedValue}\r\nActual: ${actualValue}\r\nRequest Body:\r\n${self.prettyPrintJSON(self.requestBody)}\r\nResponse Status Code: ${self.statusCode}\r\nResponse Body:\r\n${self.prettyPrintJSON(self.actualResponse)}`;
    };

    /**
     * Internal http request generator
     */
    function _httpRequest(options){
        if(self.baseUrl){
            options.uri = self.baseUrl + options.uri;
        }
        
        return http({
            method: options.method,
            uri: options.uri,
            body: self.requestBody,
            json: true,
            resolveWithFullResponse: true,
            headers: {
         		Authorization: (options.auth ? options.auth : null),
         	   'Content-Type': 'application/json'
     			}
        }).then(function(response) {
            
            if(process.env.DEBUG){
                console.log(response);
            }
            
            self.actualResponse = response.body;
            self.statusCode = response.statusCode;
        }, function(response){
            
            if(process.env.DEBUG){
                console.log(response);
            }

            // parse the message for a json body
            // the message has the following format
            // XXX - { ...json... }
            const bodyString = response.message.slice(6);
            const body = JSON.parse(bodyString); 

            self.actualResponse = body;
            self.statusCode = response.statusCode;
        });
    }
}

module.exports = function () {
    this.World = World;
};