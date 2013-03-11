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
  #  @param what
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
  # Supply an entity and an object within it (e.g. a phone number), and retrieve a URL that allows the user to report an issue with that object
  #
  #  @param entity_id - The unique Entity ID e.g. 379236608286720
  #  @param gen_id - A Unique ID for the object you wish to report, E.g. Phone number e.g. 379236608299008
  #  @param language
  #  @return - the data from the api
  #
  def getEntityReport( entity_id, gen_id, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['language'] = language
    return doCurl("get","/entity/report",params)
  end


  #
  # Allows us to identify the user, entity and element from an encoded endpoint URL's token
  #
  #  @param token
  #  @return - the data from the api
  #
  def getToolsDecodereport( token)
    params = Hash.new
    params['token'] = token
    return doCurl("get","/tools/decodereport",params)
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
  #  @param category_name
  #  @return - the data from the api
  #
  def putBusiness( name, address1, address2, address3, district, town, county, postcode, country, latitude, longitude, timezone, telephone_number, email, website, category_id, category_name)
    params = Hash.new
    params['name'] = name
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
    params['category_name'] = category_name
    return doCurl("put","/business",params)
  end


  #
  # Provides a personalised URL to redirect a user to add an entity to Central Index
  #
  #  @param language - The language to use to render the add path e.g. en
  #  @param portal_name - The name of the website that data is to be added on e.g. YourLocal
  #  @return - the data from the api
  #
  def getEntityAdd( language, portal_name)
    params = Hash.new
    params['language'] = language
    params['portal_name'] = portal_name
    return doCurl("get","/entity/add",params)
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
  # With a known entity id, an category object can be added.
  #
  #  @param entity_id
  #  @param category_id
  #  @param category_name
  #  @return - the data from the api
  #
  def postEntityCategory( entity_id, category_id, category_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['category_id'] = category_id
    params['category_name'] = category_name
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
  #  @param name_strictness
  #  @param location_strictness
  #  @return - the data from the api
  #
  def getMatchByphone( phone, company_name, latitude, longitude, name_strictness, location_strictness)
    params = Hash.new
    params['phone'] = phone
    params['company_name'] = company_name
    params['latitude'] = latitude
    params['longitude'] = longitude
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
  #  @return - the data from the api
  #
  def getToolsSpider( url)
    params = Hash.new
    params['url'] = url
    return doCurl("get","/tools/spider",params)
  end


  #
  # Supply an address to geocode - returns lat/lon and accuracy
  #
  #  @param address
  #  @return - the data from the api
  #
  def getToolsGeocode( address)
    params = Hash.new
    params['address'] = address
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
  # With a known entity id, an invoice_address object can be updated.
  #
  #  @param entity_id
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
  def postEntityInvoice_address( entity_id, address1, address2, address3, district, town, county, postcode, address_type)
    params = Hash.new
    params['entity_id'] = entity_id
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
  def postEntityPostal_address( entity_id, address1, address2, address3, district, town, county, postcode, address_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['postcode'] = postcode
    params['address_type'] = address_type
    return doCurl("post","/entity/postal_address",params)
  end


  #
  # With a known entity id, a advertiser is added
  #
  #  @param entity_id
  #  @param tags
  #  @param locations
  #  @param expiry
  #  @param is_national
  #  @param language
  #  @return - the data from the api
  #
  def postEntityAdvertiser( entity_id, tags, locations, expiry, is_national, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tags'] = tags
    params['locations'] = locations
    params['expiry'] = expiry
    params['is_national'] = is_national
    params['language'] = language
    return doCurl("post","/entity/advertiser",params)
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
  #  @return - the data from the api
  #
  def postLocation( location_id, name, formal_name, latitude, longitude, resolution, country, population, description, timezone, is_duplicate, is_default)
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
  # With a known entity id, avideo object can be added.
  #
  #  @param entity_id
  #  @param title
  #  @param description
  #  @param thumbnail
  #  @param embed_code
  #  @return - the data from the api
  #
  def postEntityVideo( entity_id, title, description, thumbnail, embed_code)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['description'] = description
    params['thumbnail'] = thumbnail
    params['embed_code'] = embed_code
    return doCurl("post","/entity/video",params)
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
  #  @return - the data from the api
  #
  def postUser( email, first_name, last_name, active, trust, creation_date, user_type, social_network, social_network_id)
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
  # The search matches a category name or synonym on a given string and language.
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
  #  @return - the data from the api
  #
  def postEntityClaim( entity_id, claimed_user_id, claimed_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['claimed_user_id'] = claimed_user_id
    params['claimed_date'] = claimed_date
    return doCurl("post","/entity/claim",params)
  end


end

