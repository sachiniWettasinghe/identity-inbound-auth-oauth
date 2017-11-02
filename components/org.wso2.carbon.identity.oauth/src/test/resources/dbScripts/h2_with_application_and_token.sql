CREATE TABLE IF NOT EXISTS IDN_OAUTH_CONSUMER_APPS (
            ID INTEGER NOT NULL AUTO_INCREMENT,
            CONSUMER_KEY VARCHAR (255),
            CONSUMER_SECRET VARCHAR (512),
            USERNAME VARCHAR (255),
            TENANT_ID INTEGER DEFAULT 0,
            USER_DOMAIN VARCHAR(50),
            APP_NAME VARCHAR (255),
            OAUTH_VERSION VARCHAR (128),
            CALLBACK_URL VARCHAR (1024),
            GRANT_TYPES VARCHAR (1024),
            PKCE_MANDATORY CHAR(1) DEFAULT '0',
            PKCE_SUPPORT_PLAIN CHAR(1) DEFAULT '0',
            APP_STATE VARCHAR (25) DEFAULT 'ACTIVE',
            USER_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            APP_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            REFRESH_TOKEN_EXPIRE_TIME BIGINT DEFAULT 84600000,
            CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY),
            PRIMARY KEY (ID)
);

INSERT INTO IDN_OAUTH_CONSUMER_APPS (ID, CONSUMER_KEY, CONSUMER_SECRET, USERNAME, TENANT_ID, USER_DOMAIN, APP_NAME,
            OAUTH_VERSION, CALLBACK_URL, GRANT_TYPES, APP_STATE) VALUES
            (1, 'ca19a540f544777860e44e75f605d927', '87n9a540f544777860e44e75f605d435', 'user1', 1234, 'PRIMARY',
            'myApp', 'OAuth-2.0', 'http://localhost:8080/redirect',
            'refresh_token implicit password iwa:ntlm client_credentials authorization_code', 'ACTIVE');

INSERT INTO IDN_OAUTH_CONSUMER_APPS (ID, CONSUMER_KEY, CONSUMER_SECRET, USERNAME, TENANT_ID, USER_DOMAIN, APP_NAME,
            OAUTH_VERSION, CALLBACK_URL, GRANT_TYPES, APP_STATE) VALUES
            (2, 'dabfba9390aa423f8b04332794d83614', '5dcae004fba64e3a8a7cbebfdf02fcde', 'user1', 1234, 'PRIMARY',
            'myApp', 'OAuth-2.0', 'http://localhost:8080/redirect',
            'refresh_token password iwa:ntlm client_credentials', 'ACTIVE');

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN (
            TOKEN_ID VARCHAR (255),
            ACCESS_TOKEN VARCHAR (255),
            REFRESH_TOKEN VARCHAR (255),
            CONSUMER_KEY_ID INTEGER,
            AUTHZ_USER VARCHAR (100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            USER_TYPE VARCHAR (25),
            GRANT_TYPE VARCHAR (50),
            TIME_CREATED TIMESTAMP DEFAULT 0,
            REFRESH_TOKEN_TIME_CREATED TIMESTAMP DEFAULT 0,
            VALIDITY_PERIOD BIGINT,
            REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
            TOKEN_SCOPE_HASH VARCHAR (32),
            TOKEN_STATE VARCHAR (25) DEFAULT 'ACTIVE',
            TOKEN_STATE_ID VARCHAR (128) DEFAULT 'NONE',
            SUBJECT_IDENTIFIER VARCHAR(255),
            PRIMARY KEY (TOKEN_ID),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE,
            CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,
                                           TOKEN_STATE,TOKEN_STATE_ID)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN_SCOPE (
            TOKEN_ID VARCHAR (255),
            TOKEN_SCOPE VARCHAR (60),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (TOKEN_ID, TOKEN_SCOPE)
);

INSERT INTO IDN_OAUTH2_ACCESS_TOKEN_SCOPE (TOKEN_ID, TOKEN_SCOPE, TENANT_ID) VALUES
            ('2sa9a678f890877856y66e75f605d456', 'default', 1234);

INSERT INTO IDN_OAUTH2_ACCESS_TOKEN (TOKEN_ID, ACCESS_TOKEN, REFRESH_TOKEN, CONSUMER_KEY_ID, AUTHZ_USER, TENANT_ID,
            USER_DOMAIN, USER_TYPE, GRANT_TYPE, TIME_CREATED, REFRESH_TOKEN_TIME_CREATED, VALIDITY_PERIOD,
            REFRESH_TOKEN_VALIDITY_PERIOD, TOKEN_SCOPE_HASH, TOKEN_STATE, TOKEN_STATE_ID, SUBJECT_IDENTIFIER) VALUES
            ('2sa9a678f890877856y66e75f605d456', 'd43e8da324a33bdc941b9b95cad6a6a2',
            '2881c5a375d03dc0ba12787386451b29', 1, 'user1', 1234, 'PRIMARY', 'APPLICATION_USER', 'password', NOW(),
            NOW(), 3600, 14400, '369db21a386ae433e65c0ff34d35708d', 'ACTIVE', 'NONE', 'user1');

INSERT INTO IDN_OAUTH2_ACCESS_TOKEN (TOKEN_ID, ACCESS_TOKEN, REFRESH_TOKEN, CONSUMER_KEY_ID, AUTHZ_USER, TENANT_ID,
            USER_DOMAIN, USER_TYPE, GRANT_TYPE, TIME_CREATED, REFRESH_TOKEN_TIME_CREATED, VALIDITY_PERIOD,
            REFRESH_TOKEN_VALIDITY_PERIOD, TOKEN_SCOPE_HASH, TOKEN_STATE, TOKEN_STATE_ID, SUBJECT_IDENTIFIER) VALUES
            ('a8f78c8420cb48ad91cbac72691d4597', 'eb354a2c07c9415583bab5f970a42ad5',
            '12c05eeb22204114bc11f24c847a5cd3', 2, 'user1', 1234, 'PRIMARY', 'APPLICATION_USER', 'password', NOW(),
            NOW(), 3600, 14400, '369db21a386ae433e65c0ff34d35708d', 'ACTIVE', 'NONE', 'user1');

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_AUTHORIZATION_CODE (
            CODE_ID VARCHAR (255),
            AUTHORIZATION_CODE VARCHAR (512),
            CONSUMER_KEY_ID INTEGER,
            CALLBACK_URL VARCHAR (1024),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR (100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            TIME_CREATED TIMESTAMP,
            VALIDITY_PERIOD BIGINT,
            STATE VARCHAR (25) DEFAULT 'ACTIVE',
            TOKEN_ID VARCHAR(255),
            SUBJECT_IDENTIFIER VARCHAR(255),
            PKCE_CODE_CHALLENGE VARCHAR (255),
            PKCE_CODE_CHALLENGE_METHOD VARCHAR(128),
            PRIMARY KEY (CODE_ID),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IDN_OPENID_USER_RPS (
			USER_NAME VARCHAR(255) NOT NULL,
			TENANT_ID INTEGER DEFAULT 0,
			RP_URL VARCHAR(255) NOT NULL,
			TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
			LAST_VISIT DATE NOT NULL,
			VISIT_COUNT INTEGER DEFAULT 0,
			DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
			PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH1A_REQUEST_TOKEN (
            REQUEST_TOKEN VARCHAR (512),
            REQUEST_TOKEN_SECRET VARCHAR (512),
            CONSUMER_KEY_ID INTEGER,
            CALLBACK_URL VARCHAR (1024),
            SCOPE VARCHAR(2048),
            AUTHORIZED VARCHAR (128),
            OAUTH_VERIFIER VARCHAR (512),
            AUTHZ_USER VARCHAR (512),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (REQUEST_TOKEN),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH1A_ACCESS_TOKEN (
            ACCESS_TOKEN VARCHAR (512),
            ACCESS_TOKEN_SECRET VARCHAR (512),
            CONSUMER_KEY_ID INTEGER,
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR (512),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
);
