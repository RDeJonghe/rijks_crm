# rijks_crm

<h2>About Rijks CRM</h2>
<p>Rijks CRM is beta version of a customer relationship management tool.</p>
<h3>Getting Started</h3>
<ul>
  <li class="list_item">Go to the inventory to see the artists and works available in Rijks CRM</li>
  <li class="list_item">Create a few clients and edit their information if needed - follow intended formatting - the beta version does not validate input</li>
  <li class="list_item">Use the search tool to search clients</li>
  <li class="list_item">Create a few interactions and delete if necessary</li>
  <li class="list_item">Sign in the admin page with the password "orange" and delete the created client records</li>
</ul>
<h3>Technical Info</h3>
<p>Rijks CRM persists data through the use of sessions and is not connected to a data store. The server logic of Rijks CRM is written in Ruby. It is uses the Rack-based Sinatra framework and the web server Puma. Images in the Rijks CRM are fetched from the API of the <a href="https://data.rijksmuseum.nl/object-metadata/api/" target="_blank">Rijksmuseum</a> in Amsterdam, Netherlands in accordance with their <a href="https://www.rijksmuseum.nl/en/research/conduct-research/data/policy" target="_blank">open data policy.</a></p>
<h3>Forthcoming</h3>
<p>A future version of Rijks CRM will connect to a database and provide input validation. Additionally, a purchase feature will be implemented which will allow for a work of art to be purchased by a client and move from the inventory to client purchases. In this final version Rijks CRM will be able to track client information, the interactions with the clients, as well as their purchases. Since the API of the Rijksmuseum allows for access to images and data a relevant model of the product and purchase transaction is possible within the context of a CRM.</p>
