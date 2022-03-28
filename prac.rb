require 'httparty'
require 'json'

class Bosch
  BOSCH_API_CALL = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Jheronimus+Bosch&imgonly=True&p=0-9999&s=chronologic')

  BOSCH_ART_OBJECTS = JSON.parse(BOSCH_API_CALL.body)["artObjects"]

  def titles
    BOSCH_ART_OBJECTS.each_with_object([]) do |art_obj, results|
      results << { title: art_obj["title"], id: art_obj["id"] }
    end
  end

  def image(id)
    BOSCH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["webImage"]["url"]
  end

  def work_title(id)
    BOSCH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["title"]
  end

  def produced(id)
    BOSCH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["longTitle"]
    .split(", ")
    .last
  end
end

bosch = Bosch.new

p bosch.titles

# class VanGogh
#   API_CALL = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Vincent+van+Gogh&imgonly=True&p=0-9999&s=chronologic')

#   VAN_GOGH_ART_OBJECTS = JSON.parse(API_CALL.body)["artObjects"]

#   def self.api_call
#     response = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Vincent+van+Gogh&imgonly=True&p=0-9999&s=chronologic')
    
#     response 
#   end

#   def titles
#     VAN_GOGH_ART_OBJECTS.each_with_object([]) do |art_obj, results|
#       results << { title: art_obj["title"], id: art_obj["id"] }
#     end
#   end

#   def image(id)
#     VAN_GOGH_ART_OBJECTS.select do |art_obj|
#       art_obj["id"] == id
#     end
#     .first["webImage"]["url"]
#   end

#   def work_title(id)
#     VAN_GOGH_ART_OBJECTS.select do |art_obj|
#       art_obj["id"] == id
#     end
#     .first["title"]
#   end

#   def produced(id)
#     VAN_GOGH_ART_OBJECTS.select do |art_obj|
#       art_obj["id"] == id
#     end
#     .first["longTitle"]
#     .split(", ")
#     .last
#   end
# end


# ARTISTS_OBJ = {
#   van_gogh: VanGogh.api_call
# }


# result = ARTISTS_OBJ[:van_gogh]
# # p result

# vg = VanGogh.new.titles

# p vg
