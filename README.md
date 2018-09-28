## <span style="color:white">Data Science Immersive Capstone Project</span>
### <span style="color:#CCC">Chris Huber, chrishubersf@gmail.com</span>
#### <span style="color:#AAA">A predictive study of edible wild mushroom growth in the greater San Francisco Bay Area</span>

### <span style="color:white">Problem Statement</span>
<div style="margin-left: 30px; margin-right: 30px;">
<p>Given prior data records of findings of edible wild edible mushroom species with latitude/longitude coordinates, species names, dates of sightings, weather conditions, <strikethrough>substrate composition</strikethrough>, and other relevant factors can I predict for a given period the likelihood of finding certain species of mushrooms that grow natively in the Bay Area.</p>
</div>

### <span style="color:white">Proposed Methods and Models</span>
<div style="margin-left: 30px; margin-right: 30px;">
<p>I propose to use MySQL as a database backend and Python/Pandas as the main technologies to analyze and deliver my findings</p>
<p>Sourcing the data is tricky: the records I have been able to find are often partial, imperfect, and even potentially inaccurate. However, the source is a reputable and well-known one among mycologists and as such I should be able to detect improperly formatted or submitted data with some thorough EDA.</p>
<p>An abundance of weather data has been and continues to be published daily by the U.S. Meterological Service and as such I should be able to import the relevant data from their website.</p>
<p>Mushrooms blooms in the Bay Area tend to occur during wet winter seasons. However, if the winter is dry they can be delayed until the spring. I intend to look at the correlation between the reported find dates and seasonal variations in temperature, precipitation, and humidity.
</div>

### <span style="color:white">Risks and Assumptions of Data</span>
<div style="margin-left: 30px; margin-right: 30px;">
<p>One of the major risks of this dataset is that it does not record quantity, simply occurrences. This means that while the mushrooms of the same species typically grow in a given area, there is no guarantee of the amount. Thus, this should not be seen as a guide to finding any particular amount of a given mushroom but rather its existence in an area.</p>
<p>Another risk is that the mushroom-related data is user-entered and as such could be erroneous or even outright false. However, there would be no perceivable benefit to falsifying this type of data so I do not forsee this being a major issue. I will need to monitor for gross anomolies in the data in cae this type of phenomenon exists.</p>
</div>

### <span style="color:white">Data Sources</span>
<div style="margin-left: 30px; margin-right: 30px;">
<p>
My main data source is a MySQL database dump that the curator for Mushroom Observer, a user-submitted mushroom documenting website, released to me. I also have data listing the species of mushrooms showcased at the San Francisco Fungus Fair (SFFF) and the general location where they were found. If possible, I intend to combine as much data as I can from different sources to create an even more robust dataset.
</p>
</div>
