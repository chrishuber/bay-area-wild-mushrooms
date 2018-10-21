-- creating bay_area_observations table
CREATE TABLE `bay_area_observations_314` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `when` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `specimen` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text,
  `thumb_image_id` int(11) DEFAULT NULL,
  `name_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `is_collection_location` tinyint(1) NOT NULL DEFAULT '1',
  `vote_cache` float DEFAULT '0',
  `num_views` int(11) NOT NULL DEFAULT '0',
  `last_view` datetime DEFAULT NULL,
  `rss_log_id` int(11) DEFAULT NULL,
  `lat` decimal(15,10) DEFAULT NULL,
  `long` decimal(15,10) DEFAULT NULL,
  `where` varchar(1024) DEFAULT NULL,
  `alt` int(11) DEFAULT NULL,
  `lifeform` varchar(1024) DEFAULT NULL,
  `text_name` varchar(100) DEFAULT NULL,
  `classification` text,
  PRIMARY KEY (`id`)
)
SELECT observations.* FROM observations LEFT JOIN locations ON observations.location_id = locations.id
WHERE locations.north <= '38.41389846801758' AND
locations.south >= '36.470699310302734' AND
locations.east <= '-121.10199737548828' AND
locations.west >= '-123.17400360107422';

-- creating bay_area_names table using bay_area_observations
CREATE TABLE `bay_area_names` (
	`id` int(11) NOT NULL AUTO_INCREMENT, `version` int(11) DEFAULT NULL, 
	`created_at` datetime DEFAULT NULL, `updated_at` datetime DEFAULT NULL, 
	`user_id` int(11) DEFAULT NULL, `description_id` int(11) DEFAULT NULL, 
	`rss_log_id` int(11) DEFAULT NULL, `num_views` int(11) DEFAULT '0', 
	`last_view` datetime DEFAULT NULL, `rank` int(11) DEFAULT NULL, 
	`text_name` varchar(100) DEFAULT NULL, `search_name` varchar(221) DEFAULT NULL, 
	`display_name` varchar(204) DEFAULT NULL, `sort_name` varchar(241) DEFAULT NULL, 
	`citation` text, 
	`deprecated` tinyint(1) NOT NULL DEFAULT '0', 
	`synonym_id` int(11) DEFAULT NULL, 
	`correct_spelling_id` int(11) DEFAULT NULL, 
	`notes` text, `classification` text, 
	`ok_for_export` tinyint(1) NOT NULL DEFAULT '1', 
	`author` varchar(100) DEFAULT NULL, 
	`lifeform` varchar(1024) NOT NULL DEFAULT ' ', 
	`locked` tinyint(1) NOT NULL DEFAULT '0', 
	PRIMARY KEY (`id`)
) 
SELECT names.* FROM names WHERE id IN (SELECT DISTINCT(name_id) FROM bay_area_observations);

-- feature engineering using SQL
SELECT bay_area_observations.id, bay_area_observations.created_at, bay_area_names.text_name, (north + south) / 2 AS latitude, (east + west) / 2 AS longitude, 
IF(bay_area_locations.name LIKE '%redwoods%' OR bay_area_observations.notes LIKE '%redwood%', true, false) AS is_redwood, 
IF(bay_area_observations.notes LIKE '%douglas%' OR bay_area_observations.notes LIKE '%fir %' OR bay_area_observations.notes LIKE '%fir,%', true, false) AS is_fir, 
IF(bay_area_locations.name LIKE '%live oak%' OR bay_area_locations.name LIKE '%tanoak%' OR bay_area_observations.notes LIKE '%Quercus%', true, false) AS is_oak, IF(bay_area_observations.notes LIKE '%eucalyptus%', true, false) AS is_eucalyptus, 
IF(bay_area_observations.notes LIKE '%manzanita%', true, false) AS is_manzanita, IF(bay_area_observations.notes LIKE '%pine%', true, false) AS is_pine, IF(bay_area_observations.notes LIKE '%madrone%', true, false) AS is_madrone, 
IF(bay_area_observations.notes LIKE '%cypress%', true, false) AS is_cypress, IF(bay_area_observations.notes LIKE '%hardwood%', true, false) AS is_hardwood, IF(bay_area_observations.notes LIKE '%grass%', true, false) AS is_grass, 
IF(bay_area_observations.notes LIKE '%duff%', true, false) AS is_duff, IF(bay_area_observations.notes LIKE '%rott%', true, false) AS is_rott, 
IF(bay_area_observations.notes LIKE '%dung%', true, false) AS is_dung, IF(bay_area_observations.notes LIKE '%wood chip%', true, false) AS is_wood_chip 
FROM bay_area_observations 
LEFT JOIN bay_area_names ON bay_area_observations.name_id = bay_area_names.id 
LEFT JOIN bay_area_locations ON bay_area_observations.location_id = bay_area_locations.id 
WHERE bay_area_names.text_name 
REGEXP ('Agaricus subrutilescens|Amanita novinupta|Boletus edulis|Boletus edulis var. grandedulis|Boletus regineus|Cantharellus californicus|Cantharellus cibarius|Cantharellus tubaeformis|Chlorophyllum brunneum|Clitocybe nuda|Lepista nuda|Coprinellus micaceus|Coprinus comatus|Entoloma medianox|Flammulina velutipes|Grifola frondosa|Hericium erinaceus|Himematsutake|Lactarius deliciosus|Lactarius rubidus|Lactarius rufulus|Leccinum manzanitae|Lentinula edodes|Morchella conica var. deliciosa|Morchella esculenta var. rotunda|Tremella fuciformis|Tricholoma matsutake|Tuber aestivum|Tuber birch|Tuber brumale|Tuber indicum|Tuber macrosporum|Tuber mesentericum|Volvariella volvacea|Amanita caesarea|Amanita calyptroderma|Amanita velosa|Armillaria mellea|Auricularia auricula-judae|Gliophorus psittacinus|Hydnum repandum|Hypsizygus tessellatus/Hypsizygus marmoreus|Laccaria amethysteo-occidentalis|Suillus fuscotomentosus|Agaricus augustus|Amanita augusta|Amanita sect. Vaginatae |Amanita vaginata|Boletus badius|Calvatia gigantea|Clavaria fragilis|Gomphidius oregonensis|Gymnopus dryophilus|Lacrymaria lacrymabunda|Laetiporus gilbertsonii|Panaeolus papilionaceus|Pleurotus ostreatus|Pluteus cervinus|Suillus pungens|Volvopluteus gloiocephalus') ORDER BY text_name;

-- adding randomized data based on scientific range standards
SELECT bay_area_observations.id, bay_area_observations.created_at, bay_area_names.text_name, (north + south) / 2 AS latitude, (east + west) / 2 AS longitude, IF(bay_area_locations.name LIKE '%redwoods%' OR bay_area_observations.notes LIKE '%redwood%', true, false) AS is_redwood, IF(bay_area_observations.notes LIKE '%douglas%' OR bay_area_observations.notes LIKE '%fir %' OR bay_area_observations.notes LIKE '%fir,%', true, false) AS is_fir, IF(bay_area_locations.name LIKE '%live oak%' OR bay_area_locations.name LIKE '%tanoak%' OR bay_area_observations.notes LIKE '%Quercus%', true, false) AS is_oak, IF(bay_area_observations.notes LIKE '%eucalyptus%', true, false) AS is_eucalyptus, IF(bay_area_observations.notes LIKE '%manzanita%', true, false) AS is_manzanita, IF(bay_area_observations.notes LIKE '%pine%', true, false) AS is_pine, IF(bay_area_observations.notes LIKE '%madrone%', true, false) AS is_madrone, IF(bay_area_observations.notes LIKE '%cypress%', true, false) AS is_cypress, IF(bay_area_observations.notes LIKE '%hardwood%', true, false) AS is_hardwood, IF(bay_area_observations.notes LIKE '%grass%', true, false) AS is_grass, IF(bay_area_observations.notes LIKE '%duff%', true, false) AS is_duff, IF(bay_area_observations.notes LIKE '%rott%', true, false) AS is_rott, IF(bay_area_observations.notes LIKE '%dung%', true, false) AS is_dung, IF(bay_area_observations.notes LIKE '%wood chip%', true, false) AS is_wood_chip,
ROUND(stipe_max_length_cm - (stipe_max_length_cm - stipe_min_length_cm) * RAND(314), 1) AS stipe_length,
ROUND(stipe_max_width_cm - (stipe_max_width_cm - stipe_min_width_cm) * RAND(314), 1) AS stipe_width,
ROUND(pileus_max_width_cm - (pileus_max_width_cm - pileus_min_width_cm) * RAND(314), 1) AS pileus_width,
stipe_shape, stipe_scales, lamellae_morph, pileus_shape, pileus_viscid, pileus_scales, pileus_warts, pileus_bruising
FROM bay_area_observations 
LEFT JOIN bay_area_names ON bay_area_observations.name_id = bay_area_names.id 
LEFT JOIN bay_area_locations ON bay_area_observations.location_id = bay_area_locations.id 
LEFT JOIN mushroom_stats ON bay_area_names.text_name = mushroom_stats.species 
WHERE bay_area_names.text_name 
REGEXP ('Agaricus augustus|Agaricus subrutilescens|Amanita augusta|Amanita calyptroderma|Amanita novinupta|Amanita vaginata|Amanita velosa|Armillaria mellea|Boletus edulis|Boletus regineus|Cantharellus californicus|Chlorophyllum brunneum|Clavaria fragilis|Clitocybe nuda|Coprinellus micaceus|Coprinus comatus|Entoloma medianox|Flammulina velutipes|Gliophorus psittacinus|Gomphidius oregonensis|Gymnopus dryophilus|Hericium erinaceus|Hydnum repandum|Laccaria amethysteo-occidentalis|Lacrymaria lacrymabunda|Lactarius deliciosus|Lactarius rubidus|Lactarius rufulus|Laetiporus gilbertsonii|Leccinum manzanitae|Lentinula edodes|Panaeolus papilionaceus|Pleurotus ostreatus|Pluteus cervinus|Suillus fuscotomentosus|Suillus pungens|Volvopluteus gloiocephalus');