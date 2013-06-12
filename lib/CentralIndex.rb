require 'net/http'
require "rubygems"
require "json"

# global to hold the api key
$apiKey = ""

class CentralIndex
  
  # constructor
  def initialize(apiKey, debugMode)
    @apiKey    = apiKey
    @debugMode = debugMode
  end
  
  # make 'curl' request to the api server
  def doCurl(method,path,params)
    # api constants
    domain = 'api.centralindex.com'
    endpoint = '/v1'
    path = endpoint+path
    params['api_key'] = @apiKey
    retval = ''

    # create an HTTP connection
    http = Net::HTTP.new(domain) 
    if @debugMode
      http.set_debug_output $stderr
    end

    if(method == 'get') 
      # crazy dance to get urlencode parameters from Ruby
      request = Net::HTTP::Get.new(path) 
      request.set_form_data( params, sep = '&' )
      request = Net::HTTP::Get.new( path+ '?' + request.body )
      retval = http.request(request)
    end
    if(method == 'post')
      request = Net::HTTP::Post.new(path)
      request.set_form_data(params)
      retval = http.request(request)
    end
    if(method == 'put')
      request = Net::HTTP::Put.new(path)
      request.set_form_data(params)
      retval = http.request(request)
    end
    if(method == 'delete')
      request = Net::HTTP::Put.new(path)
      request.set_form_data(params)
      retval = http.request(request)
    end
    parsed = JSON.parse(retval.body)
    if(parsed)
      return parsed
    else
      return retval.body
    end
  end


  #
  # Confirms that the API is active, and returns the current version number
  #
  #  @return - the data from the api
  #
  def getStatus()
    params = Hash.new
    return doCurl("get","/status",params)
  end


  #
  # Fetch the project logo, the symbol of the Wolf
  #
  #  @param a
  #  @param b
  #  @param c
  #  @param d
  #  @return - the data from the api
  #
  def getLogo( a, b, c, d)
    params = Hash.new
    params['a'] = a
    params['b'] = b
    params['c'] = c
    params['d'] = d
    return doCurl("get","/logo",params)
  end


  #
  # Fetch the project logo, the symbol of the Wolf
  #
  #  @param a
  #  @return - the data from the api
  #
  def putLogo( a)
    params = Hash.new
    params['a'] = a
    return doCurl("put","/logo",params)
  end


  #
  # Uploads a CSV file of known format and bulk inserts into DB
  #
  #  @param filedata
  #  @return - the data from the api
  #
  def postEntityBulkCsv( filedata)
    params = Hash.new
    params['filedata'] = filedata
    return doCurl("post","/entity/bulk/csv",params)
  end


  #
  # Uploads a JSON file of known format and bulk inserts into DB
  #
  #  @param data
  #  @return - the data from the api
  #
  def postEntityBulkJson( data)
    params = Hash.new
    params['data'] = data
    return doCurl("post","/entity/bulk/json",params)
  end


  #
  # Shows the current status of a bulk upload
  #
  #  @param upload_id
  #  @return - the data from the api
  #
  def getEntityBulkCsvStatus( upload_id)
    params = Hash.new
    params['upload_id'] = upload_id
    return doCurl("get","/entity/bulk/csv/status",params)
  end


  #
  # Shows the current status of a bulk JSON upload
  #
  #  @param upload_id
  #  @return - the data from the api
  #
  def getEntityBulkJsonStatus( upload_id)
    params = Hash.new
    params['upload_id'] = upload_id
    return doCurl("get","/entity/bulk/json/status",params)
  end


  #
  # This entity isn't really supported anymore. You probably want PUT /business. Only to be used for testing.
  #
  #  @param type
  #  @param scope
  #  @param country
  #  @param trust
  #  @param our_data
  #  @return - the data from the api
  #
  def putEntity( type, scope, country, trust, our_data)
    params = Hash.new
    params['type'] = type
    params['scope'] = scope
    params['country'] = country
    params['trust'] = trust
    params['our_data'] = our_data
    return doCurl("put","/entity",params)
  end


  #
  # Fetches the documents that match the given masheryid and supplier_id
  #
  #  @param supplier_id - The Supplier ID
  #  @return - the data from the api
  #
  def getEntityBy_supplier_id( supplier_id)
    params = Hash.new
    params['supplier_id'] = supplier_id
    return doCurl("get","/entity/by_supplier_id",params)
  end


  #
  # Search for matching entities
  #
  #  @param what
  #  @param entity_name
  #  @param where
  #  @param per_page
  #  @param page
  #  @param longitude
  #  @param latitude
  #  @param country
  #  @param language
  #  @return - the data from the api
  #
  def getEntitySearch( what, entity_name, where, per_page, page, longitude, latitude, country, language)
    params = Hash.new
    params['what'] = what
    params['entity_name'] = entity_name
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['longitude'] = longitude
    params['latitude'] = latitude
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param where - The location to get results for. E.g. Dublin e.g. Dublin
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def getEntitySearchWhatBylocation( what, where, per_page, page, country, language)
    params = Hash.new
    params['what'] = what
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/what/bylocation",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param latitude_1 - Latitude of first point in bounding box e.g. 53.396842
  #  @param longitude_1 - Longitude of first point in bounding box e.g. -6.37619
  #  @param latitude_2 - Latitude of second point in bounding box e.g. 53.290463
  #  @param longitude_2 - Longitude of second point in bounding box e.g. -6.207275
  #  @param per_page
  #  @param page
  #  @param country - A valid ISO 3166 country code e.g. ie
  #  @param language
  #  @return - the data from the api
  #
  def getEntitySearchWhatByboundingbox( what, latitude_1, longitude_1, latitude_2, longitude_2, per_page, page, country, language)
    params = Hash.new
    params['what'] = what
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/what/byboundingbox",params)
  end


  #
  # Search for matching entities
  #
  #  @param who
  #  @param latitude_1
  #  @param longitude_1
  #  @param latitude_2
  #  @param longitude_2
  #  @param per_page
  #  @param page
  #  @param country
  #  @return - the data from the api
  #
  def getEntitySearchWhoByboundingbox( who, latitude_1, longitude_1, latitude_2, longitude_2, per_page, page, country)
    params = Hash.new
    params['who'] = who
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    return doCurl("get","/entity/search/who/byboundingbox",params)
  end


  #
  # Search for matching entities
  #
  #  @param who - Company Name e.g. Starbucks
  #  @param where - The location to get results for. E.g. Dublin e.g. Dublin
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @return - the data from the api
  #
  def getEntitySearchWhoBylocation( who, where, per_page, page, country)
    params = Hash.new
    params['who'] = who
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    return doCurl("get","/entity/search/who/bylocation",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param per_page - Number of results returned per page
  #  @param page - The page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def getEntitySearchWhat( what, per_page, page, country, language)
    params = Hash.new
    params['what'] = what
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/what",params)
  end


  #
  # Search for matching entities
  #
  #  @param who - Company name e.g. Starbucks
  #  @param per_page - How many results per page
  #  @param page - What page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @return - the data from the api
  #
  def getEntitySearchWho( who, per_page, page, country)
    params = Hash.new
    params['who'] = who
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    return doCurl("get","/entity/search/who",params)
  end


  #
  # Search for matching entities
  #
  #  @param where - Location to search for results. E.g. Dublin e.g. Dublin
  #  @param per_page - How many results per page
  #  @param page - What page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def getEntitySearchBylocation( where, per_page, page, country, language)
    params = Hash.new
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/bylocation",params)
  end


  #
  # Search for matching entities
  #
  #  @param latitude_1
  #  @param longitude_1
  #  @param latitude_2
  #  @param longitude_2
  #  @param per_page
  #  @param page
  #  @param country
  #  @param language
  #  @return - the data from the api
  #
  def getEntitySearchByboundingbox( latitude_1, longitude_1, latitude_2, longitude_2, per_page, page, country, language)
    params = Hash.new
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/byboundingbox",params)
  end


  #
  # Search for matching entities that are advertisers and return a random selection upto the limit requested
  #
  #  @param tag - The word or words the advertiser is to appear for in searches
  #  @param where - The location to get results for. E.g. Dublin
  #  @param limit - The number of advertisers that are to be returned
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def getEntityAdvertisers( tag, where, limit, country, language)
    params = Hash.new
    params['tag'] = tag
    params['where'] = where
    params['limit'] = limit
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/advertisers",params)
  end


  #
  # Allows a whole entity to be pulled from the datastore by its unique id
  #
  #  @param entity_id - The unique entity ID e.g. 379236608286720
  #  @return - the data from the api
  #
  def getEntity( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity",params)
  end


  #
  # Get all entiies claimed by a specific user
  #
  #  @param user_id - The unique user ID of the user with claimed entities e.g. 379236608286720
  #  @return - the data from the api
  #
  def getEntityBy_user_id( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/entity/by_user_id",params)
  end


  #
  # Allows a list of available revisions to be returned by its entity id
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def getEntityRevisions( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity/revisions",params)
  end


  #
  # Allows a specific revision of an entity to be returned by entity id and a revision number
  #
  #  @param entity_id
  #  @param revision_id
  #  @return - the data from the api
  #
  def getEntityRevisionsByRevisionID( entity_id, revision_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['revision_id'] = revision_id
    return doCurl("get","/entity/revisions/byRevisionID",params)
  end


  #
  # Separates an entity into two distinct entities 
  #
  #  @param entity_id
  #  @param supplier_masheryid
  #  @param supplier_id
  #  @return - the data from the api
  #
  def postEntityUnmerge( entity_id, supplier_masheryid, supplier_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['supplier_masheryid'] = supplier_masheryid
    params['supplier_id'] = supplier_id
    return doCurl("post","/entity/unmerge",params)
  end


  #
  # Fetches the changelog documents that match the given entity_id
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def getEntityChangelog( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity/changelog",params)
  end


  #
  # Merge two entities into one
  #
  #  @param from
  #  @param to
  #  @return - the data from the api
  #
  def postEntityMerge( from, to)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    return doCurl("post","/entity/merge",params)
  end


  #
  # Force refresh of search indexes
  #
  #  @return - the data from the api
  #
  def getToolsReindex()
    params = Hash.new
    return doCurl("get","/tools/reindex",params)
  end


  #
  # Update entities that use an old category ID to a new one
  #
  #  @param from
  #  @param to
  #  @param limit
  #  @return - the data from the api
  #
  def postEntityMigrate_category( from, to, limit)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['limit'] = limit
    return doCurl("post","/entity/migrate_category",params)
  end


  #
  # Create a new business entity with all it's objects
  #
  #  @param name
  #  @param building_number
  #  @param address1
  #  @param address2
  #  @param address3
  #  @param district
  #  @param town
  #  @param county
  #  @param postcode
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @param timezone
  #  @param telephone_number
  #  @param email
  #  @param website
  #  @param category_id
  #  @param category_type
  #  @param do_not_display
  #  @return - the data from the api
  #
  def putBusiness( name, building_number, address1, address2, address3, district, town, county, postcode, country, latitude, longitude, timezone, telephone_number, email, website, category_id, category_type, do_not_display)
    params = Hash.new
    params['name'] = name
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['postcode'] = postcode
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['timezone'] = timezone
    params['telephone_number'] = telephone_number
    params['email'] = email
    params['website'] = website
    params['category_id'] = category_id
    params['category_type'] = category_type
    params['do_not_display'] = do_not_display
    return doCurl("put","/business",params)
  end


  #
  # Allows the removal or insertion of tags into an advertiser object
  #
  #  @param gen_id - The gen_id of this advertiser
  #  @param entity_id - The entity_id of the advertiser
  #  @param language - The tag language to alter
  #  @param tags_to_add - The tags to add
  #  @param tags_to_remove - The tags to remove
  #  @return - the data from the api
  #
  def postEntityAdvertiserTag( gen_id, entity_id, language, tags_to_add, tags_to_remove)
    params = Hash.new
    params['gen_id'] = gen_id
    params['entity_id'] = entity_id
    params['language'] = language
    params['tags_to_add'] = tags_to_add
    params['tags_to_remove'] = tags_to_remove
    return doCurl("post","/entity/advertiser/tag",params)
  end


  #
  # Find a location from cache or cloudant depending if it is in the cache
  #
  #  @param string
  #  @param country
  #  @return - the data from the api
  #
  def getLookupLocation( string, country)
    params = Hash.new
    params['string'] = string
    params['country'] = country
    return doCurl("get","/lookup/location",params)
  end


  #
  # Find a category from cache or cloudant depending if it is in the cache
  #
  #  @param string - A string to search against, E.g. Plumbers
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def getLookupCategory( string, language)
    params = Hash.new
    params['string'] = string
    params['language'] = language
    return doCurl("get","/lookup/category",params)
  end


  #
  # Find a category from a legacy ID or supplier (e.g. bill_moss)
  #
  #  @param id
  #  @param type
  #  @return - the data from the api
  #
  def getLookupLegacyCategory( id, type)
    params = Hash.new
    params['id'] = id
    params['type'] = type
    return doCurl("get","/lookup/legacy/category",params)
  end


  #
  # Find all the parents locations of the selected location
  #
  #  @param location_id
  #  @return - the data from the api
  #
  def getLookupLocationParents( location_id)
    params = Hash.new
    params['location_id'] = location_id
    return doCurl("get","/lookup/location/parents",params)
  end


  #
  # Find all the child locations of the selected location
  #
  #  @param location_id
  #  @param resolution
  #  @return - the data from the api
  #
  def getLookupLocationChildren( location_id, resolution)
    params = Hash.new
    params['location_id'] = location_id
    params['resolution'] = resolution
    return doCurl("get","/lookup/location/children",params)
  end


  #
  # With a known entity id, a name can be updated.
  #
  #  @param entity_id
  #  @param name
  #  @param formal_name
  #  @return - the data from the api
  #
  def postEntityName( entity_id, name, formal_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['name'] = name
    params['formal_name'] = formal_name
    return doCurl("post","/entity/name",params)
  end


  #
  # With a known entity id, an background object can be added. There can however only be one background object.
  #
  #  @param entity_id
  #  @param number_of_employees
  #  @param turnover
  #  @param net_profit
  #  @param vat_number
  #  @param duns_number
  #  @param registered_company_number
  #  @return - the data from the api
  #
  def postEntityBackground( entity_id, number_of_employees, turnover, net_profit, vat_number, duns_number, registered_company_number)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number_of_employees'] = number_of_employees
    params['turnover'] = turnover
    params['net_profit'] = net_profit
    params['vat_number'] = vat_number
    params['duns_number'] = duns_number
    params['registered_company_number'] = registered_company_number
    return doCurl("post","/entity/background",params)
  end


  #
  # With a known entity id, an employee object can be added.
  #
  #  @param entity_id
  #  @param title
  #  @param forename
  #  @param surname
  #  @param job_title
  #  @param description
  #  @param email
  #  @param phone_number
  #  @return - the data from the api
  #
  def postEntityEmployee( entity_id, title, forename, surname, job_title, description, email, phone_number)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['forename'] = forename
    params['surname'] = surname
    params['job_title'] = job_title
    params['description'] = description
    params['email'] = email
    params['phone_number'] = phone_number
    return doCurl("post","/entity/employee",params)
  end


  #
  # Allows an employee object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityEmployee( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/employee",params)
  end


  #
  # Allows a new phone object to be added to a specified entity. A new object id will be calculated and returned to you if successful.
  #
  #  @param entity_id
  #  @param number
  #  @param description
  #  @return - the data from the api
  #
  def postEntityPhone( entity_id, number, description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
    params['description'] = description
    return doCurl("post","/entity/phone",params)
  end


  #
  # Allows a phone object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityPhone( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/phone",params)
  end


  #
  # With a known entity id, an fax object can be added.
  #
  #  @param entity_id
  #  @param number
  #  @param description
  #  @return - the data from the api
  #
  def postEntityFax( entity_id, number, description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
    params['description'] = description
    return doCurl("post","/entity/fax",params)
  end


  #
  # Allows a fax object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityFax( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/fax",params)
  end


  #
  # With a known category id, an category object can be added.
  #
  #  @param category_id
  #  @param language
  #  @param name
  #  @return - the data from the api
  #
  def putCategory( category_id, language, name)
    params = Hash.new
    params['category_id'] = category_id
    params['language'] = language
    params['name'] = name
    return doCurl("put","/category",params)
  end


  #
  # With a known category id, a mapping object can be added.
  #
  #  @param category_id
  #  @param type
  #  @param id
  #  @param name
  #  @return - the data from the api
  #
  def postCategoryMappings( category_id, type, id, name)
    params = Hash.new
    params['category_id'] = category_id
    params['type'] = type
    params['id'] = id
    params['name'] = name
    return doCurl("post","/category/mappings",params)
  end


  #
  # With a known category id, an synonym object can be added.
  #
  #  @param category_id
  #  @param synonym
  #  @param language
  #  @return - the data from the api
  #
  def postCategorySynonym( category_id, synonym, language)
    params = Hash.new
    params['category_id'] = category_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("post","/category/synonym",params)
  end


  #
  # With a known category id, a synonyms object can be removed.
  #
  #  @param category_id
  #  @param synonym
  #  @param language
  #  @return - the data from the api
  #
  def deleteCategorySynonym( category_id, synonym, language)
    params = Hash.new
    params['category_id'] = category_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("delete","/category/synonym",params)
  end


  #
  # Allows a category object to merged with another
  #
  #  @param from
  #  @param to
  #  @return - the data from the api
  #
  def postCategoryMerge( from, to)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    return doCurl("post","/category/merge",params)
  end


  #
  # Returns the supplied wolf category object by fetching the supplied category_id from our categories object.
  #
  #  @param category_id
  #  @return - the data from the api
  #
  def getCategory( category_id)
    params = Hash.new
    params['category_id'] = category_id
    return doCurl("get","/category",params)
  end


  #
  # With a known entity id, an category object can be added.
  #
  #  @param entity_id
  #  @param category_id
  #  @param category_type
  #  @return - the data from the api
  #
  def postEntityCategory( entity_id, category_id, category_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['category_id'] = category_id
    params['category_type'] = category_type
    return doCurl("post","/entity/category",params)
  end


  #
  # Allows a category object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityCategory( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/category",params)
  end


  #
  # With a known entity id, a geopoint can be updated.
  #
  #  @param entity_id
  #  @param longitude
  #  @param latitude
  #  @param accuracy
  #  @return - the data from the api
  #
  def postEntityGeopoint( entity_id, longitude, latitude, accuracy)
    params = Hash.new
    params['entity_id'] = entity_id
    params['longitude'] = longitude
    params['latitude'] = latitude
    params['accuracy'] = accuracy
    return doCurl("post","/entity/geopoint",params)
  end


  #
  # Find all matches by phone number and then return all matches that also match company name and location. Default location_strictness is defined in Km and the default is set to 0.2 (200m)
  #
  #  @param phone
  #  @param company_name
  #  @param latitude
  #  @param longitude
  #  @param country
  #  @param name_strictness
  #  @param location_strictness
  #  @return - the data from the api
  #
  def getMatchByphone( phone, company_name, latitude, longitude, country, name_strictness, location_strictness)
    params = Hash.new
    params['phone'] = phone
    params['company_name'] = company_name
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['country'] = country
    params['name_strictness'] = name_strictness
    params['location_strictness'] = location_strictness
    return doCurl("get","/match/byphone",params)
  end


  #
  # Find all matches by location and then return all matches that also match company name. Default location_strictness is set to 7, which equates to +/- 20m
  #
  #  @param company_name
  #  @param latitude
  #  @param longitude
  #  @param name_strictness
  #  @param location_strictness
  #  @return - the data from the api
  #
  def getMatchBylocation( company_name, latitude, longitude, name_strictness, location_strictness)
    params = Hash.new
    params['company_name'] = company_name
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['name_strictness'] = name_strictness
    params['location_strictness'] = location_strictness
    return doCurl("get","/match/bylocation",params)
  end


  #
  # Removes stopwords from a string
  #
  #  @param text
  #  @return - the data from the api
  #
  def getToolsStopwords( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/stopwords",params)
  end


  #
  # Returns a stemmed version of a string
  #
  #  @param text
  #  @return - the data from the api
  #
  def getToolsStem( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/stem",params)
  end


  #
  # Return the phonetic representation of a string
  #
  #  @param text
  #  @return - the data from the api
  #
  def getToolsPhonetic( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/phonetic",params)
  end


  #
  # Fully process a string. This includes removing punctuation, stops words and stemming a string. Also returns the phonetic representation of this string.
  #
  #  @param text
  #  @return - the data from the api
  #
  def getToolsProcess_string( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/process_string",params)
  end


  #
  # Attempt to process a phone number, removing anything which is not a digit
  #
  #  @param number
  #  @return - the data from the api
  #
  def getToolsProcess_phone( number)
    params = Hash.new
    params['number'] = number
    return doCurl("get","/tools/process_phone",params)
  end


  #
  # Spider a single url looking for key facts
  #
  #  @param url
  #  @param pages
  #  @param country
  #  @return - the data from the api
  #
  def getToolsSpider( url, pages, country)
    params = Hash.new
    params['url'] = url
    params['pages'] = pages
    params['country'] = country
    return doCurl("get","/tools/spider",params)
  end


  #
  # Supply an address to geocode - returns lat/lon and accuracy
  #
  #  @param building_number
  #  @param address1
  #  @param address2
  #  @param address3
  #  @param district
  #  @param town
  #  @param county
  #  @param postcode
  #  @param country
  #  @return - the data from the api
  #
  def getToolsGeocode( building_number, address1, address2, address3, district, town, county, postcode, country)
    params = Hash.new
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['postcode'] = postcode
    params['country'] = country
    return doCurl("get","/tools/geocode",params)
  end


  #
  # Generate JSON in the format to generate Mashery's IODocs
  #
  #  @param mode - The HTTP method of the API call to document. e.g. GET
  #  @param path - The path of the API call to document e.g, /entity
  #  @param endpoint - The Mashery 'endpoint' to prefix to our API paths e.g. v1
  #  @param doctype - Mashery has two forms of JSON to describe API methods; one on github, the other on its customer dashboard
  #  @return - the data from the api
  #
  def getToolsIodocs( mode, path, endpoint, doctype)
    params = Hash.new
    params['mode'] = mode
    params['path'] = path
    params['endpoint'] = endpoint
    params['doctype'] = doctype
    return doCurl("get","/tools/iodocs",params)
  end


  #
  # Use this call to get information (in HTML or JSON) about the data structure of given entity object (e.g. a phone number or an address)
  #
  #  @param object - The API call documentation is required for
  #  @param format - The format of the returned data eg. JSON or HTML
  #  @return - the data from the api
  #
  def getToolsDocs( object, format)
    params = Hash.new
    params['object'] = object
    params['format'] = format
    return doCurl("get","/tools/docs",params)
  end


  #
  # Format a phone number according to the rules of the country supplied
  #
  #  @param number - The telephone number to format
  #  @param country - The country where the telephone number is based
  #  @return - the data from the api
  #
  def getToolsFormatPhone( number, country)
    params = Hash.new
    params['number'] = number
    params['country'] = country
    return doCurl("get","/tools/format/phone",params)
  end


  #
  # Format an address according to the rules of the country supplied
  #
  #  @param address - The address to format
  #  @param country - The country where the address is based
  #  @return - the data from the api
  #
  def getToolsFormatAddress( address, country)
    params = Hash.new
    params['address'] = address
    params['country'] = country
    return doCurl("get","/tools/format/address",params)
  end


  #
  # Check to see if a supplied email address is valid
  #
  #  @param email_address - The email address to validate
  #  @return - the data from the api
  #
  def getToolsValidate_email( email_address)
    params = Hash.new
    params['email_address'] = email_address
    return doCurl("get","/tools/validate_email",params)
  end


  #
  # compile the supplied less with the standard Bootstrap less into a CSS file
  #
  #  @param less - The LESS code to compile
  #  @return - the data from the api
  #
  def getToolsLess( less)
    params = Hash.new
    params['less'] = less
    return doCurl("get","/tools/less",params)
  end


  #
  # replace some text parameters with some entity details
  #
  #  @param entity_id - The entity to pull for replacements
  #  @param string - The string full of parameters
  #  @return - the data from the api
  #
  def getToolsReplace( entity_id, string)
    params = Hash.new
    params['entity_id'] = entity_id
    params['string'] = string
    return doCurl("get","/tools/replace",params)
  end


  #
  # Check to see if a supplied email address is valid
  #
  #  @param from - The phone number from which the SMS orginates
  #  @param to - The phone number to which the SMS is to be sent
  #  @param message - The message to be sent in the SMS
  #  @return - the data from the api
  #
  def getToolsSendsms( from, to, message)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['message'] = message
    return doCurl("get","/tools/sendsms",params)
  end


  #
  # Given a spreadsheet id add a row
  #
  #  @param spreadsheet_key - The key of the spreadsheet to edit
  #  @param data - A comma separated list to add as cells
  #  @return - the data from the api
  #
  def postToolsGooglesheetAdd_row( spreadsheet_key, data)
    params = Hash.new
    params['spreadsheet_key'] = spreadsheet_key
    params['data'] = data
    return doCurl("post","/tools/googlesheet/add_row",params)
  end


  #
  # With a known entity id, an invoice_address object can be updated.
  #
  #  @param entity_id
  #  @param building_number
  #  @param address1
  #  @param address2
  #  @param address3
  #  @param district
  #  @param town
  #  @param county
  #  @param postcode
  #  @param address_type
  #  @return - the data from the api
  #
  def postEntityInvoice_address( entity_id, building_number, address1, address2, address3, district, town, county, postcode, address_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['postcode'] = postcode
    params['address_type'] = address_type
    return doCurl("post","/entity/invoice_address",params)
  end


  #
  # With a known entity id and a known invoice_address ID, we can delete a specific invoice_address object from an enitity.
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def deleteEntityInvoice_address( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/invoice_address",params)
  end


  #
  # With a known entity id, an tag object can be added.
  #
  #  @param entity_id
  #  @param tag
  #  @param language
  #  @return - the data from the api
  #
  def postEntityTag( entity_id, tag, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tag'] = tag
    params['language'] = language
    return doCurl("post","/entity/tag",params)
  end


  #
  # Allows a tag object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityTag( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/tag",params)
  end


  #
  # Create/Update a postal address
  #
  #  @param entity_id
  #  @param building_number
  #  @param address1
  #  @param address2
  #  @param address3
  #  @param district
  #  @param town
  #  @param county
  #  @param postcode
  #  @param address_type
  #  @param do_not_display
  #  @return - the data from the api
  #
  def postEntityPostal_address( entity_id, building_number, address1, address2, address3, district, town, county, postcode, address_type, do_not_display)
    params = Hash.new
    params['entity_id'] = entity_id
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['postcode'] = postcode
    params['address_type'] = address_type
    params['do_not_display'] = do_not_display
    return doCurl("post","/entity/postal_address",params)
  end


  #
  # With a known entity id, a advertiser is added
  #
  #  @param entity_id
  #  @param tags
  #  @param locations
  #  @param max_tags
  #  @param max_locations
  #  @param expiry_date
  #  @param is_national
  #  @param language
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def postEntityAdvertiserCreate( entity_id, tags, locations, max_tags, max_locations, expiry_date, is_national, language, reseller_ref, reseller_agent_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tags'] = tags
    params['locations'] = locations
    params['max_tags'] = max_tags
    params['max_locations'] = max_locations
    params['expiry_date'] = expiry_date
    params['is_national'] = is_national
    params['language'] = language
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/entity/advertiser/create",params)
  end


  #
  # With a known entity id, an advertiser is updated
  #
  #  @param entity_id
  #  @param tags
  #  @param locations
  #  @param extra_tags
  #  @param extra_locations
  #  @param is_national
  #  @param language
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def postEntityAdvertiserUpsell( entity_id, tags, locations, extra_tags, extra_locations, is_national, language, reseller_ref, reseller_agent_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tags'] = tags
    params['locations'] = locations
    params['extra_tags'] = extra_tags
    params['extra_locations'] = extra_locations
    params['is_national'] = is_national
    params['language'] = language
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/entity/advertiser/upsell",params)
  end


  #
  # Expires an advertiser from and entity
  #
  #  @param entity_id
  #  @param publisher_id
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @return - the data from the api
  #
  def postEntityAdvertiserCancel( entity_id, publisher_id, reseller_ref, reseller_agent_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    return doCurl("post","/entity/advertiser/cancel",params)
  end


  #
  # Renews an advertiser from an entity
  #
  #  @param entity_id
  #  @param expiry_date
  #  @param publisher_id
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @return - the data from the api
  #
  def postEntityAdvertiserRenew( entity_id, expiry_date, publisher_id, reseller_ref, reseller_agent_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['expiry_date'] = expiry_date
    params['publisher_id'] = publisher_id
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    return doCurl("post","/entity/advertiser/renew",params)
  end


  #
  # Allows an advertiser object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityAdvertiser( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/advertiser",params)
  end


  #
  # Adds/removes locations
  #
  #  @param entity_id
  #  @param gen_id
  #  @param locations_to_add
  #  @param locations_to_remove
  #  @return - the data from the api
  #
  def postEntityAdvertiserLocation( entity_id, gen_id, locations_to_add, locations_to_remove)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['locations_to_add'] = locations_to_add
    params['locations_to_remove'] = locations_to_remove
    return doCurl("post","/entity/advertiser/location",params)
  end


  #
  # With a known entity id, an email address object can be added.
  #
  #  @param entity_id
  #  @param email_address
  #  @param email_description
  #  @return - the data from the api
  #
  def postEntityEmail( entity_id, email_address, email_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['email_address'] = email_address
    params['email_description'] = email_description
    return doCurl("post","/entity/email",params)
  end


  #
  # Allows a email object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityEmail( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/email",params)
  end


  #
  # With a known entity id, a website object can be added.
  #
  #  @param entity_id
  #  @param website_url
  #  @param display_url
  #  @param website_description
  #  @return - the data from the api
  #
  def postEntityWebsite( entity_id, website_url, display_url, website_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['website_url'] = website_url
    params['display_url'] = display_url
    params['website_description'] = website_description
    return doCurl("post","/entity/website",params)
  end


  #
  # Allows a website object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityWebsite( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/website",params)
  end


  #
  # With a known entity id, a image object can be added.
  #
  #  @param entity_id
  #  @param filedata
  #  @param image_name
  #  @return - the data from the api
  #
  def postEntityImage( entity_id, filedata, image_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['filedata'] = filedata
    params['image_name'] = image_name
    return doCurl("post","/entity/image",params)
  end


  #
  # Allows a image object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityImage( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/image",params)
  end


  #
  # Read a location with the supplied ID in the locations reference database.
  #
  #  @param location_id
  #  @return - the data from the api
  #
  def getLocation( location_id)
    params = Hash.new
    params['location_id'] = location_id
    return doCurl("get","/location",params)
  end


  #
  # Read multiple locations with the supplied ID in the locations reference database.
  #
  #  @param location_ids
  #  @return - the data from the api
  #
  def getLocationMultiple( location_ids)
    params = Hash.new
    params['location_ids'] = location_ids
    return doCurl("get","/location/multiple",params)
  end


  #
  # Create/update a new location entity with the supplied ID in the locations reference database.
  #
  #  @param location_id
  #  @param name
  #  @param formal_name
  #  @param latitude
  #  @param longitude
  #  @param resolution
  #  @param country
  #  @param population
  #  @param description
  #  @param timezone
  #  @param is_duplicate
  #  @param is_default
  #  @param parent_town
  #  @param parent_county
  #  @param parent_province
  #  @param parent_region
  #  @param parent_neighbourhood
  #  @param parent_district
  #  @param postalcode
  #  @return - the data from the api
  #
  def postLocation( location_id, name, formal_name, latitude, longitude, resolution, country, population, description, timezone, is_duplicate, is_default, parent_town, parent_county, parent_province, parent_region, parent_neighbourhood, parent_district, postalcode)
    params = Hash.new
    params['location_id'] = location_id
    params['name'] = name
    params['formal_name'] = formal_name
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['resolution'] = resolution
    params['country'] = country
    params['population'] = population
    params['description'] = description
    params['timezone'] = timezone
    params['is_duplicate'] = is_duplicate
    params['is_default'] = is_default
    params['parent_town'] = parent_town
    params['parent_county'] = parent_county
    params['parent_province'] = parent_province
    params['parent_region'] = parent_region
    params['parent_neighbourhood'] = parent_neighbourhood
    params['parent_district'] = parent_district
    params['postalcode'] = postalcode
    return doCurl("post","/location",params)
  end


  #
  # Add a new synonym to a known location
  #
  #  @param location_id
  #  @param synonym
  #  @param language
  #  @return - the data from the api
  #
  def postLocationSynonym( location_id, synonym, language)
    params = Hash.new
    params['location_id'] = location_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("post","/location/synonym",params)
  end


  #
  # Remove a new synonym from a known location
  #
  #  @param location_id
  #  @param synonym
  #  @param language
  #  @return - the data from the api
  #
  def deleteLocationSynonym( location_id, synonym, language)
    params = Hash.new
    params['location_id'] = location_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("delete","/location/synonym",params)
  end


  #
  # Add a new source to a known location
  #
  #  @param location_id
  #  @param type
  #  @param url
  #  @param ref
  #  @return - the data from the api
  #
  def postLocationSource( location_id, type, url, ref)
    params = Hash.new
    params['location_id'] = location_id
    params['type'] = type
    params['url'] = url
    params['ref'] = ref
    return doCurl("post","/location/source",params)
  end


  #
  # With a known entity id, a status object can be updated.
  #
  #  @param entity_id
  #  @param status
  #  @return - the data from the api
  #
  def postEntityStatus( entity_id, status)
    params = Hash.new
    params['entity_id'] = entity_id
    params['status'] = status
    return doCurl("post","/entity/status",params)
  end


  #
  # With a known entity id, a logo object can be added.
  #
  #  @param entity_id
  #  @param filedata
  #  @param logo_name
  #  @return - the data from the api
  #
  def postEntityLogo( entity_id, filedata, logo_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['filedata'] = filedata
    params['logo_name'] = logo_name
    return doCurl("post","/entity/logo",params)
  end


  #
  # Allows a phone object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityLogo( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/logo",params)
  end


  #
  # With a known entity id, a YouTube video object can be added.
  #
  #  @param entity_id
  #  @param embed_code
  #  @return - the data from the api
  #
  def postEntityVideoYoutube( entity_id, embed_code)
    params = Hash.new
    params['entity_id'] = entity_id
    params['embed_code'] = embed_code
    return doCurl("post","/entity/video/youtube",params)
  end


  #
  # Allows a video object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityVideo( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/video",params)
  end


  #
  # With a known entity id, an affiliate link object can be added.
  #
  #  @param entity_id
  #  @param affiliate_name
  #  @param affiliate_link
  #  @param affiliate_message
  #  @param affiliate_logo
  #  @return - the data from the api
  #
  def postEntityAffiliate_link( entity_id, affiliate_name, affiliate_link, affiliate_message, affiliate_logo)
    params = Hash.new
    params['entity_id'] = entity_id
    params['affiliate_name'] = affiliate_name
    params['affiliate_link'] = affiliate_link
    params['affiliate_message'] = affiliate_message
    params['affiliate_logo'] = affiliate_logo
    return doCurl("post","/entity/affiliate_link",params)
  end


  #
  # Allows an affiliate link object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityAffiliate_link( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/affiliate_link",params)
  end


  #
  # With a known entity id, a description object can be added.
  #
  #  @param entity_id
  #  @param headline
  #  @param body
  #  @return - the data from the api
  #
  def postEntityDescription( entity_id, headline, body)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    return doCurl("post","/entity/description",params)
  end


  #
  # Allows a description object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityDescription( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/description",params)
  end


  #
  # With a known entity id, a list description object can be added.
  #
  #  @param entity_id
  #  @param headline
  #  @param body
  #  @return - the data from the api
  #
  def postEntityList( entity_id, headline, body)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    return doCurl("post","/entity/list",params)
  end


  #
  # Allows a list description object to be reduced in confidence
  #
  #  @param gen_id
  #  @param entity_id
  #  @return - the data from the api
  #
  def deleteEntityList( gen_id, entity_id)
    params = Hash.new
    params['gen_id'] = gen_id
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/list",params)
  end


  #
  # With a known entity id, an document object can be added.
  #
  #  @param entity_id
  #  @param name
  #  @param filedata
  #  @return - the data from the api
  #
  def postEntityDocument( entity_id, name, filedata)
    params = Hash.new
    params['entity_id'] = entity_id
    params['name'] = name
    params['filedata'] = filedata
    return doCurl("post","/entity/document",params)
  end


  #
  # Allows a phone object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityDocument( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/document",params)
  end


  #
  # With a known entity id, a testimonial object can be added.
  #
  #  @param entity_id
  #  @param title
  #  @param text
  #  @param date
  #  @param testifier_name
  #  @return - the data from the api
  #
  def postEntityTestimonial( entity_id, title, text, date, testifier_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['text'] = text
    params['date'] = date
    params['testifier_name'] = testifier_name
    return doCurl("post","/entity/testimonial",params)
  end


  #
  # Allows a testimonial object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityTestimonial( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/testimonial",params)
  end


  #
  # With a known entity id, a opening times object can be added. Each day can be either 'closed' to indicate that the entity is closed that day, '24hour' to indicate that the entity is open all day or single/split time ranges can be supplied in 4-digit 24-hour format, such as '09001730' or '09001200,13001700' to indicate hours of opening.
  #
  #  @param entity_id - The id of the entity to edit
  #  @param monday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param tuesday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param wednesday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param thursday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param friday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param saturday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param sunday - e.g. 'closed', '24hour' , '09001730' , '09001200,13001700'
  #  @param closed - a comma-separated list of dates that the entity is closed e.g. '2013-04-29,2013-05-02'
  #  @param closed_public_holidays - whether the entity is closed on public holidays
  #  @return - the data from the api
  #
  def postEntityOpening_times( entity_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, closed, closed_public_holidays)
    params = Hash.new
    params['entity_id'] = entity_id
    params['monday'] = monday
    params['tuesday'] = tuesday
    params['wednesday'] = wednesday
    params['thursday'] = thursday
    params['friday'] = friday
    params['saturday'] = saturday
    params['sunday'] = sunday
    params['closed'] = closed
    params['closed_public_holidays'] = closed_public_holidays
    return doCurl("post","/entity/opening_times",params)
  end


  #
  # With a known entity id, a website object can be added.
  #
  #  @param entity_id
  #  @param title
  #  @param description
  #  @param terms
  #  @param start_date
  #  @param expiry_date
  #  @param url
  #  @param image_url
  #  @return - the data from the api
  #
  def postEntitySpecial_offer( entity_id, title, description, terms, start_date, expiry_date, url, image_url)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['description'] = description
    params['terms'] = terms
    params['start_date'] = start_date
    params['expiry_date'] = expiry_date
    params['url'] = url
    params['image_url'] = image_url
    return doCurl("post","/entity/special_offer",params)
  end


  #
  # Allows a special offer object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntitySpecial_offer( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/special_offer",params)
  end


  #
  # Update user based on email address or social_network/social_network_id
  #
  #  @param email
  #  @param first_name
  #  @param last_name
  #  @param active
  #  @param trust
  #  @param creation_date
  #  @param user_type
  #  @param social_network
  #  @param social_network_id
  #  @param reseller_admin_masheryid
  #  @return - the data from the api
  #
  def postUser( email, first_name, last_name, active, trust, creation_date, user_type, social_network, social_network_id, reseller_admin_masheryid)
    params = Hash.new
    params['email'] = email
    params['first_name'] = first_name
    params['last_name'] = last_name
    params['active'] = active
    params['trust'] = trust
    params['creation_date'] = creation_date
    params['user_type'] = user_type
    params['social_network'] = social_network
    params['social_network_id'] = social_network_id
    params['reseller_admin_masheryid'] = reseller_admin_masheryid
    return doCurl("post","/user",params)
  end


  #
  # With a unique email address an user can be retrieved
  #
  #  @param email
  #  @return - the data from the api
  #
  def getUserBy_email( email)
    params = Hash.new
    params['email'] = email
    return doCurl("get","/user/by_email",params)
  end


  #
  # With a unique ID address an user can be retrieved
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def getUser( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/user",params)
  end


  #
  # With a unique ID address an user can be retrieved
  #
  #  @param name
  #  @param id
  #  @return - the data from the api
  #
  def getUserBy_social_media( name, id)
    params = Hash.new
    params['name'] = name
    params['id'] = id
    return doCurl("get","/user/by_social_media",params)
  end


  #
  # Returns all the users that match the supplied reseller_admin_masheryid
  #
  #  @param reseller_admin_masheryid
  #  @return - the data from the api
  #
  def getUserBy_reseller_admin_masheryid( reseller_admin_masheryid)
    params = Hash.new
    params['reseller_admin_masheryid'] = reseller_admin_masheryid
    return doCurl("get","/user/by_reseller_admin_masheryid",params)
  end


  #
  # Removes reseller privileges from a specified user
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def postUserReseller_remove( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("post","/user/reseller_remove",params)
  end


  #
  # The search matches a category name on a given string and language.
  #
  #  @param str - A string to search against, E.g. Plumbers e.g. but
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @return - the data from the api
  #
  def getAutocompleteCategory( str, language)
    params = Hash.new
    params['str'] = str
    params['language'] = language
    return doCurl("get","/autocomplete/category",params)
  end


  #
  # The search matches a category name or synonym on a given string and language.
  #
  #  @param str - A string to search against, E.g. Plumbers e.g. but
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @return - the data from the api
  #
  def getAutocompleteKeyword( str, language)
    params = Hash.new
    params['str'] = str
    params['language'] = language
    return doCurl("get","/autocomplete/keyword",params)
  end


  #
  # The search matches a location name or synonym on a given string and language.
  #
  #  @param str - A string to search against, E.g. Dub e.g. dub
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @return - the data from the api
  #
  def getAutocompleteLocation( str, country)
    params = Hash.new
    params['str'] = str
    params['country'] = country
    return doCurl("get","/autocomplete/location",params)
  end


  #
  # The search matches a postcode to the supplied string
  #
  #  @param str - A string to search against, E.g. W1 e.g. W1
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. gb e.g. gb
  #  @return - the data from the api
  #
  def getAutocompletePostcode( str, country)
    params = Hash.new
    params['str'] = str
    params['country'] = country
    return doCurl("get","/autocomplete/postcode",params)
  end


  #
  # Create a queue item
  #
  #  @param queue_name
  #  @param data
  #  @return - the data from the api
  #
  def putQueue( queue_name, data)
    params = Hash.new
    params['queue_name'] = queue_name
    params['data'] = data
    return doCurl("put","/queue",params)
  end


  #
  # With a known queue id, a queue item can be removed.
  #
  #  @param queue_id
  #  @return - the data from the api
  #
  def deleteQueue( queue_id)
    params = Hash.new
    params['queue_id'] = queue_id
    return doCurl("delete","/queue",params)
  end


  #
  # Retrieve queue items.
  #
  #  @param limit
  #  @param queue_name
  #  @return - the data from the api
  #
  def getQueue( limit, queue_name)
    params = Hash.new
    params['limit'] = limit
    params['queue_name'] = queue_name
    return doCurl("get","/queue",params)
  end


  #
  # Unlock queue items.
  #
  #  @param queue_name
  #  @param seconds
  #  @return - the data from the api
  #
  def postQueueUnlock( queue_name, seconds)
    params = Hash.new
    params['queue_name'] = queue_name
    params['seconds'] = seconds
    return doCurl("post","/queue/unlock",params)
  end


  #
  # Add an error to a queue item
  #
  #  @param queue_id
  #  @param error
  #  @return - the data from the api
  #
  def postQueueError( queue_id, error)
    params = Hash.new
    params['queue_id'] = queue_id
    params['error'] = error
    return doCurl("post","/queue/error",params)
  end


  #
  # Find a queue item by its type and id
  #
  #  @param type
  #  @param id
  #  @return - the data from the api
  #
  def getQueueSearch( type, id)
    params = Hash.new
    params['type'] = type
    params['id'] = id
    return doCurl("get","/queue/search",params)
  end


  #
  # Create a new transaction
  #
  #  @param entity_id
  #  @param user_id
  #  @param basket_total
  #  @param basket
  #  @param currency
  #  @param notes
  #  @return - the data from the api
  #
  def putTransaction( entity_id, user_id, basket_total, basket, currency, notes)
    params = Hash.new
    params['entity_id'] = entity_id
    params['user_id'] = user_id
    params['basket_total'] = basket_total
    params['basket'] = basket
    params['currency'] = currency
    params['notes'] = notes
    return doCurl("put","/transaction",params)
  end


  #
  # Set a transactions status to inprogess
  #
  #  @param transaction_id
  #  @param paypal_setexpresscheckout
  #  @return - the data from the api
  #
  def postTransactionInprogress( transaction_id, paypal_setexpresscheckout)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_setexpresscheckout'] = paypal_setexpresscheckout
    return doCurl("post","/transaction/inprogress",params)
  end


  #
  # Set a transactions status to authorised
  #
  #  @param transaction_id
  #  @param paypal_getexpresscheckoutdetails
  #  @return - the data from the api
  #
  def postTransactionAuthorised( transaction_id, paypal_getexpresscheckoutdetails)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_getexpresscheckoutdetails'] = paypal_getexpresscheckoutdetails
    return doCurl("post","/transaction/authorised",params)
  end


  #
  # Set a transactions status to complete
  #
  #  @param transaction_id
  #  @param paypal_doexpresscheckoutpayment
  #  @param user_id
  #  @param entity_id
  #  @return - the data from the api
  #
  def postTransactionComplete( transaction_id, paypal_doexpresscheckoutpayment, user_id, entity_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_doexpresscheckoutpayment'] = paypal_doexpresscheckoutpayment
    params['user_id'] = user_id
    params['entity_id'] = entity_id
    return doCurl("post","/transaction/complete",params)
  end


  #
  # Set a transactions status to cancelled
  #
  #  @param transaction_id
  #  @return - the data from the api
  #
  def postTransactionCancelled( transaction_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    return doCurl("post","/transaction/cancelled",params)
  end


  #
  # Given a transaction_id retrieve information on it
  #
  #  @param transaction_id
  #  @return - the data from the api
  #
  def getTransaction( transaction_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    return doCurl("get","/transaction",params)
  end


  #
  # Given a transaction_id retrieve information on it
  #
  #  @param paypal_transaction_id
  #  @return - the data from the api
  #
  def getTransactionBy_paypal_transaction_id( paypal_transaction_id)
    params = Hash.new
    params['paypal_transaction_id'] = paypal_transaction_id
    return doCurl("get","/transaction/by_paypal_transaction_id",params)
  end


  #
  # Allow an entity to be claimed by a valid user
  #
  #  @param entity_id
  #  @param claimed_user_id
  #  @param claimed_date
  #  @param claim_method
  #  @param phone_number
  #  @return - the data from the api
  #
  def postEntityClaim( entity_id, claimed_user_id, claimed_date, claim_method, phone_number)
    params = Hash.new
    params['entity_id'] = entity_id
    params['claimed_user_id'] = claimed_user_id
    params['claimed_date'] = claimed_date
    params['claim_method'] = claim_method
    params['phone_number'] = phone_number
    return doCurl("post","/entity/claim",params)
  end


  #
  # Update/Add a publisher
  #
  #  @param publisher_id
  #  @param country
  #  @param name
  #  @param description
  #  @param active
  #  @return - the data from the api
  #
  def postPublisher( publisher_id, country, name, description, active)
    params = Hash.new
    params['publisher_id'] = publisher_id
    params['country'] = country
    params['name'] = name
    params['description'] = description
    params['active'] = active
    return doCurl("post","/publisher",params)
  end


  #
  # Delete a publisher with a specified publisher_id
  #
  #  @param publisher_id
  #  @return - the data from the api
  #
  def deletePublisher( publisher_id)
    params = Hash.new
    params['publisher_id'] = publisher_id
    return doCurl("delete","/publisher",params)
  end


  #
  # Returns publisher that matches a given publisher id
  #
  #  @param publisher_id
  #  @return - the data from the api
  #
  def getPublisher( publisher_id)
    params = Hash.new
    params['publisher_id'] = publisher_id
    return doCurl("get","/publisher",params)
  end


  #
  # Returns publisher that matches a given publisher id
  #
  #  @param country
  #  @return - the data from the api
  #
  def getPublisherByCountry( country)
    params = Hash.new
    params['country'] = country
    return doCurl("get","/publisher/byCountry",params)
  end


  #
  # Returns publishers that are available for a given entity_id.
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def getPublisherByEntityId( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/publisher/byEntityId",params)
  end


  #
  # Update/Add a country
  #
  #  @param country_id
  #  @param name
  #  @param synonyms
  #  @param continentName
  #  @param continent
  #  @param geonameId
  #  @param dbpediaURL
  #  @param freebaseURL
  #  @param population
  #  @param currencyCode
  #  @param languages
  #  @param areaInSqKm
  #  @param capital
  #  @param east
  #  @param west
  #  @param north
  #  @param south
  #  @param claimPrice
  #  @param claimMethods
  #  @return - the data from the api
  #
  def postCountry( country_id, name, synonyms, continentName, continent, geonameId, dbpediaURL, freebaseURL, population, currencyCode, languages, areaInSqKm, capital, east, west, north, south, claimPrice, claimMethods)
    params = Hash.new
    params['country_id'] = country_id
    params['name'] = name
    params['synonyms'] = synonyms
    params['continentName'] = continentName
    params['continent'] = continent
    params['geonameId'] = geonameId
    params['dbpediaURL'] = dbpediaURL
    params['freebaseURL'] = freebaseURL
    params['population'] = population
    params['currencyCode'] = currencyCode
    params['languages'] = languages
    params['areaInSqKm'] = areaInSqKm
    params['capital'] = capital
    params['east'] = east
    params['west'] = west
    params['north'] = north
    params['south'] = south
    params['claimPrice'] = claimPrice
    params['claimMethods'] = claimMethods
    return doCurl("post","/country",params)
  end


  #
  # Fetching a country
  #
  #  @param country_id
  #  @return - the data from the api
  #
  def getCountry( country_id)
    params = Hash.new
    params['country_id'] = country_id
    return doCurl("get","/country",params)
  end


  #
  # For insance, reporting a phone number as wrong
  #
  #  @param entity_id - A valid entity_id e.g. 379236608286720
  #  @param gen_id - The gen_id for the item being reported
  #  @param signal_type - The signal that is to be reported e.g. wrong
  #  @param data_type - The type of data being reported
  #  @return - the data from the api
  #
  def postSignal( entity_id, gen_id, signal_type, data_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['signal_type'] = signal_type
    params['data_type'] = data_type
    return doCurl("post","/signal",params)
  end


  #
  # Get the number of times an entity has been served out as an advert or on serps/bdp pages
  #
  #  @param entity_id - A valid entity_id e.g. 379236608286720
  #  @param year - The year to report on
  #  @param month - The month to report on
  #  @return - the data from the api
  #
  def getStatsEntityBy_date( entity_id, year, month)
    params = Hash.new
    params['entity_id'] = entity_id
    params['year'] = year
    params['month'] = month
    return doCurl("get","/stats/entity/by_date",params)
  end


  #
  # Update/Add a traction
  #
  #  @param traction_id
  #  @param trigger_type
  #  @param action_type
  #  @param country
  #  @param email_addresses
  #  @param title
  #  @param body
  #  @param api_method
  #  @param api_url
  #  @param api_params
  #  @param active
  #  @return - the data from the api
  #
  def postTraction( traction_id, trigger_type, action_type, country, email_addresses, title, body, api_method, api_url, api_params, active)
    params = Hash.new
    params['traction_id'] = traction_id
    params['trigger_type'] = trigger_type
    params['action_type'] = action_type
    params['country'] = country
    params['email_addresses'] = email_addresses
    params['title'] = title
    params['body'] = body
    params['api_method'] = api_method
    params['api_url'] = api_url
    params['api_params'] = api_params
    params['active'] = active
    return doCurl("post","/traction",params)
  end


  #
  # Fetching a traction
  #
  #  @param traction_id
  #  @return - the data from the api
  #
  def getTraction( traction_id)
    params = Hash.new
    params['traction_id'] = traction_id
    return doCurl("get","/traction",params)
  end


  #
  # Fetching active tractions
  #
  #  @return - the data from the api
  #
  def getTractionActive()
    params = Hash.new
    return doCurl("get","/traction/active",params)
  end


  #
  # Deleting a traction
  #
  #  @param traction_id
  #  @return - the data from the api
  #
  def deleteTraction( traction_id)
    params = Hash.new
    params['traction_id'] = traction_id
    return doCurl("delete","/traction",params)
  end


  #
  # Update/Add a message
  #
  #  @param message_id - Message id to pull
  #  @param ses_id - Aamazon email id
  #  @param from_user_id - User sending the message
  #  @param from_email - Sent from email address
  #  @param to_entity_id - The id of the entity being sent the message
  #  @param to_email - Sent from email address
  #  @param subject - Subject for the message
  #  @param body - Body for the message
  #  @param bounced - If the message bounced
  #  @return - the data from the api
  #
  def postMessage( message_id, ses_id, from_user_id, from_email, to_entity_id, to_email, subject, body, bounced)
    params = Hash.new
    params['message_id'] = message_id
    params['ses_id'] = ses_id
    params['from_user_id'] = from_user_id
    params['from_email'] = from_email
    params['to_entity_id'] = to_entity_id
    params['to_email'] = to_email
    params['subject'] = subject
    params['body'] = body
    params['bounced'] = bounced
    return doCurl("post","/message",params)
  end


  #
  # Fetching a message
  #
  #  @param message_id - The message id to pull the message for
  #  @return - the data from the api
  #
  def getMessage( message_id)
    params = Hash.new
    params['message_id'] = message_id
    return doCurl("get","/message",params)
  end


  #
  # Fetching messages by ses_id
  #
  #  @param ses_id - The amazon id to pull the message for
  #  @return - the data from the api
  #
  def getMessageBy_ses_id( ses_id)
    params = Hash.new
    params['ses_id'] = ses_id
    return doCurl("get","/message/by_ses_id",params)
  end


  #
  # Update/Add a flatpack
  #
  #  @param flatpack_id - this record's unique, auto-generated id - if supplied, then this is an edit, otherwise it's an add
  #  @param domainName - the domain name to serve this flatpack site on (no leading http:// or anything please)
  #  @param flatpackName - the name of the Flat pack instance
  #  @param less - the LESS configuration to use to overrides the Bootstrap CSS
  #  @param language - the language in which to render the flatpack site
  #  @param country - the country to use for searches etc
  #  @param mapsType - the type of maps to use
  #  @param mapKey - the nokia map key to use to render maps
  #  @param analyticsHTML - the html to insert to record page views
  #  @param searchFormShowOn - list of pages to show the search form
  #  @param searchFormShowKeywordsBox - whether to display the keywords box on the search form
  #  @param searchFormShowLocationBox - whether to display the location box on search forms - not required
  #  @param searchFormKeywordsAutoComplete - whether to do auto-completion on the keywords box on the search form
  #  @param searchFormLocationsAutoComplete - whether to do auto-completion on the locations box on the search form
  #  @param searchFormDefaultLocation - the string to use as the default location for searches if no location is supplied
  #  @param searchFormPlaceholderKeywords - the string to show in the keyword box as placeholder text e.g. e.g. cafe
  #  @param searchFormPlaceholderLocation - the string to show in the location box as placeholder text e.g. e.g. Dublin
  #  @param searchFormKeywordsLabel - the string to show next to the keywords control e.g. I'm looking for
  #  @param searchFormLocationLabel - the string to show next to the location control e.g. Located in
  #  @param cannedLinksHeader - the string to show above canned searches
  #  @param homepageTitle - the page title of site's home page
  #  @param homepageDescription - the meta description of the home page
  #  @param homepageIntroTitle - the introductory title for the homepage
  #  @param homepageIntroText - the introductory text for the homepage
  #  @param adblockHeader - the html (JS) to render an advert
  #  @param adblock728x90 - the html (JS) to render a 728x90 advert
  #  @param adblock468x60 - the html (JS) to render a 468x60 advert
  #  @param header_menu - the JSON that describes a navigation at the top of the page
  #  @param footer_menu - the JSON that describes a navigation at the bottom of the page
  #  @param bdpTitle - The page title of the entity business profile pages
  #  @param bdpDescription - The meta description of entity business profile pages
  #  @param bdpAds - The block of HTML/JS that renders Ads on BDPs
  #  @param serpTitle - The page title of the serps
  #  @param serpDescription - The meta description of serps
  #  @param serpNumberResults - The number of results per search page
  #  @param serpNumberAdverts - The number of adverts to show on the first search page
  #  @param serpAds - The block of HTML/JS that renders Ads on Serps
  #  @param cookiePolicyUrl - The cookie policy url of the flatpack
  #  @param cookiePolicyNotice - Whether to show the cookie policy on this flatpack
  #  @param addBusinessButtonText - The text used in the 'Add your business' button
  #  @param twitterUrl - Twitter link
  #  @param facebookUrl - Facebook link
  #  @return - the data from the api
  #
  def postFlatpack( flatpack_id, domainName, flatpackName, less, language, country, mapsType, mapKey, analyticsHTML, searchFormShowOn, searchFormShowKeywordsBox, searchFormShowLocationBox, searchFormKeywordsAutoComplete, searchFormLocationsAutoComplete, searchFormDefaultLocation, searchFormPlaceholderKeywords, searchFormPlaceholderLocation, searchFormKeywordsLabel, searchFormLocationLabel, cannedLinksHeader, homepageTitle, homepageDescription, homepageIntroTitle, homepageIntroText, adblockHeader, adblock728x90, adblock468x60, header_menu, footer_menu, bdpTitle, bdpDescription, bdpAds, serpTitle, serpDescription, serpNumberResults, serpNumberAdverts, serpAds, cookiePolicyUrl, cookiePolicyNotice, addBusinessButtonText, twitterUrl, facebookUrl)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['domainName'] = domainName
    params['flatpackName'] = flatpackName
    params['less'] = less
    params['language'] = language
    params['country'] = country
    params['mapsType'] = mapsType
    params['mapKey'] = mapKey
    params['analyticsHTML'] = analyticsHTML
    params['searchFormShowOn'] = searchFormShowOn
    params['searchFormShowKeywordsBox'] = searchFormShowKeywordsBox
    params['searchFormShowLocationBox'] = searchFormShowLocationBox
    params['searchFormKeywordsAutoComplete'] = searchFormKeywordsAutoComplete
    params['searchFormLocationsAutoComplete'] = searchFormLocationsAutoComplete
    params['searchFormDefaultLocation'] = searchFormDefaultLocation
    params['searchFormPlaceholderKeywords'] = searchFormPlaceholderKeywords
    params['searchFormPlaceholderLocation'] = searchFormPlaceholderLocation
    params['searchFormKeywordsLabel'] = searchFormKeywordsLabel
    params['searchFormLocationLabel'] = searchFormLocationLabel
    params['cannedLinksHeader'] = cannedLinksHeader
    params['homepageTitle'] = homepageTitle
    params['homepageDescription'] = homepageDescription
    params['homepageIntroTitle'] = homepageIntroTitle
    params['homepageIntroText'] = homepageIntroText
    params['adblockHeader'] = adblockHeader
    params['adblock728x90'] = adblock728x90
    params['adblock468x60'] = adblock468x60
    params['header_menu'] = header_menu
    params['footer_menu'] = footer_menu
    params['bdpTitle'] = bdpTitle
    params['bdpDescription'] = bdpDescription
    params['bdpAds'] = bdpAds
    params['serpTitle'] = serpTitle
    params['serpDescription'] = serpDescription
    params['serpNumberResults'] = serpNumberResults
    params['serpNumberAdverts'] = serpNumberAdverts
    params['serpAds'] = serpAds
    params['cookiePolicyUrl'] = cookiePolicyUrl
    params['cookiePolicyNotice'] = cookiePolicyNotice
    params['addBusinessButtonText'] = addBusinessButtonText
    params['twitterUrl'] = twitterUrl
    params['facebookUrl'] = facebookUrl
    return doCurl("post","/flatpack",params)
  end


  #
  # Get a flatpack
  #
  #  @param flatpack_id - the unique id to search for
  #  @return - the data from the api
  #
  def getFlatpack( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/flatpack",params)
  end


  #
  # Get a flatpack using a domain name
  #
  #  @param domainName - the domain name to search for
  #  @return - the data from the api
  #
  def getFlatpackBy_domain_name( domainName)
    params = Hash.new
    params['domainName'] = domainName
    return doCurl("get","/flatpack/by_domain_name",params)
  end


  #
  # Get flatpacks that match the supplied masheryid
  #
  #  @return - the data from the api
  #
  def getFlatpackBy_masheryid()
    params = Hash.new
    return doCurl("get","/flatpack/by_masheryid",params)
  end


  #
  # Remove a flatpack using a supplied flatpack_id
  #
  #  @param flatpack_id - the id of the flatpack to delete
  #  @return - the data from the api
  #
  def deleteFlatpack( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("delete","/flatpack",params)
  end


  #
  # Add a canned link to an existing flatpack site.
  #
  #  @param flatpack_id - the id of the flatpack to delete
  #  @param keywords - the keywords to use in the canned search
  #  @param location - the location to use in the canned search
  #  @param linkText - the link text to be used to in the canned search link
  #  @return - the data from the api
  #
  def postFlatpackLink( flatpack_id, keywords, location, linkText)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['keywords'] = keywords
    params['location'] = location
    params['linkText'] = linkText
    return doCurl("post","/flatpack/link",params)
  end


  #
  # Remove a canned link to an existing flatpack site.
  #
  #  @param flatpack_id - the id of the flatpack to delete
  #  @param gen_id - the id of the canned link to remove
  #  @return - the data from the api
  #
  def deleteFlatpackLink( flatpack_id, gen_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['gen_id'] = gen_id
    return doCurl("delete","/flatpack/link",params)
  end


  #
  # Upload a logo to serve out with this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackLogo( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/logo",params)
  end


  #
  # Upload a file to our asset server and return the url
  #
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackUpload( filedata)
    params = Hash.new
    params['filedata'] = filedata
    return doCurl("post","/flatpack/upload",params)
  end


  #
  # Upload an icon to serve out with this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackIcon( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/icon",params)
  end


  #
  # Allows us to identify the user, entity and element from an encoded endpoint URL's token
  #
  #  @param token
  #  @return - the data from the api
  #
  def getTokenDecode( token)
    params = Hash.new
    params['token'] = token
    return doCurl("get","/token/decode",params)
  end


  #
  # Provides a tokenised URL to redirect a user so they can add an entity to Central Index
  #
  #  @param language - The language to use to render the add path e.g. en
  #  @param portal_name - The name of the website that data is to be added on e.g. YourLocal
  #  @param country - The country of the entity to be added e.g. gb
  #  @return - the data from the api
  #
  def getTokenAdd( language, portal_name, country)
    params = Hash.new
    params['language'] = language
    params['portal_name'] = portal_name
    params['country'] = country
    return doCurl("get","/token/add",params)
  end


  #
  # Provides a tokenised URL to redirect a user to claim an entity on Central Index
  #
  #  @param entity_id - Entity ID to be claimed e.g. 380348266819584
  #  @param language - The language to use to render the claim path e.g. en
  #  @param portal_name - The name of the website that entity is being claimed on e.g. YourLocal
  #  @return - the data from the api
  #
  def getTokenClaim( entity_id, language, portal_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['language'] = language
    params['portal_name'] = portal_name
    return doCurl("get","/token/claim",params)
  end


  #
  # Provides a tokenised URL that allows a user to report incorrect entity information
  #
  #  @param entity_id - The unique Entity ID e.g. 379236608286720
  #  @param portal_name - The name of the portal that the user is coming from e.g. YourLocal
  #  @param language - The language to use to render the report path
  #  @return - the data from the api
  #
  def getTokenReport( entity_id, portal_name, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    return doCurl("get","/token/report",params)
  end


  #
  # Fetch token for messaging path
  #
  #  @param entity_id - The id of the entity being messaged
  #  @param portal_name - The name of the application that has initiated the email process, example: 'Your Local'
  #  @param language - The language for the app
  #  @return - the data from the api
  #
  def getTokenMessage( entity_id, portal_name, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    return doCurl("get","/token/message",params)
  end


  #
  # Fetch token for login path
  #
  #  @param portal_name - The name of the application that has initiated the login process, example: 'Your Local'
  #  @param language - The language for the app
  #  @return - the data from the api
  #
  def getTokenLogin( portal_name, language)
    params = Hash.new
    params['portal_name'] = portal_name
    params['language'] = language
    return doCurl("get","/token/login",params)
  end


  #
  # Fetch token for update path
  #
  #  @param entity_id - The id of the entity being upgraded
  #  @param portal_name - The name of the application that has initiated the login process, example: 'Your Local'
  #  @param language - The language for the app
  #  @param price - The price of the advert in the entities native currency
  #  @param max_tags - The number of tags attached to the advert
  #  @param max_locations - The number of locations attached to the advert
  #  @param contract_length - The number of days from the initial sale date that the contract is valid for
  #  @param ref_id - The campaign or reference id
  #  @return - the data from the api
  #
  def getTokenUpgrade( entity_id, portal_name, language, price, max_tags, max_locations, contract_length, ref_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    params['price'] = price
    params['max_tags'] = max_tags
    params['max_locations'] = max_locations
    params['contract_length'] = contract_length
    params['ref_id'] = ref_id
    return doCurl("get","/token/upgrade",params)
  end


  #
  # Send an email via amazon
  #
  #  @param to_email_address - The email address to send the email too
  #  @param reply_email_address - The email address to add in the reply to field
  #  @param source_account - The source account to send the email from
  #  @param subject - The subject for the email
  #  @param body - The body for the email
  #  @param html_body - If the body of the email is html
  #  @return - the data from the api
  #
  def postEmail( to_email_address, reply_email_address, source_account, subject, body, html_body)
    params = Hash.new
    params['to_email_address'] = to_email_address
    params['reply_email_address'] = reply_email_address
    params['source_account'] = source_account
    params['subject'] = subject
    params['body'] = body
    params['html_body'] = html_body
    return doCurl("post","/email",params)
  end


  #
  # Log a sale
  #
  #  @param entity_id - The entity the sale was made against
  #  @param action_type - The type of action we are performing
  #  @param publisher_id - The publisher id that has made the sale
  #  @param mashery_id - The mashery id
  #  @param reseller_ref - The reference of the sale made by the seller
  #  @param reseller_agent_id - The id of the agent selling the product
  #  @param max_tags - The number of tags available to the entity
  #  @param max_locations - The number of locations available to the entity
  #  @param extra_tags - The extra number of tags
  #  @param extra_locations - The extra number of locations
  #  @param expiry_date - The date the product expires
  #  @return - the data from the api
  #
  def postSales_log( entity_id, action_type, publisher_id, mashery_id, reseller_ref, reseller_agent_id, max_tags, max_locations, extra_tags, extra_locations, expiry_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['action_type'] = action_type
    params['publisher_id'] = publisher_id
    params['mashery_id'] = mashery_id
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['max_tags'] = max_tags
    params['max_locations'] = max_locations
    params['extra_tags'] = extra_tags
    params['extra_locations'] = extra_locations
    params['expiry_date'] = expiry_date
    return doCurl("post","/sales_log",params)
  end


  #
  # Return a sales log by id
  #
  #  @param sales_log_id - The sales log id to pull
  #  @return - the data from the api
  #
  def getSales_log( sales_log_id)
    params = Hash.new
    params['sales_log_id'] = sales_log_id
    return doCurl("get","/sales_log",params)
  end


  #
  # With a known entity id, a social media object can be added.
  #
  #  @param entity_id
  #  @param type
  #  @param website_url
  #  @return - the data from the api
  #
  def postEntitySocialmedia( entity_id, type, website_url)
    params = Hash.new
    params['entity_id'] = entity_id
    params['type'] = type
    params['website_url'] = website_url
    return doCurl("post","/entity/socialmedia",params)
  end


  #
  # Allows a social media object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntitySocialmedia( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/socialmedia",params)
  end


  #
  # With a known entity id, a private object can be added.
  #
  #  @param entity_id - The entity to associate the private object with
  #  @param data - The data to store
  #  @return - the data from the api
  #
  def putPrivate_object( entity_id, data)
    params = Hash.new
    params['entity_id'] = entity_id
    params['data'] = data
    return doCurl("put","/private_object",params)
  end


  #
  # Allows a private object to be removed
  #
  #  @param private_object_id - The id of the private object to remove
  #  @return - the data from the api
  #
  def deletePrivate_object( private_object_id)
    params = Hash.new
    params['private_object_id'] = private_object_id
    return doCurl("delete","/private_object",params)
  end


  #
  # Allows a private object to be returned based on the entity_id and masheryid
  #
  #  @param entity_id - The entity associated with the private object
  #  @return - the data from the api
  #
  def getPrivate_objectAll( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/private_object/all",params)
  end


  #
  # Update/Add a Group
  #
  #  @param group_id
  #  @param name
  #  @param description
  #  @param url
  #  @return - the data from the api
  #
  def postGroup( group_id, name, description, url)
    params = Hash.new
    params['group_id'] = group_id
    params['name'] = name
    params['description'] = description
    params['url'] = url
    return doCurl("post","/group",params)
  end


  #
  # Delete a group with a specified group_id
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def deleteGroup( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("delete","/group",params)
  end


  #
  # Returns group that matches a given group id
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def getGroup( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("get","/group",params)
  end


  #
  # With a known entity id, a group  can be added to group members.
  #
  #  @param entity_id
  #  @param group_id
  #  @return - the data from the api
  #
  def postEntityGroup( entity_id, group_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['group_id'] = group_id
    return doCurl("post","/entity/group",params)
  end


  #
  # Allows a group object to be removed from an entities group members
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityGroup( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/group",params)
  end


  #
  # Add an entityserve document
  #
  #  @param entity_id - The id of the entity to create the entityserve event for
  #  @param country - the ISO code of the country
  #  @param event_type - The event type being recorded
  #  @return - the data from the api
  #
  def putEntityserve( entity_id, country, event_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
    params['event_type'] = event_type
    return doCurl("put","/entityserve",params)
  end


end

