@baseUrl @baseUrl-cbc
Feature: If I access a component endpoint
	I want a 200 status and correct component name
	to know that the endpoint is working

Scenario Outline: Check endpoints
	When I make a GET request to "<component>"
	Then the response status code should be "200"
	And the response property "component_name" should be "<component-label>"

    Examples:
    | component        | component-label            |
    | /pds/info        | pds-component              |
    | /sp/info         | service-provider-component |
    | /tp/info         | trusted-party-component    | 
    | /schema/info     | schema-component           |
    | /storage/info    | storage-component          |
    | /kmc/info        | key-management-component   |
    | /blockchain/info | blockchain-component       |
    | /auth/info       | auth-component             |
