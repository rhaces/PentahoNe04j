//Load User Node
CREATE CONSTRAINT ON (user:User)
ASSERT user.screen_name IS UNIQUE;

//USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/tweets.csv" AS row
MERGE (user:User {screen_name: row.screen_name})
SET user.name =  row.name;

//Load User Tweet
CREATE CONSTRAINT ON (tweet:Tweet)
ASSERT tweet.id IS UNIQUE;

//USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/tweets.csv" AS row
MERGE (tweet:Tweet {id: row.ID})
SET tweet.text =  row.text, tweet.created_at = row.created_at;

//Create/Load TWEETED Relation
//CREATE CONSTRAINT ON ()-[tweeted:TWEETED]-()
//ASSERT exists(tweeted.created_at)

//USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/tweets.csv" AS row
MATCH (user:User {screen_name: row.screen_name})
MATCH (tweet:Tweet {id: row.ID})
MERGE (user)-[:TWEETED{created_at :row.created_at}]->(tweet);

//Load Hash Node
CREATE CONSTRAINT ON (hash:Hash)
ASSERT hash.hash IS UNIQUE;

//USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/hash.csv" AS row
MERGE (hash:Hash {hash: row.hash});

//Create/Load HAS_HASH Relation
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/hash.csv" AS row
MATCH (tweet:Tweet {id: row.ID})
MATCH (hash:Hash {hash: row.hash})
MERGE (tweet)-[:HAS_HASH]->(hash);

//Load Url Node
CREATE CONSTRAINT ON (url:Url)
ASSERT url.url IS UNIQUE;

//USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/url.csv" AS row
MERGE (url:Url {url: row.url});

//Create/Load HAS_HASH Relation
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/url.csv" AS row
MATCH (tweet:Tweet {id: row.ID})
MATCH (url:Url {url: row.url})
MERGE (tweet)-[:HAS_URL]->(url);

//Create/Load MENTIONS Relation
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/mention.csv" AS row
MATCH (tweet:Tweet {id: row.ID})
MERGE (user:User {screen_name: row.mention_screen_name})
ON CREATE SET user.name = row.mention_name
MERGE (tweet)-[:MENTIONS]->(user);
