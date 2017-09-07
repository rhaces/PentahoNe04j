CREATE CONSTRAINT ON (user:User)
ASSERT user.screen_name IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/tweets.csv" AS row
MERGE (user:User {screen_name: row.screen_name})
SET user.name =  row.name;

CREATE CONSTRAINT ON (tweet:Tweet)
ASSERT tweet.id IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/tweets.csv" AS row
MERGE (tweet:Tweet {id: row.ID})
SET tweet.text =  row.text, tweet.created_at = row.created_at;

CREATE CONSTRAINT ON ()-[tweeted:TWEETED]-()
ASSERT exists(tweeted.created_at);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/rhaces/PentahoNeo4j/master/files/tweets.csv" AS row
MATCH (user:User {screen_name: row.screen_name})
MATCH (tweet:Tweet {id: row.ID})
MERGE (user)-[:TWEETED{created_at :row.created_at}]->(tweet);