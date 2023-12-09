-- ITEM 03

-- EX 01
-- In Dbpedia find the author, resource type, owner and languages linked with the concept Gmail. Gmail webpage is located at https://gsuite.google.com/products/gmail/

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?webpage ?type ?languages ?owner ?author WHERE {
    dbr:Gmail foaf:homepage ?webpage;
    dbo:type ?type;
    dbp:language ?languages;
    dbo:owner ?owner;
    dbo:author ?author.
}

-- EX 02
-- We now want to know which products are authored by Google.
-- Since Google is a resource, and the default prefix (also called qname) for resources is dbr (short for “dbpedia resource”), we should use dbr:Google

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?otherGoogleProducts WHERE {
    ?otherGoogleProducts dbo:author dbr:Google.
}

-- EX 03
-- Visit the URL http://dbpedia.org/page/Paul_Buchheit. What filter should be added to get the abstract only in English?

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT ?abstract WHERE {
    dbr:Paul_Buchheit dbo:abstract ?abstract.
    FILTER(lang(?abstract) = 'en')
}

-- OBTAIN SAME INFO USING dbr:Gmail

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT distinct ?author ?abstract WHERE {
    dbr:Gmail dbo:author ?author.
	?author dbo:abstract ?abstract.
    FILTER(lang(?abstract) = 'en')
}

-- EX 04
-- Search other creators/authors, showing name, date birth, and place of birth. Show only 6 results

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT DISTINCT ?creator ?dateOfBirth SAMPLE(?placeOfBirth) AS ?placeOfBirth WHERE {
    ?resource dbo:author ?creator.
    ?creator dbo:birthDate ?dateOfBirth.
    ?creator dbo:birthPlace ?placeOfBirth.
}
ORDER BY ?creator
LIMIT 6

-- EX 05
-- Add to the previous question the author’s children’s name (remove the limit restriction)

PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbp: <http://dbpedia.org/property/>
SELECT DISTINCT ?creator ?children WHERE {
    ?resource dbo:author ?creator.
    ?creator dbo:child ?child.
    ?child dbo:birthName ?children.
}

-- EX 06
-- Build a query on Wikidata [https://query.wikidata.org/] with names of People from Spain, their occupation, and the place and date they were born.

SELECT ?nameLabel ?occupationLabel ?birthPlaceLabel ?birthDateLabel WHERE {
	?name wdt:P31 wd:Q5;
    wdt:P27 wd:Q29;
    wdt:P106 ?occupation;
    wdt:P19 ?birthPlace;
    wdt:P569 ?birthDate.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en".}
}
-- LIMIT 100
-- TIMEOUT EXCEEDED

SELECT ?nameLabel ?occupationLabel ?birthPlaceLabel ?birthDateLabel WHERE {
	?name wdt:P31 wd:Q5.
    ?name wdt:P27 wd:Q29;
    wdt:P106 ?occupation;
    wdt:P19 ?birthPlace;
    wdt:P569 ?birthDate.
    ?name rdfs:label ?nameLabel
    FILTER(lang(?nameLabel) = "en").
    ?occupation rdfs:label ?occupationLabel
    FILTER(lang(?occupationLabel) = "en").
    ?birthplace rdfs:label ?birthPlaceLabel
    FILTER(lang(?birthPlaceLabel) = "en").
    ?birthdate rdfs:label ?birthDateLabel
    FILTER(lang(?birthDateLabel) = "en").
}

-- EX 07
-- Write a query on Wikidata to ASK if there is any country in the United Nations called “Paris”

ASK {?country wdt:P1448 "Paris". ?country wdt:P463 wd:Q1065. ?country wdt:P31 wd:Q6256}

-- EX 08
-- On Wikidata [https://query.wikidata.org/] find all the people whose birthday is the same day as yours (they can be born in a different year). Limit the result to 100.

SELECT ?nameLabel ?birthDateLabel WHERE{
    ?name wdt:P569 ?birthDate.
    FILTER (DAY(?birthDate) = 18 && MONTH(?birthDate) = 04).
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en".}
}
LIMIT 100
