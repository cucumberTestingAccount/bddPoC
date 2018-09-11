@baseUrl @baseUrl-cbc
Feature: Test PDS_ENDPOINT/identities
    Ensure that PDS can be created and updated, 
    and that they can get their own identities
    
Scenario: Creating the PA-OPERATOR with no auth token
    Given The json request data
    """json
    {
        "type": "cbc:Person",
        "role": "cbc:PA-OPERATOR"
    }
    """
    When I make a POST request to "/pds/identities" with auth ""
    Then The response status code should be "400"
    And the response should be "missing or malformed jwt"
    
Scenario: Creating the PA-OPERATOR with an invalid auth token
    Given The json request data
    """json
    {
        "type": "cbc:Person",
        "role": "cbc:PA-OPERATOR"
    }
    """
    When I make a POST request to "/pds/identities" with auth "Bearer 123"
    Then The response status code should be "401"
    And the response should be "invalid or expired jwt"

Scenario: Creating the PA-OPERATOR with a valid auth token
    Given The json request data
    """json
    {
        "type": "cbc:Person",
        "role": "cbc:PA-OPERATOR"
    }
    """
    When I make a POST request to "/pds/identities" with auth "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0Z3QiOiIiLCJyb2wiOiIiLCJhdWQiOiIiLCJleHAiOjE2MzMyMDAyNTUsImlhdCI6MTUyOTYwMDI1NSwiaXNzIjoiTHV4VHJ1c3QiLCJzdWIiOiIwMDAtQSJ9.LnF_Kac_4VjF5FqhM2bZiNDkJ8SOig4VY1P2MgjTiNe4eEtrdRmlrz0cIsWh7tocs0HzHIaa9-aM4d410qj0gZd-EXEaeCE5Jgw_fScYcmWs89qELzKMM9iwR7m9pRpLfU_i9CsGFR4CFFRrClAy4GuZfSAukKznbsI-dBXvh6ZOq-n99GCbysoiQhOdnXn0Tw7nIUMGOSkr5PhpViNICU4fzRDSfVJtQrTlXSW9neKcU4HmHsQydI9UfS-jOxPYpkdhtMEWl7WXQ0reSHzJf1EoTZVwn5jN0cZlQDGOBGZtw1hd-nQ_9XVDQiEA4xUzmRZKxtMYi6a1C216mxSpzw"
    Then The response status code should be "200"
    And the response property "identityID" should exist
    
Scenario: Creating a duplicate PDS
    Given The json request data
    """json
    {
        "type": "cbc:Person",
        "role": "cbc:PA-OPERATOR"
    }
    """
    When I make a POST request to "/pds/identities" with auth "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0Z3QiOiIiLCJyb2wiOiIiLCJhdWQiOiIiLCJleHAiOjE2MzMyMDAyNTUsImlhdCI6MTUyOTYwMDI1NSwiaXNzIjoiTHV4VHJ1c3QiLCJzdWIiOiIwMDAtQSJ9.LnF_Kac_4VjF5FqhM2bZiNDkJ8SOig4VY1P2MgjTiNe4eEtrdRmlrz0cIsWh7tocs0HzHIaa9-aM4d410qj0gZd-EXEaeCE5Jgw_fScYcmWs89qELzKMM9iwR7m9pRpLfU_i9CsGFR4CFFRrClAy4GuZfSAukKznbsI-dBXvh6ZOq-n99GCbysoiQhOdnXn0Tw7nIUMGOSkr5PhpViNICU4fzRDSfVJtQrTlXSW9neKcU4HmHsQydI9UfS-jOxPYpkdhtMEWl7WXQ0reSHzJf1EoTZVwn5jN0cZlQDGOBGZtw1hd-nQ_9XVDQiEA4xUzmRZKxtMYi6a1C216mxSpzw"
    Then The response status code should be "400"
    And the response property "CBErrorCode" should be "pds.400.DuplicateIdentity"
    
Scenario: Creating a duplicate PA-OPERATOR
    Given The json request data
    """json
    {
        "type": "cbc:Person",
        "role": "cbc:PA-OPERATOR"
    }
    """
    When I make a POST request to "/pds/identities" with auth "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0Z3QiOiIiLCJyb2wiOiIiLCJhdWQiOiIiLCJleHAiOjE2MzMyMDAyNTUsImlhdCI6MTUyOTYwMDI1NSwiaXNzIjoiTHV4VHJ1c3QiLCJzdWIiOiIwMDAtQiJ9.hOrskRTFbNMXU7EZjQo018zvuvERwjpLVtJrQj-7dNiUz3ZnFMefuNnf-omSukQLRl11VxC4FMew5b8o2mO36YFxVr3pI1TWV-_Tbq_INb1Cfx7znDAVBz1Bf4wFt0T7rlqc1MF-OyN7rZmSIVWcCjcbiTr2Ga9FmKIXHdrYbBKy57DRchE2-hTJH5DORYunBYh_FQZLQoTGTDMcdx6L9xkY5-Gkw12vy4xExu96uDY90CTEaFNcb_1Q_ggDDEmzPlF1ZNLG3zVEaNedpbYZrxSE7BOzOqQVn73Hs9S_bDhxS1mHPRatioZVWroXQCzesRKcKJQ5tG-XAbnsmc-MOw"
    Then The response status code should be "400"
    And the response property "CBErrorCode" should be "pds.400.DuplicateIdentity"
    
Scenario: The PA-OPERATOR logs in and gets their identities
    Given The json request data
    """json
    {}
    """
    When I login via "/auth/token" with auth "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0Z3QiOiIiLCJyb2wiOiIiLCJhdWQiOiIiLCJleHAiOjE2MzMyMDAyNTUsImlhdCI6MTUyOTYwMDI1NSwiaXNzIjoiTHV4VHJ1c3QiLCJzdWIiOiIwMDAtQSJ9.LnF_Kac_4VjF5FqhM2bZiNDkJ8SOig4VY1P2MgjTiNe4eEtrdRmlrz0cIsWh7tocs0HzHIaa9-aM4d410qj0gZd-EXEaeCE5Jgw_fScYcmWs89qELzKMM9iwR7m9pRpLfU_i9CsGFR4CFFRrClAy4GuZfSAukKznbsI-dBXvh6ZOq-n99GCbysoiQhOdnXn0Tw7nIUMGOSkr5PhpViNICU4fzRDSfVJtQrTlXSW9neKcU4HmHsQydI9UfS-jOxPYpkdhtMEWl7WXQ0reSHzJf1EoTZVwn5jN0cZlQDGOBGZtw1hd-nQ_9XVDQiEA4xUzmRZKxtMYi6a1C216mxSpzw"
    And The user logs in successfully
    And I make a GET request to "/pds/identities" as the PA-OPERATOR
    Then The response status code should be "200"
    And The PDS should have the following roles: "cbc:PDS-OWNER cbc:PA-OPERATOR"
    