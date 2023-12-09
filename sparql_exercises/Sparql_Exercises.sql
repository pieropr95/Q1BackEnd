-- dbr: Gmail
-- resource: Gmail

-- without semicolon
PREFIX res: <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?webpage ?type ?languages ?owner ?author WHERE {
    res:Gmail foaf:homepage ?webpage.
    res:Gmail dbpedia2:type ?type.
    res:Gmail dbp:language ?languages.
    res:Gmail dbpedia2:owner ?owner.
    res:Gmail dbpedia2:author ?author.
}

-- with semicolon
PREFIX res: <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?webpage ?type ?languages ?owner ?author WHERE {
    res:Gmail foaf:homepage ?webpage;
    dbpedia2:type ?type;
    dbp:language ?languages;
    dbpedia2:owner ?owner;
    dbpedia2:author ?author.
}

-- with URI
PREFIX res: <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?idk ?type ?languages ?owner ?author WHERE {
    ?idk foaf:homepage <https://gsuite.google.com/products/gmail/>;
    dbpedia2:type ?type;
    dbp:language ?languages;
    dbpedia2:owner ?owner;
    dbpedia2:author ?author.
}

-- all the websites
PREFIX res: <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?idk ?webpage ?type ?languages ?owner ?author WHERE {
    ?idk foaf:homepage ?webpage;
    dbpedia2:type ?type;
    dbp:language ?languages;
    dbpedia2:owner ?owner;
    dbpedia2:author ?author.
}
