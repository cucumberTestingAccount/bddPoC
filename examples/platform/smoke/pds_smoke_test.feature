@baseUrl @baseUrl-cbc
Feature: If I access a component endpoint
	I want a 200 status and correct component name
	to know that the endpoint is working

  Scenario: Access the PDS endpoint
  	 When I make a GET request to "/pds/info"
  	 Then the response status code should be "200"
  	 And the response property "component_name" should be "pds-component"