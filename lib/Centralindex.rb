2022/12/14 12:36:28 STARTUP Redis server: tcp://127.0.0.1:6379
2022/12/14 12:36:28 STARTUP ElasticSearch server: http://172.22.12.49:9200
2022/12/14 12:36:28 STARTUP ES view server: http://172.22.114.129:63300/view/view
2022/12/14 12:36:28 STARTUP CouchDB server: http://wolf_staging:******@172.22.10.201:5984
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
  # With a 192 id get remote entity data
  #
  #  @param oneninetwo_id
  #  @return - the data from the api
  #
  def GET192Get( oneninetwo_id)
    params = Hash.new
    params['oneninetwo_id'] = oneninetwo_id
    return doCurl("get","/192/get",params)
  end


  #
  # Get the activity from the collection
  #
  #  @param type - The activity type: add, claim, special offer, image, video, description, testimonial
  #  @param country - The country to filter by
  #  @param latitude_1 - The latitude_1 to filter by
  #  @param longitude_1 - The longitude_1 to filter by
  #  @param latitude_2 - The latitude_2 to filter by
  #  @param longitude_2 - The longitude_2 to filter by
  #  @param number_results - The number_results to filter by
  #  @param unique_action - Return only the most recent instance of this action?
  #  @return - the data from the api
  #
  def GETActivity_stream( type, country, latitude_1, longitude_1, latitude_2, longitude_2, number_results, unique_action)
    params = Hash.new
    params['type'] = type
    params['country'] = country
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['number_results'] = number_results
    params['unique_action'] = unique_action
    return doCurl("get","/activity_stream",params)
  end


  #
  # When we get some activity make a record of it
  #
  #  @param entity_id - The entity to pull
  #  @param entity_name - The entity name this entry refers to
  #  @param type - The activity type.
  #  @param country - The country for the activity
  #  @param longitude - The longitude for teh activity
  #  @param latitude - The latitude for teh activity
  #  @return - the data from the api
  #
  def POSTActivity_stream( entity_id, entity_name, type, country, longitude, latitude)
    params = Hash.new
    params['entity_id'] = entity_id
    params['entity_name'] = entity_name
    params['type'] = type
    params['country'] = country
    params['longitude'] = longitude
    params['latitude'] = latitude
    return doCurl("post","/activity_stream",params)
  end


  #
  # Get all entities in which live ads have the matched reseller_masheryid.
  #
  #  @param country
  #  @param reseller_masheryid
  #  @param name_only - If true the query result contains entity name only; otherwise, the entity object.
  #  @param name_match - Filter the result in which the name contains the given text.
  #  @param skip
  #  @param take - Set 0 to get all result. However, if name_only=false, only 100 objects at most will be returned to prevent oversized response body.
  #  @return - the data from the api
  #
  def GETAdvertiserBy_reseller_masheryid( country, reseller_masheryid, name_only, name_match, skip, take)
    params = Hash.new
    params['country'] = country
    params['reseller_masheryid'] = reseller_masheryid
    params['name_only'] = name_only
    params['name_match'] = name_match
    params['skip'] = skip
    params['take'] = take
    return doCurl("get","/advertiser/by_reseller_masheryid",params)
  end


  #
  # Get all advertisers that have been updated from a give date for a given reseller
  #
  #  @param from_date
  #  @param country
  #  @return - the data from the api
  #
  def GETAdvertiserUpdated( from_date, country)
    params = Hash.new
    params['from_date'] = from_date
    params['country'] = country
    return doCurl("get","/advertiser/updated",params)
  end


  #
  # Get all advertisers that have been updated from a give date for a given publisher
  #
  #  @param publisher_id
  #  @param from_date
  #  @param country
  #  @return - the data from the api
  #
  def GETAdvertiserUpdatedBy_publisher( publisher_id, from_date, country)
    params = Hash.new
    params['publisher_id'] = publisher_id
    params['from_date'] = from_date
    params['country'] = country
    return doCurl("get","/advertiser/updated/by_publisher",params)
  end


  #
  # Check that the advertiser has a premium inventory
  #
  #  @param type
  #  @param category_id - The category of the advertiser
  #  @param location_id - The location of the advertiser
  #  @param publisher_id - The publisher of the advertiser
  #  @return - the data from the api
  #
  def GETAdvertisersPremiumInventorycheck( type, category_id, location_id, publisher_id)
    params = Hash.new
    params['type'] = type
    params['category_id'] = category_id
    params['location_id'] = location_id
    params['publisher_id'] = publisher_id
    return doCurl("get","/advertisers/premium/inventorycheck",params)
  end


  #
  # Delete an association
  #
  #  @param association_id
  #  @return - the data from the api
  #
  def DELETEAssociation( association_id)
    params = Hash.new
    params['association_id'] = association_id
    return doCurl("delete","/association",params)
  end


  #
  # Fetch an association
  #
  #  @param association_id
  #  @return - the data from the api
  #
  def GETAssociation( association_id)
    params = Hash.new
    params['association_id'] = association_id
    return doCurl("get","/association",params)
  end


  #
  # Will create a new association or update an existing one
  #
  #  @param association_id
  #  @param association_name
  #  @param association_url
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTAssociation( association_id, association_name, association_url, filedata)
    params = Hash.new
    params['association_id'] = association_id
    params['association_name'] = association_name
    params['association_url'] = association_url
    params['filedata'] = filedata
    return doCurl("post","/association",params)
  end


  #
  # The search matches a category name on a given string and language.
  #
  #  @param str - A string to search against, E.g. Plumbers e.g. but
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @param mapped_to_partner - Only return CI categories that have a partner mapping
  #  @return - the data from the api
  #
  def GETAutocompleteCategory( str, language, mapped_to_partner)
    params = Hash.new
    params['str'] = str
    params['language'] = language
    params['mapped_to_partner'] = mapped_to_partner
    return doCurl("get","/autocomplete/category",params)
  end


  #
  # The search matches a category name and ID on a given string and language.
  #
  #  @param str - A string to search against, E.g. Plumbers e.g. but
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @param mapped_to_partner - Only return CI categories that have a partner mapping
  #  @return - the data from the api
  #
  def GETAutocompleteCategoryId( str, language, mapped_to_partner)
    params = Hash.new
    params['str'] = str
    params['language'] = language
    params['mapped_to_partner'] = mapped_to_partner
    return doCurl("get","/autocomplete/category/id",params)
  end


  #
  # The search matches a category name or synonym on a given string and language.
  #
  #  @param str - A string to search against, E.g. Plumbers e.g. but
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @return - the data from the api
  #
  def GETAutocompleteKeyword( str, language)
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
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @return - the data from the api
  #
  def GETAutocompleteLocation( str, country, language)
    params = Hash.new
    params['str'] = str
    params['country'] = country
    params['language'] = language
    return doCurl("get","/autocomplete/location",params)
  end


  #
  # The search matches a location name or synonym on a given string and language.
  #
  #  @param str - A string to search against, E.g. Middle e.g. dub
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param resolution
  #  @return - the data from the api
  #
  def GETAutocompleteLocationBy_resolution( str, country, resolution)
    params = Hash.new
    params['str'] = str
    params['country'] = country
    params['resolution'] = resolution
    return doCurl("get","/autocomplete/location/by_resolution",params)
  end


  #
  # Create a new business entity with all it's objects
  #
  #  @param name
  #  @param status
  #  @param building_number
  #  @param branch_name
  #  @param address1
  #  @param address2
  #  @param address3
  #  @param district
  #  @param town
  #  @param county
  #  @param province
  #  @param postcode
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @param timezone
  #  @param telephone_number
  #  @param allow_no_address
  #  @param allow_no_phone
  #  @param additional_telephone_number
  #  @param email
  #  @param website
  #  @param payment_types - Payment types separated by comma
  #  @param tags - Tags separated by comma
  #  @param category_id
  #  @param category_type
  #  @param featured_message_text - Featured message content
  #  @param featured_message_url - Featured message URL
  #  @param do_not_display
  #  @param orderonline
  #  @param delivers
  #  @param referrer_url
  #  @param referrer_name
  #  @param destructive
  #  @param delete_mode - The type of object contribution deletion
  #  @param master_entity_id - The entity you want this data to go to
  #  @param no_merge_on_error - If true, data duplication error will be returned when a matched entity is found. If false, such error is suppressed and data is merged into the matched entity.
  #  @return - the data from the api
  #
  def PUTBusiness( name, status, building_number, branch_name, address1, address2, address3, district, town, county, province, postcode, country, latitude, longitude, timezone, telephone_number, allow_no_address, allow_no_phone, additional_telephone_number, email, website, payment_types, tags, category_id, category_type, featured_message_text, featured_message_url, do_not_display, orderonline, delivers, referrer_url, referrer_name, destructive, delete_mode, master_entity_id, no_merge_on_error)
    params = Hash.new
    params['name'] = name
    params['status'] = status
    params['building_number'] = building_number
    params['branch_name'] = branch_name
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['province'] = province
    params['postcode'] = postcode
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['timezone'] = timezone
    params['telephone_number'] = telephone_number
    params['allow_no_address'] = allow_no_address
    params['allow_no_phone'] = allow_no_phone
    params['additional_telephone_number'] = additional_telephone_number
    params['email'] = email
    params['website'] = website
    params['payment_types'] = payment_types
    params['tags'] = tags
    params['category_id'] = category_id
    params['category_type'] = category_type
    params['featured_message_text'] = featured_message_text
    params['featured_message_url'] = featured_message_url
    params['do_not_display'] = do_not_display
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['referrer_url'] = referrer_url
    params['referrer_name'] = referrer_name
    params['destructive'] = destructive
    params['delete_mode'] = delete_mode
    params['master_entity_id'] = master_entity_id
    params['no_merge_on_error'] = no_merge_on_error
    return doCurl("put","/business",params)
  end


  #
  # Create entity via JSON
  #
  #  @param json - Business JSON
  #  @param country - The country to fetch results for e.g. gb
  #  @param timezone
  #  @param master_entity_id - The entity you want this data to go to
  #  @param allow_no_address
  #  @param allow_no_phone
  #  @param queue_priority
  #  @param skip_dedup_check - If true, skip checking on existing supplier ID, phone numbers, etc.
  #  @return - the data from the api
  #
  def PUTBusinessJson( json, country, timezone, master_entity_id, allow_no_address, allow_no_phone, queue_priority, skip_dedup_check)
    params = Hash.new
    params['json'] = json
    params['country'] = country
    params['timezone'] = timezone
    params['master_entity_id'] = master_entity_id
    params['allow_no_address'] = allow_no_address
    params['allow_no_phone'] = allow_no_phone
    params['queue_priority'] = queue_priority
    params['skip_dedup_check'] = skip_dedup_check
    return doCurl("put","/business/json",params)
  end


  #
  # Create entity via JSON
  #
  #  @param entity_id - The entity to add rich data too
  #  @param json - The rich data to add to the entity
  #  @return - the data from the api
  #
  def POSTBusinessJsonProcess( entity_id, json)
    params = Hash.new
    params['entity_id'] = entity_id
    params['json'] = json
    return doCurl("post","/business/json/process",params)
  end


  #
  # Delete a business tool with a specified tool_id
  #
  #  @param tool_id
  #  @return - the data from the api
  #
  def DELETEBusiness_tool( tool_id)
    params = Hash.new
    params['tool_id'] = tool_id
    return doCurl("delete","/business_tool",params)
  end


  #
  # Returns business tool that matches a given tool id
  #
  #  @param tool_id
  #  @return - the data from the api
  #
  def GETBusiness_tool( tool_id)
    params = Hash.new
    params['tool_id'] = tool_id
    return doCurl("get","/business_tool",params)
  end


  #
  # Update/Add a Business Tool
  #
  #  @param tool_id
  #  @param country
  #  @param headline
  #  @param description
  #  @param link_url
  #  @param active
  #  @return - the data from the api
  #
  def POSTBusiness_tool( tool_id, country, headline, description, link_url, active)
    params = Hash.new
    params['tool_id'] = tool_id
    params['country'] = country
    params['headline'] = headline
    params['description'] = description
    params['link_url'] = link_url
    params['active'] = active
    return doCurl("post","/business_tool",params)
  end


  #
  # Returns active business tools for a specific masheryid in a given country
  #
  #  @param country
  #  @param activeonly
  #  @return - the data from the api
  #
  def GETBusiness_toolBy_masheryid( country, activeonly)
    params = Hash.new
    params['country'] = country
    params['activeonly'] = activeonly
    return doCurl("get","/business_tool/by_masheryid",params)
  end


  #
  # Assigns a Call To Action to a Business Tool
  #
  #  @param tool_id
  #  @param enablecta
  #  @param cta_id
  #  @param slug
  #  @param nomodal
  #  @param type
  #  @param headline
  #  @param textshort
  #  @param link
  #  @param linklabel
  #  @param textlong
  #  @param textoutro
  #  @param bullets
  #  @param masheryids
  #  @param imgurl
  #  @param custombranding
  #  @param customcol
  #  @param custombkg
  #  @param customctacol
  #  @param customctabkg
  #  @param custominfocol
  #  @param custominfobkg
  #  @return - the data from the api
  #
  def POSTBusiness_toolCta( tool_id, enablecta, cta_id, slug, nomodal, type, headline, textshort, link, linklabel, textlong, textoutro, bullets, masheryids, imgurl, custombranding, customcol, custombkg, customctacol, customctabkg, custominfocol, custominfobkg)
    params = Hash.new
    params['tool_id'] = tool_id
    params['enablecta'] = enablecta
    params['cta_id'] = cta_id
    params['slug'] = slug
    params['nomodal'] = nomodal
    params['type'] = type
    params['headline'] = headline
    params['textshort'] = textshort
    params['link'] = link
    params['linklabel'] = linklabel
    params['textlong'] = textlong
    params['textoutro'] = textoutro
    params['bullets'] = bullets
    params['masheryids'] = masheryids
    params['imgurl'] = imgurl
    params['custombranding'] = custombranding
    params['customcol'] = customcol
    params['custombkg'] = custombkg
    params['customctacol'] = customctacol
    params['customctabkg'] = customctabkg
    params['custominfocol'] = custominfocol
    params['custominfobkg'] = custominfobkg
    return doCurl("post","/business_tool/cta",params)
  end


  #
  # Assigns a Business Tool image
  #
  #  @param tool_id
  #  @param assignimage
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTBusiness_toolImage( tool_id, assignimage, filedata)
    params = Hash.new
    params['tool_id'] = tool_id
    params['assignimage'] = assignimage
    params['filedata'] = filedata
    return doCurl("post","/business_tool/image",params)
  end


  #
  # Assigns a Business Tool image
  #
  #  @param tool_id
  #  @param image_url
  #  @return - the data from the api
  #
  def POSTBusiness_toolImageBy_url( tool_id, image_url)
    params = Hash.new
    params['tool_id'] = tool_id
    params['image_url'] = image_url
    return doCurl("post","/business_tool/image/by_url",params)
  end


  #
  # With a known cache key get the data from cache
  #
  #  @param cache_key
  #  @param use_compression
  #  @return - the data from the api
  #
  def GETCache( cache_key, use_compression)
    params = Hash.new
    params['cache_key'] = cache_key
    params['use_compression'] = use_compression
    return doCurl("get","/cache",params)
  end


  #
  # Add some data to the cache with a given expiry
  #
  #  @param cache_key
  #  @param expiry - The cache expiry in seconds
  #  @param data - The data to cache
  #  @param use_compression
  #  @return - the data from the api
  #
  def POSTCache( cache_key, expiry, data, use_compression)
    params = Hash.new
    params['cache_key'] = cache_key
    params['expiry'] = expiry
    params['data'] = data
    params['use_compression'] = use_compression
    return doCurl("post","/cache",params)
  end


  #
  # Returns the supplied wolf category object by fetching the supplied category_id from our categories object.
  #
  #  @param category_id
  #  @return - the data from the api
  #
  def GETCategory( category_id)
    params = Hash.new
    params['category_id'] = category_id
    return doCurl("get","/category",params)
  end


  #
  # With a known category id, an category object can be added.
  #
  #  @param category_id
  #  @param language
  #  @param name
  #  @return - the data from the api
  #
  def PUTCategory( category_id, language, name)
    params = Hash.new
    params['category_id'] = category_id
    params['language'] = language
    params['name'] = name
    return doCurl("put","/category",params)
  end


  #
  # Returns all Central Index categories and associated data
  #
  #  @param partner
  #  @return - the data from the api
  #
  def GETCategoryAll( partner)
    params = Hash.new
    params['partner'] = partner
    return doCurl("get","/category/all",params)
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
  def POSTCategoryMappings( category_id, type, id, name)
    params = Hash.new
    params['category_id'] = category_id
    params['type'] = type
    params['id'] = id
    params['name'] = name
    return doCurl("post","/category/mappings",params)
  end


  #
  # With a known category id, a mapping object can be deleted.
  #
  #  @param category_id
  #  @param category_type
  #  @param mapped_id
  #  @return - the data from the api
  #
  def DELETECategoryMappings( category_id, category_type, mapped_id)
    params = Hash.new
    params['category_id'] = category_id
    params['category_type'] = category_type
    params['mapped_id'] = mapped_id
    return doCurl("delete","/category/mappings",params)
  end


  #
  # Allows a category object to merged with another
  #
  #  @param from
  #  @param to
  #  @return - the data from the api
  #
  def POSTCategoryMerge( from, to)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    return doCurl("post","/category/merge",params)
  end


  #
  # With a known category id, an synonym object can be added.
  #
  #  @param category_id
  #  @param synonym
  #  @param language
  #  @return - the data from the api
  #
  def POSTCategorySynonym( category_id, synonym, language)
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
  def DELETECategorySynonym( category_id, synonym, language)
    params = Hash.new
    params['category_id'] = category_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("delete","/category/synonym",params)
  end


  #
  # Get the contract from the ID supplied
  #
  #  @param contract_id
  #  @return - the data from the api
  #
  def GETContract( contract_id)
    params = Hash.new
    params['contract_id'] = contract_id
    return doCurl("get","/contract",params)
  end


  #
  # Get the active contracts from the ID supplied
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def GETContractBy_entity_id( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/contract/by_entity_id",params)
  end


  #
  # Get a contract from the payment provider id supplied
  #
  #  @param payment_provider
  #  @param payment_provider_id
  #  @return - the data from the api
  #
  def GETContractBy_payment_provider_id( payment_provider, payment_provider_id)
    params = Hash.new
    params['payment_provider'] = payment_provider
    params['payment_provider_id'] = payment_provider_id
    return doCurl("get","/contract/by_payment_provider_id",params)
  end


  #
  # Get the active contracts from the ID supplied
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def GETContractBy_user_id( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/contract/by_user_id",params)
  end


  #
  # Cancels an existing contract for a given id
  #
  #  @param contract_id
  #  @return - the data from the api
  #
  def POSTContractCancel( contract_id)
    params = Hash.new
    params['contract_id'] = contract_id
    return doCurl("post","/contract/cancel",params)
  end


  #
  # Creates a new contract for a given entity
  #
  #  @param entity_id
  #  @param user_id
  #  @param payment_provider
  #  @param basket
  #  @param taxrate
  #  @param billing_period
  #  @param source
  #  @param channel
  #  @param campaign
  #  @param referrer_domain
  #  @param referrer_name
  #  @param flatpack_id
  #  @return - the data from the api
  #
  def POSTContractCreate( entity_id, user_id, payment_provider, basket, taxrate, billing_period, source, channel, campaign, referrer_domain, referrer_name, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['user_id'] = user_id
    params['payment_provider'] = payment_provider
    params['basket'] = basket
    params['taxrate'] = taxrate
    params['billing_period'] = billing_period
    params['source'] = source
    params['channel'] = channel
    params['campaign'] = campaign
    params['referrer_domain'] = referrer_domain
    params['referrer_name'] = referrer_name
    params['flatpack_id'] = flatpack_id
    return doCurl("post","/contract/create",params)
  end


  #
  # Activate a contract that is free
  #
  #  @param contract_id
  #  @param user_name
  #  @param user_surname
  #  @param user_email_address
  #  @return - the data from the api
  #
  def POSTContractFreeactivate( contract_id, user_name, user_surname, user_email_address)
    params = Hash.new
    params['contract_id'] = contract_id
    params['user_name'] = user_name
    params['user_surname'] = user_surname
    params['user_email_address'] = user_email_address
    return doCurl("post","/contract/freeactivate",params)
  end


  #
  # When we failed to receive money add the dates etc to the contract
  #
  #  @param contract_id
  #  @param failure_reason
  #  @param payment_date
  #  @param amount
  #  @param currency
  #  @param response
  #  @return - the data from the api
  #
  def POSTContractPaymentFailure( contract_id, failure_reason, payment_date, amount, currency, response)
    params = Hash.new
    params['contract_id'] = contract_id
    params['failure_reason'] = failure_reason
    params['payment_date'] = payment_date
    params['amount'] = amount
    params['currency'] = currency
    params['response'] = response
    return doCurl("post","/contract/payment/failure",params)
  end


  #
  # Adds payment details to a given contract_id
  #
  #  @param contract_id
  #  @param payment_provider_id
  #  @param payment_provider_profile
  #  @param user_name
  #  @param user_surname
  #  @param user_billing_address
  #  @param user_email_address
  #  @return - the data from the api
  #
  def POSTContractPaymentSetup( contract_id, payment_provider_id, payment_provider_profile, user_name, user_surname, user_billing_address, user_email_address)
    params = Hash.new
    params['contract_id'] = contract_id
    params['payment_provider_id'] = payment_provider_id
    params['payment_provider_profile'] = payment_provider_profile
    params['user_name'] = user_name
    params['user_surname'] = user_surname
    params['user_billing_address'] = user_billing_address
    params['user_email_address'] = user_email_address
    return doCurl("post","/contract/payment/setup",params)
  end


  #
  # When we receive money add the dates etc to the contract
  #
  #  @param contract_id
  #  @param payment_date
  #  @param amount
  #  @param currency
  #  @param response
  #  @return - the data from the api
  #
  def POSTContractPaymentSuccess( contract_id, payment_date, amount, currency, response)
    params = Hash.new
    params['contract_id'] = contract_id
    params['payment_date'] = payment_date
    params['amount'] = amount
    params['currency'] = currency
    params['response'] = response
    return doCurl("post","/contract/payment/success",params)
  end


  #
  # Go through all the products in a contract and provision them
  #
  #  @param contract_id
  #  @return - the data from the api
  #
  def POSTContractProvision( contract_id)
    params = Hash.new
    params['contract_id'] = contract_id
    return doCurl("post","/contract/provision",params)
  end


  #
  # Ensures contract has been cancelled for a given id, expected to be called from stripe on deletion of subscription
  #
  #  @param contract_id
  #  @return - the data from the api
  #
  def POSTContractSubscriptionended( contract_id)
    params = Hash.new
    params['contract_id'] = contract_id
    return doCurl("post","/contract/subscriptionended",params)
  end


  #
  # Get the contract log from the ID supplied
  #
  #  @param contract_log_id
  #  @return - the data from the api
  #
  def GETContract_log( contract_log_id)
    params = Hash.new
    params['contract_log_id'] = contract_log_id
    return doCurl("get","/contract_log",params)
  end


  #
  # Creates a new contract log for a given contract
  #
  #  @param contract_id
  #  @param date
  #  @param payment_provider
  #  @param response
  #  @param success
  #  @param amount
  #  @param currency
  #  @return - the data from the api
  #
  def POSTContract_log( contract_id, date, payment_provider, response, success, amount, currency)
    params = Hash.new
    params['contract_id'] = contract_id
    params['date'] = date
    params['payment_provider'] = payment_provider
    params['response'] = response
    params['success'] = success
    params['amount'] = amount
    params['currency'] = currency
    return doCurl("post","/contract_log",params)
  end


  #
  # Get the contract logs from the ID supplied
  #
  #  @param contract_id
  #  @param page
  #  @param per_page
  #  @return - the data from the api
  #
  def GETContract_logBy_contract_id( contract_id, page, per_page)
    params = Hash.new
    params['contract_id'] = contract_id
    params['page'] = page
    params['per_page'] = per_page
    return doCurl("get","/contract_log/by_contract_id",params)
  end


  #
  # Get the contract logs from the payment_provider supplied
  #
  #  @param payment_provider
  #  @param page
  #  @param per_page
  #  @return - the data from the api
  #
  def GETContract_logBy_payment_provider( payment_provider, page, per_page)
    params = Hash.new
    params['payment_provider'] = payment_provider
    params['page'] = page
    params['per_page'] = per_page
    return doCurl("get","/contract_log/by_payment_provider",params)
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
  #  @param claimProductId
  #  @param claimMethods
  #  @param twilio_sms
  #  @param twilio_phone
  #  @param twilio_voice
  #  @param currency_symbol - the symbol of this country's currency
  #  @param currency_symbol_html - the html version of the symbol of this country's currency
  #  @param postcodeLookupActive - Whether the lookup is activated for this country
  #  @param addressFields - Whether fields are activated for this country
  #  @param addressMatching - The configurable matching algorithm
  #  @param dateFormat - The format of the date for this country
  #  @param iso_3166_alpha_3
  #  @param iso_3166_numeric
  #  @return - the data from the api
  #
  def POSTCountry( country_id, name, synonyms, continentName, continent, geonameId, dbpediaURL, freebaseURL, population, currencyCode, languages, areaInSqKm, capital, east, west, north, south, claimProductId, claimMethods, twilio_sms, twilio_phone, twilio_voice, currency_symbol, currency_symbol_html, postcodeLookupActive, addressFields, addressMatching, dateFormat, iso_3166_alpha_3, iso_3166_numeric)
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
    params['claimProductId'] = claimProductId
    params['claimMethods'] = claimMethods
    params['twilio_sms'] = twilio_sms
    params['twilio_phone'] = twilio_phone
    params['twilio_voice'] = twilio_voice
    params['currency_symbol'] = currency_symbol
    params['currency_symbol_html'] = currency_symbol_html
    params['postcodeLookupActive'] = postcodeLookupActive
    params['addressFields'] = addressFields
    params['addressMatching'] = addressMatching
    params['dateFormat'] = dateFormat
    params['iso_3166_alpha_3'] = iso_3166_alpha_3
    params['iso_3166_numeric'] = iso_3166_numeric
    return doCurl("post","/country",params)
  end


  #
  # Fetching a country
  #
  #  @param country_id
  #  @return - the data from the api
  #
  def GETCountry( country_id)
    params = Hash.new
    params['country_id'] = country_id
    return doCurl("get","/country",params)
  end


  #
  # An API call to fetch a crash report by its ID
  #
  #  @param crash_report_id - The crash report to pull
  #  @return - the data from the api
  #
  def GETCrash_report( crash_report_id)
    params = Hash.new
    params['crash_report_id'] = crash_report_id
    return doCurl("get","/crash_report",params)
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
  def POSTEmail( to_email_address, reply_email_address, source_account, subject, body, html_body)
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
  # This entity isn't really supported anymore. You probably want PUT /business. Only to be used for testing.
  #
  #  @param type
  #  @param scope
  #  @param country
  #  @param timezone
  #  @param trust
  #  @param our_data
  #  @return - the data from the api
  #
  def PUTEntity( type, scope, country, timezone, trust, our_data)
    params = Hash.new
    params['type'] = type
    params['scope'] = scope
    params['country'] = country
    params['timezone'] = timezone
    params['trust'] = trust
    params['our_data'] = our_data
    return doCurl("put","/entity",params)
  end


  #
  # Allows a whole entity to be pulled from the datastore by its unique id
  #
  #  @param entity_id - The unique entity ID e.g. 379236608286720
  #  @param domain
  #  @param path
  #  @param data_filter
  #  @param filter_by_confidence
  #  @return - the data from the api
  #
  def GETEntity( entity_id, domain, path, data_filter, filter_by_confidence)
    params = Hash.new
    params['entity_id'] = entity_id
    params['domain'] = domain
    params['path'] = path
    params['data_filter'] = data_filter
    params['filter_by_confidence'] = filter_by_confidence
    return doCurl("get","/entity",params)
  end


  #
  # With a known entity id, an add can be updated.
  #
  #  @param entity_id
  #  @param add_referrer_url
  #  @param add_referrer_name
  #  @return - the data from the api
  #
  def POSTEntityAdd( entity_id, add_referrer_url, add_referrer_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['add_referrer_url'] = add_referrer_url
    params['add_referrer_name'] = add_referrer_name
    return doCurl("post","/entity/add",params)
  end


  #
  # Allows an advertiser object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityAdvertiser( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/advertiser",params)
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
  def POSTEntityAdvertiserCancel( entity_id, publisher_id, reseller_ref, reseller_agent_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    return doCurl("post","/entity/advertiser/cancel",params)
  end


  #
  # With a known entity id, a advertiser is added
  #
  #  @param entity_id
  #  @param tags
  #  @param locations
  #  @param loc_tags
  #  @param region_tags
  #  @param max_tags
  #  @param max_locations
  #  @param expiry_date
  #  @param is_national
  #  @param is_regional
  #  @param language
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTEntityAdvertiserCreate( entity_id, tags, locations, loc_tags, region_tags, max_tags, max_locations, expiry_date, is_national, is_regional, language, reseller_ref, reseller_agent_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tags'] = tags
    params['locations'] = locations
    params['loc_tags'] = loc_tags
    params['region_tags'] = region_tags
    params['max_tags'] = max_tags
    params['max_locations'] = max_locations
    params['expiry_date'] = expiry_date
    params['is_national'] = is_national
    params['is_regional'] = is_regional
    params['language'] = language
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/entity/advertiser/create",params)
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
  def POSTEntityAdvertiserLocation( entity_id, gen_id, locations_to_add, locations_to_remove)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['locations_to_add'] = locations_to_add
    params['locations_to_remove'] = locations_to_remove
    return doCurl("post","/entity/advertiser/location",params)
  end


  #
  # With a known entity id, a premium advertiser is cancelled
  #
  #  @param entity_id
  #  @param publisher_id
  #  @param type
  #  @param category_id - The category of the advertiser
  #  @param location_id - The location of the advertiser
  #  @return - the data from the api
  #
  def POSTEntityAdvertiserPremiumCancel( entity_id, publisher_id, type, category_id, location_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['type'] = type
    params['category_id'] = category_id
    params['location_id'] = location_id
    return doCurl("post","/entity/advertiser/premium/cancel",params)
  end


  #
  # With a known entity id, a premium advertiser is added
  #
  #  @param entity_id
  #  @param type
  #  @param category_id - The category of the advertiser
  #  @param location_id - The location of the advertiser
  #  @param expiry_date
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTEntityAdvertiserPremiumCreate( entity_id, type, category_id, location_id, expiry_date, reseller_ref, reseller_agent_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['type'] = type
    params['category_id'] = category_id
    params['location_id'] = location_id
    params['expiry_date'] = expiry_date
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/entity/advertiser/premium/create",params)
  end


  #
  # Renews an existing premium advertiser in an entity
  #
  #  @param entity_id
  #  @param type
  #  @param category_id - The category of the advertiser
  #  @param location_id - The location of the advertiser
  #  @param expiry_date
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTEntityAdvertiserPremiumRenew( entity_id, type, category_id, location_id, expiry_date, reseller_ref, reseller_agent_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['type'] = type
    params['category_id'] = category_id
    params['location_id'] = location_id
    params['expiry_date'] = expiry_date
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/entity/advertiser/premium/renew",params)
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
  def POSTEntityAdvertiserRenew( entity_id, expiry_date, publisher_id, reseller_ref, reseller_agent_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['expiry_date'] = expiry_date
    params['publisher_id'] = publisher_id
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    return doCurl("post","/entity/advertiser/renew",params)
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
  def POSTEntityAdvertiserTag( gen_id, entity_id, language, tags_to_add, tags_to_remove)
    params = Hash.new
    params['gen_id'] = gen_id
    params['entity_id'] = entity_id
    params['language'] = language
    params['tags_to_add'] = tags_to_add
    params['tags_to_remove'] = tags_to_remove
    return doCurl("post","/entity/advertiser/tag",params)
  end


  #
  # With a known entity id, an advertiser is updated
  #
  #  @param entity_id
  #  @param tags
  #  @param locations
  #  @param loc_tags
  #  @param is_regional
  #  @param region_tags
  #  @param extra_tags
  #  @param extra_locations
  #  @param is_national
  #  @param language
  #  @param reseller_ref
  #  @param reseller_agent_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTEntityAdvertiserUpsell( entity_id, tags, locations, loc_tags, is_regional, region_tags, extra_tags, extra_locations, is_national, language, reseller_ref, reseller_agent_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tags'] = tags
    params['locations'] = locations
    params['loc_tags'] = loc_tags
    params['is_regional'] = is_regional
    params['region_tags'] = region_tags
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
  # Search for matching entities that are advertisers and return a random selection upto the limit requested
  #
  #  @param tag - The word or words the advertiser is to appear for in searches
  #  @param where - The location to get results for. E.g. Dublin
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param is_national
  #  @param limit - The number of advertisers that are to be returned
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param benchmark
  #  @return - the data from the api
  #
  def GETEntityAdvertisers( tag, where, orderonline, delivers, isClaimed, is_national, limit, country, language, benchmark)
    params = Hash.new
    params['tag'] = tag
    params['where'] = where
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['is_national'] = is_national
    params['limit'] = limit
    params['country'] = country
    params['language'] = language
    params['benchmark'] = benchmark
    return doCurl("get","/entity/advertisers",params)
  end


  #
  # Search for matching entities in a specified location that are advertisers and return a random selection upto the limit requested
  #
  #  @param location - The location to get results for. E.g. Dublin
  #  @param is_national
  #  @param limit - The number of advertisers that are to be returned
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def GETEntityAdvertisersBy_location( location, is_national, limit, country, language)
    params = Hash.new
    params['location'] = location
    params['is_national'] = is_national
    params['limit'] = limit
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/advertisers/by_location",params)
  end


  #
  # Check if an entity has an advert from a specified publisher
  #
  #  @param entity_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def GETEntityAdvertisersInventorycheck( entity_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    return doCurl("get","/entity/advertisers/inventorycheck",params)
  end


  #
  # Get advertisers premium
  #
  #  @param what
  #  @param where
  #  @param type
  #  @param country
  #  @param language
  #  @return - the data from the api
  #
  def GETEntityAdvertisersPremium( what, where, type, country, language)
    params = Hash.new
    params['what'] = what
    params['where'] = where
    params['type'] = type
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/advertisers/premium",params)
  end


  #
  # Deleteing an affiliate adblock from a known entity
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityAffiliate_adblock( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/affiliate_adblock",params)
  end


  #
  # Adding an affiliate adblock to a known entity
  #
  #  @param entity_id
  #  @param adblock - Number of results returned per page
  #  @return - the data from the api
  #
  def POSTEntityAffiliate_adblock( entity_id, adblock)
    params = Hash.new
    params['entity_id'] = entity_id
    params['adblock'] = adblock
    return doCurl("post","/entity/affiliate_adblock",params)
  end


  #
  # With a known entity id, an affiliate link object can be added.
  #
  #  @param entity_id
  #  @param affiliate_name
  #  @param affiliate_link
  #  @param affiliate_message
  #  @param affiliate_logo
  #  @param affiliate_action
  #  @return - the data from the api
  #
  def POSTEntityAffiliate_link( entity_id, affiliate_name, affiliate_link, affiliate_message, affiliate_logo, affiliate_action)
    params = Hash.new
    params['entity_id'] = entity_id
    params['affiliate_name'] = affiliate_name
    params['affiliate_link'] = affiliate_link
    params['affiliate_message'] = affiliate_message
    params['affiliate_logo'] = affiliate_logo
    params['affiliate_action'] = affiliate_action
    return doCurl("post","/entity/affiliate_link",params)
  end


  #
  # Allows an affiliate link object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityAffiliate_link( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/affiliate_link",params)
  end


  #
  # Add/edit an annoucement object to an existing entity.
  #
  #  @param entity_id
  #  @param announcement_id
  #  @param headline
  #  @param body
  #  @param link_label
  #  @param link
  #  @param terms_link
  #  @param publish_date
  #  @param expiry_date
  #  @param media_type
  #  @param image_url
  #  @param video_url
  #  @param type - Type of announcement, which affects how it is displayed.
  #  @return - the data from the api
  #
  def POSTEntityAnnouncement( entity_id, announcement_id, headline, body, link_label, link, terms_link, publish_date, expiry_date, media_type, image_url, video_url, type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['announcement_id'] = announcement_id
    params['headline'] = headline
    params['body'] = body
    params['link_label'] = link_label
    params['link'] = link
    params['terms_link'] = terms_link
    params['publish_date'] = publish_date
    params['expiry_date'] = expiry_date
    params['media_type'] = media_type
    params['image_url'] = image_url
    params['video_url'] = video_url
    params['type'] = type
    return doCurl("post","/entity/announcement",params)
  end


  #
  # Fetch an announcement object from an existing entity.
  #
  #  @param entity_id
  #  @param announcement_id
  #  @return - the data from the api
  #
  def GETEntityAnnouncement( entity_id, announcement_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['announcement_id'] = announcement_id
    return doCurl("get","/entity/announcement",params)
  end


  #
  # Remove an announcement object to an existing entity.
  #
  #  @param entity_id
  #  @param announcement_id
  #  @return - the data from the api
  #
  def DELETEEntityAnnouncement( entity_id, announcement_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['announcement_id'] = announcement_id
    return doCurl("delete","/entity/announcement",params)
  end


  #
  # Will create a new association_membership or update an existing one
  #
  #  @param entity_id
  #  @param association_id
  #  @param association_member_url
  #  @param association_member_id
  #  @return - the data from the api
  #
  def POSTEntityAssociation_membership( entity_id, association_id, association_member_url, association_member_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['association_id'] = association_id
    params['association_member_url'] = association_member_url
    params['association_member_id'] = association_member_id
    return doCurl("post","/entity/association_membership",params)
  end


  #
  # Allows a association_membership object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityAssociation_membership( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/association_membership",params)
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
  def POSTEntityBackground( entity_id, number_of_employees, turnover, net_profit, vat_number, duns_number, registered_company_number)
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
  # With a known entity id, a brand object can be added.
  #
  #  @param entity_id
  #  @param value
  #  @return - the data from the api
  #
  def POSTEntityBrand( entity_id, value)
    params = Hash.new
    params['entity_id'] = entity_id
    params['value'] = value
    return doCurl("post","/entity/brand",params)
  end


  #
  # With a known entity id, a brand object can be deleted.
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityBrand( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/brand",params)
  end


  #
  # Uploads a CSV file of known format and bulk inserts into DB
  #
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTEntityBulkCsv( filedata)
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
  def GETEntityBulkCsvStatus( upload_id)
    params = Hash.new
    params['upload_id'] = upload_id
    return doCurl("get","/entity/bulk/csv/status",params)
  end


  #
  # Uploads a JSON file of known format and bulk inserts into DB
  #
  #  @param data
  #  @param new_entities
  #  @return - the data from the api
  #
  def POSTEntityBulkJson( data, new_entities)
    params = Hash.new
    params['data'] = data
    params['new_entities'] = new_entities
    return doCurl("post","/entity/bulk/json",params)
  end


  #
  # Shows the current status of a bulk JSON upload
  #
  #  @param upload_id
  #  @return - the data from the api
  #
  def GETEntityBulkJsonStatus( upload_id)
    params = Hash.new
    params['upload_id'] = upload_id
    return doCurl("get","/entity/bulk/json/status",params)
  end


  #
  # Fetches the document that matches the given data_source_type and external_id.
  #
  #  @param data_source_type - The data source type of the entity
  #  @param external_id - The external ID of the entity
  #  @return - the data from the api
  #
  def GETEntityBy_external_id( data_source_type, external_id)
    params = Hash.new
    params['data_source_type'] = data_source_type
    params['external_id'] = external_id
    return doCurl("get","/entity/by_external_id",params)
  end


  #
  # Get all entities within a specified group
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def GETEntityBy_groupid( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("get","/entity/by_groupid",params)
  end


  #
  # Fetches the document that matches the given legacy_url
  #
  #  @param legacy_url - The URL of the entity in the directory it was imported from.
  #  @return - the data from the api
  #
  def GETEntityBy_legacy_url( legacy_url)
    params = Hash.new
    params['legacy_url'] = legacy_url
    return doCurl("get","/entity/by_legacy_url",params)
  end


  #
  # uncontributes a given entities supplier content and makes the entity inactive if the entity is un-usable
  #
  #  @param entity_id - The entity to pull
  #  @param supplier_masheryid - The suppliers masheryid to match
  #  @param supplier_id - The supplier id to match
  #  @param supplier_user_id - The user id to match
  #  @return - the data from the api
  #
  def DELETEEntityBy_supplier( entity_id, supplier_masheryid, supplier_id, supplier_user_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['supplier_masheryid'] = supplier_masheryid
    params['supplier_id'] = supplier_id
    params['supplier_user_id'] = supplier_user_id
    return doCurl("delete","/entity/by_supplier",params)
  end


  #
  # Fetches the documents that match the given masheryid and supplier_id
  #
  #  @param supplier_id - The Supplier ID, or a list of supplier IDs separated by comma
  #  @return - the data from the api
  #
  def GETEntityBy_supplier_id( supplier_id)
    params = Hash.new
    params['supplier_id'] = supplier_id
    return doCurl("get","/entity/by_supplier_id",params)
  end


  #
  # Get all entities added or claimed by a specific user
  #
  #  @param user_id - The unique user ID of the user with claimed entities e.g. 379236608286720
  #  @param filter
  #  @param skip
  #  @param limit
  #  @return - the data from the api
  #
  def GETEntityBy_user_id( user_id, filter, skip, limit)
    params = Hash.new
    params['user_id'] = user_id
    params['filter'] = filter
    params['skip'] = skip
    params['limit'] = limit
    return doCurl("get","/entity/by_user_id",params)
  end


  #
  # With a known entity id, an category object can be added.
  #
  #  @param entity_id
  #  @param category_id
  #  @param category_type
  #  @return - the data from the api
  #
  def POSTEntityCategory( entity_id, category_id, category_type)
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
  def DELETEEntityCategory( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/category",params)
  end


  #
  # Fetches the changelog documents that match the given entity_id
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def GETEntityChangelog( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity/changelog",params)
  end


  #
  # Unlike cancel, this operation remove the claim data from the entity
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def DELETEEntityClaim( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/claim",params)
  end


  #
  # Allow an entity to be claimed by a valid user
  #
  #  @param entity_id
  #  @param claimed_user_id
  #  @param claimed_reseller_id
  #  @param expiry_date
  #  @param claimed_date
  #  @param verified_status - If set to a value, this field will promote the claim to pro mode (expiry aligned with claim expiry)
  #  @param claim_method
  #  @param phone_number
  #  @param referrer_url
  #  @param referrer_name
  #  @param reseller_ref
  #  @param reseller_description
  #  @return - the data from the api
  #
  def POSTEntityClaim( entity_id, claimed_user_id, claimed_reseller_id, expiry_date, claimed_date, verified_status, claim_method, phone_number, referrer_url, referrer_name, reseller_ref, reseller_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['claimed_user_id'] = claimed_user_id
    params['claimed_reseller_id'] = claimed_reseller_id
    params['expiry_date'] = expiry_date
    params['claimed_date'] = claimed_date
    params['verified_status'] = verified_status
    params['claim_method'] = claim_method
    params['phone_number'] = phone_number
    params['referrer_url'] = referrer_url
    params['referrer_name'] = referrer_name
    params['reseller_ref'] = reseller_ref
    params['reseller_description'] = reseller_description
    return doCurl("post","/entity/claim",params)
  end


  #
  # Cancel a claim that is on the entity
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def POSTEntityClaimCancel( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("post","/entity/claim/cancel",params)
  end


  #
  # Allow an entity to be claimed by a valid user
  #
  #  @param entity_id
  #  @param claimed_user_id
  #  @param reseller_ref
  #  @param reseller_description
  #  @param expiry_date
  #  @param renew_verify - Update the verified_status (where present) as well. Paid claims should do this -- free claims generally will not.
  #  @return - the data from the api
  #
  def POSTEntityClaimRenew( entity_id, claimed_user_id, reseller_ref, reseller_description, expiry_date, renew_verify)
    params = Hash.new
    params['entity_id'] = entity_id
    params['claimed_user_id'] = claimed_user_id
    params['reseller_ref'] = reseller_ref
    params['reseller_description'] = reseller_description
    params['expiry_date'] = expiry_date
    params['renew_verify'] = renew_verify
    return doCurl("post","/entity/claim/renew",params)
  end


  #
  # Allow an entity to be claimed by a valid reseller
  #
  #  @param entity_id
  #  @param reseller_ref
  #  @param reseller_description
  #  @return - the data from the api
  #
  def POSTEntityClaimReseller( entity_id, reseller_ref, reseller_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['reseller_ref'] = reseller_ref
    params['reseller_description'] = reseller_description
    return doCurl("post","/entity/claim/reseller",params)
  end


  #
  # If an entity is currently claimed then set or remove the verified_entity block (Expiry will match the claim expiry)
  #
  #  @param entity_id
  #  @param verified_status - If set to a value, this field will promote the claim to pro mode. If blank, verified status will be wiped
  #  @return - the data from the api
  #
  def POSTEntityClaimVerfied_status( entity_id, verified_status)
    params = Hash.new
    params['entity_id'] = entity_id
    params['verified_status'] = verified_status
    return doCurl("post","/entity/claim/verfied_status",params)
  end


  #
  # Add/change delivers flag for an existing entity - to indicate whether business offers delivery
  #
  #  @param entity_id
  #  @param delivers
  #  @return - the data from the api
  #
  def POSTEntityDelivers( entity_id, delivers)
    params = Hash.new
    params['entity_id'] = entity_id
    params['delivers'] = delivers
    return doCurl("post","/entity/delivers",params)
  end


  #
  # Allows a description object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityDescription( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/description",params)
  end


  #
  # With a known entity id, a description object can be added.
  #
  #  @param entity_id
  #  @param headline
  #  @param body
  #  @param gen_id
  #  @return - the data from the api
  #
  def POSTEntityDescription( entity_id, headline, body, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    params['gen_id'] = gen_id
    return doCurl("post","/entity/description",params)
  end


  #
  # With a known entity id, an document object can be added.
  #
  #  @param entity_id
  #  @param name
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTEntityDocument( entity_id, name, filedata)
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
  def DELETEEntityDocument( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/document",params)
  end


  #
  # Upload a document to an entity
  #
  #  @param entity_id
  #  @param document
  #  @return - the data from the api
  #
  def POSTEntityDocumentBy_url( entity_id, document)
    params = Hash.new
    params['entity_id'] = entity_id
    params['document'] = document
    return doCurl("post","/entity/document/by_url",params)
  end


  #
  # Allows a email object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityEmail( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/email",params)
  end


  #
  # With a known entity id, an email address object can be added.
  #
  #  @param entity_id
  #  @param email_address
  #  @param email_description
  #  @return - the data from the api
  #
  def POSTEntityEmail( entity_id, email_address, email_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['email_address'] = email_address
    params['email_description'] = email_description
    return doCurl("post","/entity/email",params)
  end


  #
  # Fetch an emergency statement object from an existing entity.
  #
  #  @param entity_id
  #  @param emergencystatement_id
  #  @return - the data from the api
  #
  def GETEntityEmergencystatement( entity_id, emergencystatement_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['emergencystatement_id'] = emergencystatement_id
    return doCurl("get","/entity/emergencystatement",params)
  end


  #
  # Add or update an emergency statement object to an existing entity.
  #
  #  @param entity_id
  #  @param id
  #  @param headline
  #  @param body
  #  @param link_label
  #  @param link
  #  @param publish_date
  #  @return - the data from the api
  #
  def POSTEntityEmergencystatement( entity_id, id, headline, body, link_label, link, publish_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['id'] = id
    params['headline'] = headline
    params['body'] = body
    params['link_label'] = link_label
    params['link'] = link
    params['publish_date'] = publish_date
    return doCurl("post","/entity/emergencystatement",params)
  end


  #
  # Remove an emergencystatement object to an existing entity.
  #
  #  @param entity_id
  #  @param emergencystatement_id
  #  @return - the data from the api
  #
  def DELETEEntityEmergencystatement( entity_id, emergencystatement_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['emergencystatement_id'] = emergencystatement_id
    return doCurl("delete","/entity/emergencystatement",params)
  end


  #
  # Fetch emergency statement objects from an existing entity.
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def GETEntityEmergencystatements( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity/emergencystatements",params)
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
  def POSTEntityEmployee( entity_id, title, forename, surname, job_title, description, email, phone_number)
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
  def DELETEEntityEmployee( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/employee",params)
  end


  #
  # With a known entity id, an FAQ question and answer can be added.
  #
  #  @param entity_id
  #  @param question
  #  @param answer
  #  @param gen_id
  #  @return - the data from the api
  #
  def POSTEntityFaq( entity_id, question, answer, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['question'] = question
    params['answer'] = answer
    params['gen_id'] = gen_id
    return doCurl("post","/entity/faq",params)
  end


  #
  # With a known entity id, an FAQ question and answer can be removed.
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityFaq( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/faq",params)
  end


  #
  # Allows a fax object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityFax( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/fax",params)
  end


  #
  # With a known entity id, an fax object can be added.
  #
  #  @param entity_id
  #  @param number
  #  @param description
  #  @return - the data from the api
  #
  def POSTEntityFax( entity_id, number, description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
    params['description'] = description
    return doCurl("post","/entity/fax",params)
  end


  #
  # With a known entity id, a featured message can be added
  #
  #  @param entity_id
  #  @param featured_text
  #  @param featured_url
  #  @return - the data from the api
  #
  def POSTEntityFeatured_message( entity_id, featured_text, featured_url)
    params = Hash.new
    params['entity_id'] = entity_id
    params['featured_text'] = featured_text
    params['featured_url'] = featured_url
    return doCurl("post","/entity/featured_message",params)
  end


  #
  # Allows a featured message object to be removed
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def DELETEEntityFeatured_message( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/featured_message",params)
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
  def POSTEntityGeopoint( entity_id, longitude, latitude, accuracy)
    params = Hash.new
    params['entity_id'] = entity_id
    params['longitude'] = longitude
    params['latitude'] = latitude
    params['accuracy'] = accuracy
    return doCurl("post","/entity/geopoint",params)
  end


  #
  # With a known entity id, a group  can be added to group members.
  #
  #  @param entity_id
  #  @param group_id
  #  @return - the data from the api
  #
  def POSTEntityGroup( entity_id, group_id)
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
  def DELETEEntityGroup( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/group",params)
  end


  #
  # With a known entity id, a image object can be added.
  #
  #  @param entity_id
  #  @param filedata
  #  @param image_name
  #  @return - the data from the api
  #
  def POSTEntityImage( entity_id, filedata, image_name)
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
  def DELETEEntityImage( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/image",params)
  end


  #
  # With a known entity id, a image can be retrieved from a url and added.
  #
  #  @param entity_id
  #  @param image_url
  #  @param image_name
  #  @return - the data from the api
  #
  def POSTEntityImageBy_url( entity_id, image_url, image_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['image_url'] = image_url
    params['image_name'] = image_name
    return doCurl("post","/entity/image/by_url",params)
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
  #  @param province
  #  @param postcode
  #  @param address_type
  #  @return - the data from the api
  #
  def POSTEntityInvoice_address( entity_id, building_number, address1, address2, address3, district, town, county, province, postcode, address_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['province'] = province
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
  def DELETEEntityInvoice_address( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/invoice_address",params)
  end


  #
  # With a known entity id, a language object can be deleted.
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityLanguage( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/language",params)
  end


  #
  # With a known entity id, a language object can be added.
  #
  #  @param entity_id
  #  @param value
  #  @return - the data from the api
  #
  def POSTEntityLanguage( entity_id, value)
    params = Hash.new
    params['entity_id'] = entity_id
    params['value'] = value
    return doCurl("post","/entity/language",params)
  end


  #
  # Allows a list description object to be reduced in confidence
  #
  #  @param gen_id
  #  @param entity_id
  #  @return - the data from the api
  #
  def DELETEEntityList( gen_id, entity_id)
    params = Hash.new
    params['gen_id'] = gen_id
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/list",params)
  end


  #
  # With a known entity id, a list description object can be added.
  #
  #  @param entity_id
  #  @param headline
  #  @param body
  #  @return - the data from the api
  #
  def POSTEntityList( entity_id, headline, body)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    return doCurl("post","/entity/list",params)
  end


  #
  # Find all entities in a group
  #
  #  @param group_id - A valid group_id
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @return - the data from the api
  #
  def GETEntityList_by_group_id( group_id, per_page, page)
    params = Hash.new
    params['group_id'] = group_id
    params['per_page'] = per_page
    params['page'] = page
    return doCurl("get","/entity/list_by_group_id",params)
  end


  #
  # Adds/removes loc_tags
  #
  #  @param entity_id
  #  @param gen_id
  #  @param loc_tags_to_add
  #  @param loc_tags_to_remove
  #  @return - the data from the api
  #
  def POSTEntityLoc_tag( entity_id, gen_id, loc_tags_to_add, loc_tags_to_remove)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['loc_tags_to_add'] = loc_tags_to_add
    params['loc_tags_to_remove'] = loc_tags_to_remove
    return doCurl("post","/entity/loc_tag",params)
  end


  #
  # Allows a phone object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityLogo( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/logo",params)
  end


  #
  # With a known entity id, a logo object can be added.
  #
  #  @param entity_id
  #  @param filedata
  #  @param logo_name
  #  @return - the data from the api
  #
  def POSTEntityLogo( entity_id, filedata, logo_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['filedata'] = filedata
    params['logo_name'] = logo_name
    return doCurl("post","/entity/logo",params)
  end


  #
  # With a known entity id, a logo can be retrieved from a url and added.
  #
  #  @param entity_id
  #  @param logo_url
  #  @param logo_name
  #  @return - the data from the api
  #
  def POSTEntityLogoBy_url( entity_id, logo_url, logo_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['logo_url'] = logo_url
    params['logo_name'] = logo_name
    return doCurl("post","/entity/logo/by_url",params)
  end


  #
  # Merge two entities into one
  #
  #  @param from
  #  @param to
  #  @param override_trust - Do you want to override the trust of the 'from' entity
  #  @param uncontribute_masheryid - Do we want to uncontribute any data for a masheryid?
  #  @param uncontribute_userid - Do we want to uncontribute any data for a user_id?
  #  @param uncontribute_supplierid - Do we want to uncontribute any data for a supplier_id?
  #  @param delete_mode - The type of object contribution deletion
  #  @return - the data from the api
  #
  def POSTEntityMerge( from, to, override_trust, uncontribute_masheryid, uncontribute_userid, uncontribute_supplierid, delete_mode)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['override_trust'] = override_trust
    params['uncontribute_masheryid'] = uncontribute_masheryid
    params['uncontribute_userid'] = uncontribute_userid
    params['uncontribute_supplierid'] = uncontribute_supplierid
    params['delete_mode'] = delete_mode
    return doCurl("post","/entity/merge",params)
  end


  #
  # Update entities that use an old category ID to a new one
  #
  #  @param from
  #  @param to
  #  @param limit
  #  @return - the data from the api
  #
  def POSTEntityMigrate_category( from, to, limit)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['limit'] = limit
    return doCurl("post","/entity/migrate_category",params)
  end


  #
  # With a known entity id, a name can be updated.
  #
  #  @param entity_id
  #  @param name
  #  @param formal_name
  #  @param branch_name
  #  @return - the data from the api
  #
  def POSTEntityName( entity_id, name, formal_name, branch_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['name'] = name
    params['formal_name'] = formal_name
    params['branch_name'] = branch_name
    return doCurl("post","/entity/name",params)
  end


  #
  # With a known entity id, a opening times object can be added. Each day can be either 'closed' to indicate that the entity is closed that day, '24hour' to indicate that the entity is open all day or single/split time ranges can be supplied in 4-digit 24-hour format, such as '09001730' or '09001200,13001700' to indicate hours of opening.
  #
  #  @param entity_id - The id of the entity to edit
  #  @param statement - Statement describing reasons for special opening/closing times
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
  def POSTEntityOpening_times( entity_id, statement, monday, tuesday, wednesday, thursday, friday, saturday, sunday, closed, closed_public_holidays)
    params = Hash.new
    params['entity_id'] = entity_id
    params['statement'] = statement
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
  # With a known entity id, a opening times object can be removed.
  #
  #  @param entity_id - The id of the entity to edit
  #  @return - the data from the api
  #
  def DELETEEntityOpening_times( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/opening_times",params)
  end


  #
  # Add an order online to an existing entity - to indicate e-commerce capability.
  #
  #  @param entity_id
  #  @param orderonline
  #  @return - the data from the api
  #
  def POSTEntityOrderonline( entity_id, orderonline)
    params = Hash.new
    params['entity_id'] = entity_id
    params['orderonline'] = orderonline
    return doCurl("post","/entity/orderonline",params)
  end


  #
  # Allows a payment_type object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityPayment_type( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/payment_type",params)
  end


  #
  # With a known entity id, a payment_type object can be added.
  #
  #  @param entity_id - the id of the entity to add the payment type to
  #  @param payment_type - the payment type to add to the entity
  #  @return - the data from the api
  #
  def POSTEntityPayment_type( entity_id, payment_type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['payment_type'] = payment_type
    return doCurl("post","/entity/payment_type",params)
  end


  #
  # Allows a new phone object to be added to a specified entity. A new object id will be calculated and returned to you if successful.
  #
  #  @param entity_id
  #  @param number
  #  @param description
  #  @param trackable
  #  @return - the data from the api
  #
  def POSTEntityPhone( entity_id, number, description, trackable)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
    params['description'] = description
    params['trackable'] = trackable
    return doCurl("post","/entity/phone",params)
  end


  #
  # Allows a phone object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityPhone( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/phone",params)
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
  #  @param province
  #  @param postcode
  #  @param address_type
  #  @param do_not_display
  #  @return - the data from the api
  #
  def POSTEntityPostal_address( entity_id, building_number, address1, address2, address3, district, town, county, province, postcode, address_type, do_not_display)
    params = Hash.new
    params['entity_id'] = entity_id
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['province'] = province
    params['postcode'] = postcode
    params['address_type'] = address_type
    params['do_not_display'] = do_not_display
    return doCurl("post","/entity/postal_address",params)
  end


  #
  # Fetches the documents that match the given masheryid and supplier_id
  #
  #  @param supplier_id - The Supplier ID
  #  @return - the data from the api
  #
  def GETEntityProvisionalBy_supplier_id( supplier_id)
    params = Hash.new
    params['supplier_id'] = supplier_id
    return doCurl("get","/entity/provisional/by_supplier_id",params)
  end


  #
  # removes a given entities supplier/masheryid/user_id content and makes the entity inactive if the entity is un-usable
  #
  #  @param entity_id - The entity to pull
  #  @param purge_masheryid - The purge masheryid to match
  #  @param purge_supplier_id - The purge supplier id to match
  #  @param purge_user_id - The purge user id to match
  #  @param exclude - List of entity fields that are excluded from the purge
  #  @param destructive
  #  @return - the data from the api
  #
  def POSTEntityPurge( entity_id, purge_masheryid, purge_supplier_id, purge_user_id, exclude, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['purge_masheryid'] = purge_masheryid
    params['purge_supplier_id'] = purge_supplier_id
    params['purge_user_id'] = purge_user_id
    params['exclude'] = exclude
    params['destructive'] = destructive
    return doCurl("post","/entity/purge",params)
  end


  #
  # removes a portion of a given entity and makes the entity inactive if the resulting leftover entity is un-usable
  #
  #  @param entity_id - The entity to pull
  #  @param object
  #  @param gen_id - The gen_id of any multi-object being purged
  #  @param purge_masheryid - The purge masheryid to match
  #  @param purge_supplier_id - The purge supplier id to match
  #  @param purge_user_id - The purge user id to match
  #  @param destructive
  #  @return - the data from the api
  #
  def POSTEntityPurgeBy_object( entity_id, object, gen_id, purge_masheryid, purge_supplier_id, purge_user_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['object'] = object
    params['gen_id'] = gen_id
    params['purge_masheryid'] = purge_masheryid
    params['purge_supplier_id'] = purge_supplier_id
    params['purge_user_id'] = purge_user_id
    params['destructive'] = destructive
    return doCurl("post","/entity/purge/by_object",params)
  end


  #
  # Deletes a specific review for an entity via Review API
  #
  #  @param entity_id - The entity with the review
  #  @param review_id - The review id
  #  @return - the data from the api
  #
  def DELETEEntityReview( entity_id, review_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['review_id'] = review_id
    return doCurl("delete","/entity/review",params)
  end


  #
  # Gets a specific review  for an entity
  #
  #  @param entity_id - The entity with the review
  #  @param review_id - The review id
  #  @return - the data from the api
  #
  def GETEntityReview( entity_id, review_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['review_id'] = review_id
    return doCurl("get","/entity/review",params)
  end


  #
  # Appends a review to an entity
  #
  #  @param entity_id - the entity to append the review to
  #  @param reviewer_user_id - The user id
  #  @param review_id - The review id. If this is supplied will attempt to update an existing review
  #  @param title - The title of the review
  #  @param content - The full text content of the review
  #  @param star_rating - The rating of the review
  #  @param domain - The domain the review originates from
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTEntityReview( entity_id, reviewer_user_id, review_id, title, content, star_rating, domain, filedata)
    params = Hash.new
    params['entity_id'] = entity_id
    params['reviewer_user_id'] = reviewer_user_id
    params['review_id'] = review_id
    params['title'] = title
    params['content'] = content
    params['star_rating'] = star_rating
    params['domain'] = domain
    params['filedata'] = filedata
    return doCurl("post","/entity/review",params)
  end


  #
  # Gets all reviews for an entity
  #
  #  @param entity_id - The entity with the review
  #  @param limit - Limit the number of results returned
  #  @param skip - Number of results skipped
  #  @return - the data from the api
  #
  def GETEntityReviewList( entity_id, limit, skip)
    params = Hash.new
    params['entity_id'] = entity_id
    params['limit'] = limit
    params['skip'] = skip
    return doCurl("get","/entity/review/list",params)
  end


  #
  # Allows a list of available revisions to be returned by its entity id
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def GETEntityRevisions( entity_id)
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
  def GETEntityRevisionsByRevisionID( entity_id, revision_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['revision_id'] = revision_id
    return doCurl("get","/entity/revisions/byRevisionID",params)
  end


  #
  # Search for matching entities
  #
  #  @param latitude_1
  #  @param longitude_1
  #  @param latitude_2
  #  @param longitude_2
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page
  #  @param page
  #  @param country
  #  @param language
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @return - the data from the api
  #
  def GETEntitySearchByboundingbox( latitude_1, longitude_1, latitude_2, longitude_2, orderonline, delivers, isClaimed, per_page, page, country, language, domain, path, restrict_category_ids)
    params = Hash.new
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    return doCurl("get","/entity/search/byboundingbox",params)
  end


  #
  # Search for matching entities
  #
  #  @param where - Location to search for results. E.g. Dublin e.g. Dublin
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page - How many results per page
  #  @param page - What page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the search context (optional)
  #  @param longitude - The decimal longitude of the search context (optional)
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @param benchmark
  #  @return - the data from the api
  #
  def GETEntitySearchBylocation( where, orderonline, delivers, isClaimed, per_page, page, country, language, latitude, longitude, domain, path, restrict_category_ids, benchmark)
    params = Hash.new
    params['where'] = where
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    params['benchmark'] = benchmark
    return doCurl("get","/entity/search/bylocation",params)
  end


  #
  # Search for entities matching the supplied group_id, ordered by nearness
  #
  #  @param group_id - the group_id to search for
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param where - The location to search for
  #  @param domain
  #  @param path
  #  @param unitOfDistance
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @return - the data from the api
  #
  def GETEntitySearchGroupBynearest( group_id, orderonline, delivers, isClaimed, country, per_page, page, language, latitude, longitude, where, domain, path, unitOfDistance, restrict_category_ids)
    params = Hash.new
    params['group_id'] = group_id
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['where'] = where
    params['domain'] = domain
    params['path'] = path
    params['unitOfDistance'] = unitOfDistance
    params['restrict_category_ids'] = restrict_category_ids
    return doCurl("get","/entity/search/group/bynearest",params)
  end


  #
  # Search for entities matching the supplied 'who', ordered by nearness. NOTE if you want to see any advertisers then append MASHERYID (even if using API key) and include_ads=true to get your ads matching that keyword and the derived location.
  #
  #  @param keyword - What to get results for. E.g. cafe e.g. cafe
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @param include_ads - Find nearby advertisers with tags that match the keyword
  #  @return - the data from the api
  #
  def GETEntitySearchKeywordBynearest( keyword, orderonline, delivers, isClaimed, country, per_page, page, language, latitude, longitude, domain, path, restrict_category_ids, include_ads)
    params = Hash.new
    params['keyword'] = keyword
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    params['include_ads'] = include_ads
    return doCurl("get","/entity/search/keyword/bynearest",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page - Number of results returned per page
  #  @param page - The page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @param benchmark
  #  @return - the data from the api
  #
  def GETEntitySearchWhat( what, orderonline, delivers, isClaimed, per_page, page, country, language, domain, path, restrict_category_ids, benchmark)
    params = Hash.new
    params['what'] = what
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    params['benchmark'] = benchmark
    return doCurl("get","/entity/search/what",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param latitude_1 - Latitude of first point in bounding box e.g. 53.396842
  #  @param longitude_1 - Longitude of first point in bounding box e.g. -6.37619
  #  @param latitude_2 - Latitude of second point in bounding box e.g. 53.290463
  #  @param longitude_2 - Longitude of second point in bounding box e.g. -6.207275
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page
  #  @param page
  #  @param country - A valid ISO 3166 country code e.g. ie
  #  @param language
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @return - the data from the api
  #
  def GETEntitySearchWhatByboundingbox( what, latitude_1, longitude_1, latitude_2, longitude_2, orderonline, delivers, isClaimed, per_page, page, country, language, domain, path, restrict_category_ids)
    params = Hash.new
    params['what'] = what
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    return doCurl("get","/entity/search/what/byboundingbox",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param where - The location to get results for. E.g. Dublin e.g. Dublin
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the search context (optional)
  #  @param longitude - The decimal longitude of the search context (optional)
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @param benchmark
  #  @return - the data from the api
  #
  def GETEntitySearchWhatBylocation( what, where, orderonline, delivers, isClaimed, per_page, page, country, language, latitude, longitude, domain, path, restrict_category_ids, benchmark)
    params = Hash.new
    params['what'] = what
    params['where'] = where
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    params['benchmark'] = benchmark
    return doCurl("get","/entity/search/what/bylocation",params)
  end


  #
  # Search for matching entities, ordered by nearness
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @return - the data from the api
  #
  def GETEntitySearchWhatBynearest( what, orderonline, delivers, isClaimed, country, per_page, page, language, latitude, longitude, domain, path, restrict_category_ids)
    params = Hash.new
    params['what'] = what
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    return doCurl("get","/entity/search/what/bynearest",params)
  end


  #
  # Search for matching entities
  #
  #  @param who - Company name e.g. Starbucks
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page - How many results per page
  #  @param page - What page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @param benchmark
  #  @return - the data from the api
  #
  def GETEntitySearchWho( who, orderonline, delivers, isClaimed, per_page, page, country, language, domain, path, restrict_category_ids, benchmark)
    params = Hash.new
    params['who'] = who
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    params['benchmark'] = benchmark
    return doCurl("get","/entity/search/who",params)
  end


  #
  # Search for matching entities
  #
  #  @param who
  #  @param latitude_1
  #  @param longitude_1
  #  @param latitude_2
  #  @param longitude_2
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page
  #  @param page
  #  @param country
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @return - the data from the api
  #
  def GETEntitySearchWhoByboundingbox( who, latitude_1, longitude_1, latitude_2, longitude_2, orderonline, delivers, isClaimed, per_page, page, country, language, domain, path, restrict_category_ids)
    params = Hash.new
    params['who'] = who
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    return doCurl("get","/entity/search/who/byboundingbox",params)
  end


  #
  # Search for matching entities
  #
  #  @param who - Company Name e.g. Starbucks
  #  @param where - The location to get results for. E.g. Dublin e.g. Dublin
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param latitude - The decimal latitude of the search context (optional)
  #  @param longitude - The decimal longitude of the search context (optional)
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @param benchmark
  #  @return - the data from the api
  #
  def GETEntitySearchWhoBylocation( who, where, orderonline, delivers, isClaimed, per_page, page, country, latitude, longitude, language, domain, path, restrict_category_ids, benchmark)
    params = Hash.new
    params['who'] = who
    params['where'] = where
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    params['benchmark'] = benchmark
    return doCurl("get","/entity/search/who/bylocation",params)
  end


  #
  # Search for entities matching the supplied 'who', ordered by nearness
  #
  #  @param who - What to get results for. E.g. Plumber e.g. plumber
  #  @param orderonline - Favours online ordering where set to true
  #  @param delivers - Favours delivery where set to true
  #  @param isClaimed - 1: claimed; 0: not claimed or claim expired; -1: ignore this filter.
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @param restrict_category_ids - Pipe delimited optional IDs to restrict matches to (optional)
  #  @return - the data from the api
  #
  def GETEntitySearchWhoBynearest( who, orderonline, delivers, isClaimed, country, per_page, page, language, latitude, longitude, domain, path, restrict_category_ids)
    params = Hash.new
    params['who'] = who
    params['orderonline'] = orderonline
    params['delivers'] = delivers
    params['isClaimed'] = isClaimed
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    params['restrict_category_ids'] = restrict_category_ids
    return doCurl("get","/entity/search/who/bynearest",params)
  end


  #
  # Send an email to an email address specified in an entity
  #
  #  @param entity_id - The entity id of the entity you wish to contact
  #  @param gen_id - The gen_id of the email address you wish to send the message to
  #  @param from_email - The email of the person sending the message 
  #  @param subject - The subject for the email
  #  @param content - The content of the email
  #  @return - the data from the api
  #
  def POSTEntitySend_email( entity_id, gen_id, from_email, subject, content)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['from_email'] = from_email
    params['subject'] = subject
    params['content'] = content
    return doCurl("post","/entity/send_email",params)
  end


  #
  # With a known entity id, a service object can be added.
  #
  #  @param entity_id
  #  @param value
  #  @return - the data from the api
  #
  def POSTEntityService( entity_id, value)
    params = Hash.new
    params['entity_id'] = entity_id
    params['value'] = value
    return doCurl("post","/entity/service",params)
  end


  #
  # With a known entity id, a service object can be deleted.
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityService( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/service",params)
  end


  #
  # With a known entity id, a social media object can be added.
  #
  #  @param entity_id
  #  @param type
  #  @param website_url
  #  @return - the data from the api
  #
  def POSTEntitySocialmedia( entity_id, type, website_url)
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
  def DELETEEntitySocialmedia( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/socialmedia",params)
  end


  #
  # Allows a special offer object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntitySpecial_offer( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/special_offer",params)
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
  #  @return - the data from the api
  #
  def POSTEntitySpecial_offer( entity_id, title, description, terms, start_date, expiry_date, url)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['description'] = description
    params['terms'] = terms
    params['start_date'] = start_date
    params['expiry_date'] = expiry_date
    params['url'] = url
    return doCurl("post","/entity/special_offer",params)
  end


  #
  # With a known entity id, a status object can be updated.
  #
  #  @param entity_id
  #  @param status
  #  @param inactive_reason
  #  @param inactive_description
  #  @return - the data from the api
  #
  def POSTEntityStatus( entity_id, status, inactive_reason, inactive_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['status'] = status
    params['inactive_reason'] = inactive_reason
    params['inactive_description'] = inactive_description
    return doCurl("post","/entity/status",params)
  end


  #
  # Suspend all entiies added or claimed by a specific user
  #
  #  @param user_id - The unique user ID of the user with claimed entities e.g. 379236608286720
  #  @return - the data from the api
  #
  def POSTEntityStatusSuspend_by_user_id( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("post","/entity/status/suspend_by_user_id",params)
  end


  #
  # Allows a tag object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityTag( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/tag",params)
  end


  #
  # With a known entity id, an tag object can be added.
  #
  #  @param entity_id
  #  @param tag
  #  @param language
  #  @return - the data from the api
  #
  def POSTEntityTag( entity_id, tag, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tag'] = tag
    params['language'] = language
    return doCurl("post","/entity/tag",params)
  end


  #
  # Allows a testimonial object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityTestimonial( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/testimonial",params)
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
  def POSTEntityTestimonial( entity_id, title, text, date, testifier_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['text'] = text
    params['date'] = date
    params['testifier_name'] = testifier_name
    return doCurl("post","/entity/testimonial",params)
  end


  #
  # Get the updates a uncontribute would perform
  #
  #  @param entity_id - The entity to pull
  #  @param object_name - The entity object to update
  #  @param supplier_id - The supplier_id to remove
  #  @param user_id - The user_id to remove
  #  @return - the data from the api
  #
  def GETEntityUncontribute( entity_id, object_name, supplier_id, user_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['object_name'] = object_name
    params['supplier_id'] = supplier_id
    params['user_id'] = user_id
    return doCurl("get","/entity/uncontribute",params)
  end


  #
  # Separates an entity into two distinct entities 
  #
  #  @param entity_id
  #  @param unmerge_masheryid
  #  @param unmerge_supplier_id
  #  @param unmerge_user_id
  #  @param destructive
  #  @return - the data from the api
  #
  def POSTEntityUnmerge( entity_id, unmerge_masheryid, unmerge_supplier_id, unmerge_user_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['unmerge_masheryid'] = unmerge_masheryid
    params['unmerge_supplier_id'] = unmerge_supplier_id
    params['unmerge_user_id'] = unmerge_user_id
    params['destructive'] = destructive
    return doCurl("post","/entity/unmerge",params)
  end


  #
  # Find the provided user in all the sub objects and update the trust
  #
  #  @param entity_id - the entity_id to update
  #  @param user_id - the user to search for
  #  @param trust - The new trust for the user
  #  @return - the data from the api
  #
  def POSTEntityUser_trust( entity_id, user_id, trust)
    params = Hash.new
    params['entity_id'] = entity_id
    params['user_id'] = user_id
    params['trust'] = trust
    return doCurl("post","/entity/user_trust",params)
  end


  #
  # Add a verified source object to an existing entity.
  #
  #  @param entity_id
  #  @param public_source - Corresponds to entity_obj.attribution.name
  #  @param source_name - Corresponds to entity_obj.data_sources.type
  #  @param source_id - Corresponds to entity_obj.data_sources.external_id
  #  @param source_url - Corresponds to entity_obj.attribution.url
  #  @param source_logo - Corresponds to entity_obj.attribution.logo
  #  @param verified_date - Corresponds to entity_obj.data_sources.created_at
  #  @return - the data from the api
  #
  def POSTEntityVerified( entity_id, public_source, source_name, source_id, source_url, source_logo, verified_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['public_source'] = public_source
    params['source_name'] = source_name
    params['source_id'] = source_id
    params['source_url'] = source_url
    params['source_logo'] = source_logo
    params['verified_date'] = verified_date
    return doCurl("post","/entity/verified",params)
  end


  #
  # Remove a verified source object to an existing entity.
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def DELETEEntityVerified( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/verified",params)
  end


  #
  # With a known entity id, a video object can be added.
  #
  #  @param entity_id
  #  @param type
  #  @param link
  #  @return - the data from the api
  #
  def POSTEntityVideo( entity_id, type, link)
    params = Hash.new
    params['entity_id'] = entity_id
    params['type'] = type
    params['link'] = link
    return doCurl("post","/entity/video",params)
  end


  #
  # Allows a video object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityVideo( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/video",params)
  end


  #
  # With a known entity id, a YouTube video object can be added.
  #
  #  @param entity_id
  #  @param embed_code
  #  @return - the data from the api
  #
  def POSTEntityVideoYoutube( entity_id, embed_code)
    params = Hash.new
    params['entity_id'] = entity_id
    params['embed_code'] = embed_code
    return doCurl("post","/entity/video/youtube",params)
  end


  #
  # Allows a website object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @param force
  #  @return - the data from the api
  #
  def DELETEEntityWebsite( entity_id, gen_id, force)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['force'] = force
    return doCurl("delete","/entity/website",params)
  end


  #
  # With a known entity id, a website object can be added.
  #
  #  @param entity_id
  #  @param website_url
  #  @param display_url
  #  @param website_description
  #  @param gen_id
  #  @return - the data from the api
  #
  def POSTEntityWebsite( entity_id, website_url, display_url, website_description, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['website_url'] = website_url
    params['display_url'] = display_url
    params['website_description'] = website_description
    params['gen_id'] = gen_id
    return doCurl("post","/entity/website",params)
  end


  #
  # With a known entity id, a yext list can be added
  #
  #  @param entity_id
  #  @param yext_list_id
  #  @param description
  #  @param name
  #  @param type
  #  @return - the data from the api
  #
  def POSTEntityYext_list( entity_id, yext_list_id, description, name, type)
    params = Hash.new
    params['entity_id'] = entity_id
    params['yext_list_id'] = yext_list_id
    params['description'] = description
    params['name'] = name
    params['type'] = type
    return doCurl("post","/entity/yext_list",params)
  end


  #
  # Allows a yext list object to be removed
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEEntityYext_list( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/yext_list",params)
  end


  #
  # Add an entityserve document
  #
  #  @param entity_id - The ids of the entity/entities to create the entityserve event(s) for
  #  @param country - the ISO code of the country
  #  @param event_type - The event type being recorded
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def PUTEntityserve( entity_id, country, event_type, domain, path)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
    params['event_type'] = event_type
    params['domain'] = domain
    params['path'] = path
    return doCurl("put","/entityserve",params)
  end


  #
  # Update/Add a flatpack
  #
  #  @param flatpack_id - this record's unique, auto-generated id - if supplied, then this is an edit, otherwise it's an add
  #  @param status - The status of the flatpack, it is required on creation. Syndication link logic depends on this.
  #  @param nodefaults - create an flatpack that's empty apart from provided values (used for child flatpacks), IMPORTANT: if set, any parameters with default values will be ignored even if overridden. Edit the created flatpack to set those parameters on a nodefaults flatpack.
  #  @param domainName - the domain name to serve this flatpack site on (no leading http:// or anything please)
  #  @param inherits - inherit from domain
  #  @param stub - the stub that is appended to the flatpack's url e.g. http://dev.localhost/stub
  #  @param flatpackName - the name of the Flat pack instance
  #  @param less - the LESS configuration to use to overrides the Bootstrap CSS
  #  @param language - the language in which to render the flatpack site
  #  @param country - the country to use for searches etc
  #  @param mapsType - the type of maps to use
  #  @param mapKey - the nokia map key to use to render maps
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
  #  @param head - payload to put in the head of the flatpack
  #  @param adblock - payload to put in the adblock of the flatpack
  #  @param bodyTop - the payload to put in the top of the body of a flatpack
  #  @param bodyBottom - the payload to put in the bottom of the body of a flatpack
  #  @param header_menu - the JSON that describes a navigation at the top of the page
  #  @param header_menu_bottom - the JSON that describes a navigation below the masthead
  #  @param footer_menu - the JSON that describes a navigation at the bottom of the page
  #  @param bdpTitle - The page title of the entity business profile pages
  #  @param bdpDescription - The meta description of entity business profile pages
  #  @param bdpAds - The block of HTML/JS that renders Ads on BDPs
  #  @param serpTitle - The page title of the serps
  #  @param serpDescription - The meta description of serps
  #  @param serpNumberResults - The number of results per search page
  #  @param serpNumberAdverts - The number of adverts to show on the first search page
  #  @param serpAds - The block of HTML/JS that renders Ads on Serps
  #  @param serpAdsBottom - The block of HTML/JS that renders Ads on Serps at the bottom
  #  @param serpTitleNoWhat - The text to display in the title for where only searches
  #  @param serpDescriptionNoWhat - The text to display in the description for where only searches
  #  @param cookiePolicyUrl - The cookie policy url of the flatpack
  #  @param cookiePolicyNotice - Whether to show the cookie policy on this flatpack
  #  @param addBusinessButtonText - The text used in the 'Add your business' button
  #  @param twitterUrl - Twitter link
  #  @param facebookUrl - Facebook link
  #  @param copyright - Copyright message
  #  @param phoneReveal - record phone number reveal
  #  @param loginLinkText - the link text for the Login link
  #  @param contextLocationId - The location ID to use as the context for searches on this flatpack
  #  @param addBusinessButtonPosition - The location ID to use as the context for searches on this flatpack
  #  @param denyIndexing - Whether to noindex a flatpack
  #  @param contextRadius - allows you to set a catchment area around the contextLocationId in miles for use when displaying the activity stream module
  #  @param activityStream - allows you to set the activity to be displayed in the activity stream
  #  @param activityStreamSize - Sets the number of items to show within the activity stream.
  #  @param products - A Collection of Central Index products the flatpack is allowed to sell
  #  @param linkToRoot - The root domain name to serve this flatpack site on (no leading http:// or anything please)
  #  @param termsLink - A URL for t's and c's specific to this partner
  #  @param serpNumberEmbedAdverts - The number of embed adverts per search
  #  @param serpEmbedTitle - Custom page title for emdedded searches
  #  @param adminLess - the LESS configuration to use to overrides the Bootstrap CSS for the admin on themed domains
  #  @param adminConfNoLocz - operate without recourse to verified location data (locz)
  #  @param adminConfNoSocialLogin - suppress social media login interface
  #  @param adminConfEasyClaim - captcha only for claim
  #  @param adminConfPaymentMode - payment gateway
  #  @param adminConfEnableProducts - show upgrade on claim
  #  @param adminConfSimpleadmin - render a template for the reduced functionality
  #  @return - the data from the api
  #
  def POSTFlatpack( flatpack_id, status, nodefaults, domainName, inherits, stub, flatpackName, less, language, country, mapsType, mapKey, searchFormShowOn, searchFormShowKeywordsBox, searchFormShowLocationBox, searchFormKeywordsAutoComplete, searchFormLocationsAutoComplete, searchFormDefaultLocation, searchFormPlaceholderKeywords, searchFormPlaceholderLocation, searchFormKeywordsLabel, searchFormLocationLabel, cannedLinksHeader, homepageTitle, homepageDescription, homepageIntroTitle, homepageIntroText, head, adblock, bodyTop, bodyBottom, header_menu, header_menu_bottom, footer_menu, bdpTitle, bdpDescription, bdpAds, serpTitle, serpDescription, serpNumberResults, serpNumberAdverts, serpAds, serpAdsBottom, serpTitleNoWhat, serpDescriptionNoWhat, cookiePolicyUrl, cookiePolicyNotice, addBusinessButtonText, twitterUrl, facebookUrl, copyright, phoneReveal, loginLinkText, contextLocationId, addBusinessButtonPosition, denyIndexing, contextRadius, activityStream, activityStreamSize, products, linkToRoot, termsLink, serpNumberEmbedAdverts, serpEmbedTitle, adminLess, adminConfNoLocz, adminConfNoSocialLogin, adminConfEasyClaim, adminConfPaymentMode, adminConfEnableProducts, adminConfSimpleadmin)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['status'] = status
    params['nodefaults'] = nodefaults
    params['domainName'] = domainName
    params['inherits'] = inherits
    params['stub'] = stub
    params['flatpackName'] = flatpackName
    params['less'] = less
    params['language'] = language
    params['country'] = country
    params['mapsType'] = mapsType
    params['mapKey'] = mapKey
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
    params['head'] = head
    params['adblock'] = adblock
    params['bodyTop'] = bodyTop
    params['bodyBottom'] = bodyBottom
    params['header_menu'] = header_menu
    params['header_menu_bottom'] = header_menu_bottom
    params['footer_menu'] = footer_menu
    params['bdpTitle'] = bdpTitle
    params['bdpDescription'] = bdpDescription
    params['bdpAds'] = bdpAds
    params['serpTitle'] = serpTitle
    params['serpDescription'] = serpDescription
    params['serpNumberResults'] = serpNumberResults
    params['serpNumberAdverts'] = serpNumberAdverts
    params['serpAds'] = serpAds
    params['serpAdsBottom'] = serpAdsBottom
    params['serpTitleNoWhat'] = serpTitleNoWhat
    params['serpDescriptionNoWhat'] = serpDescriptionNoWhat
    params['cookiePolicyUrl'] = cookiePolicyUrl
    params['cookiePolicyNotice'] = cookiePolicyNotice
    params['addBusinessButtonText'] = addBusinessButtonText
    params['twitterUrl'] = twitterUrl
    params['facebookUrl'] = facebookUrl
    params['copyright'] = copyright
    params['phoneReveal'] = phoneReveal
    params['loginLinkText'] = loginLinkText
    params['contextLocationId'] = contextLocationId
    params['addBusinessButtonPosition'] = addBusinessButtonPosition
    params['denyIndexing'] = denyIndexing
    params['contextRadius'] = contextRadius
    params['activityStream'] = activityStream
    params['activityStreamSize'] = activityStreamSize
    params['products'] = products
    params['linkToRoot'] = linkToRoot
    params['termsLink'] = termsLink
    params['serpNumberEmbedAdverts'] = serpNumberEmbedAdverts
    params['serpEmbedTitle'] = serpEmbedTitle
    params['adminLess'] = adminLess
    params['adminConfNoLocz'] = adminConfNoLocz
    params['adminConfNoSocialLogin'] = adminConfNoSocialLogin
    params['adminConfEasyClaim'] = adminConfEasyClaim
    params['adminConfPaymentMode'] = adminConfPaymentMode
    params['adminConfEnableProducts'] = adminConfEnableProducts
    params['adminConfSimpleadmin'] = adminConfSimpleadmin
    return doCurl("post","/flatpack",params)
  end


  #
  # Get a flatpack
  #
  #  @param flatpack_id - the unique id to search for
  #  @return - the data from the api
  #
  def GETFlatpack( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/flatpack",params)
  end


  #
  # Remove a flatpack using a supplied flatpack_id
  #
  #  @param flatpack_id - the id of the flatpack to delete
  #  @return - the data from the api
  #
  def DELETEFlatpack( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("delete","/flatpack",params)
  end


  #
  # Upload a CSS file for the Admin for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackAdminCSS( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/adminCSS",params)
  end


  #
  # Add a HD Admin logo to a flatpack domain
  #
  #  @param flatpack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackAdminHDLogo( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/adminHDLogo",params)
  end


  #
  # Upload an image to serve out as the large logo in the Admin for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackAdminLargeLogo( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/adminLargeLogo",params)
  end


  #
  # Upload an image to serve out as the small logo in the Admin for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackAdminSmallLogo( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/adminSmallLogo",params)
  end


  #
  # Remove a flatpack using a supplied flatpack_id
  #
  #  @param flatpack_id - the unique id to search for
  #  @param adblock
  #  @param serpAds
  #  @param serpAdsBottom
  #  @param bdpAds
  #  @return - the data from the api
  #
  def DELETEFlatpackAds( flatpack_id, adblock, serpAds, serpAdsBottom, bdpAds)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['adblock'] = adblock
    params['serpAds'] = serpAds
    params['serpAdsBottom'] = serpAdsBottom
    params['bdpAds'] = bdpAds
    return doCurl("delete","/flatpack/ads",params)
  end


  #
  # Generate flatpacks based on the files passed in
  #
  #  @param json - The flatpack JSON to make replacements on
  #  @param filedata - a file that contains the replacements in the JSON
  #  @param slack_user
  #  @return - the data from the api
  #
  def POSTFlatpackBulkJson( json, filedata, slack_user)
    params = Hash.new
    params['json'] = json
    params['filedata'] = filedata
    params['slack_user'] = slack_user
    return doCurl("post","/flatpack/bulk/json",params)
  end


  #
  # Get flatpacks by country and location
  #
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @return - the data from the api
  #
  def GETFlatpackBy_country( country, latitude, longitude)
    params = Hash.new
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    return doCurl("get","/flatpack/by_country",params)
  end


  #
  # Get flatpacks by country in KML format
  #
  #  @param country
  #  @return - the data from the api
  #
  def GETFlatpackBy_countryKml( country)
    params = Hash.new
    params['country'] = country
    return doCurl("get","/flatpack/by_country/kml",params)
  end


  #
  # Get a flatpack using a domain name
  #
  #  @param domainName - the domain name to search for
  #  @param matchAlias - Whether to match alias as well
  #  @return - the data from the api
  #
  def GETFlatpackBy_domain_name( domainName, matchAlias)
    params = Hash.new
    params['domainName'] = domainName
    params['matchAlias'] = matchAlias
    return doCurl("get","/flatpack/by_domain_name",params)
  end


  #
  # Get flatpacks that match the supplied masheryid
  #
  #  @return - the data from the api
  #
  def GETFlatpackBy_masheryid()
    params = Hash.new
    return doCurl("get","/flatpack/by_masheryid",params)
  end


  #
  # Clone an existing flatpack
  #
  #  @param flatpack_id - the flatpack_id to clone
  #  @param domainName - the domain of the new flatpack site (no leading http:// or anything please)
  #  @return - the data from the api
  #
  def GETFlatpackClone( flatpack_id, domainName)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['domainName'] = domainName
    return doCurl("get","/flatpack/clone",params)
  end


  #
  # undefined
  #
  #  @param flatpack_id - the unique id to search for
  #  @param domainName
  #  @return - the data from the api
  #
  def POSTFlatpackDomain_alias( flatpack_id, domainName)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['domainName'] = domainName
    return doCurl("post","/flatpack/domain_alias",params)
  end


  #
  # undefined
  #
  #  @param flatpack_id - the unique id to search for
  #  @param domainName
  #  @return - the data from the api
  #
  def DELETEFlatpackDomain_alias( flatpack_id, domainName)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['domainName'] = domainName
    return doCurl("delete","/flatpack/domain_alias",params)
  end


  #
  # Returns a list of domain names in which direct/inherited flatpack country match the specified one and status equals production.
  #
  #  @param country
  #  @return - the data from the api
  #
  def GETFlatpackDomain_nameBy_country( country)
    params = Hash.new
    params['country'] = country
    return doCurl("get","/flatpack/domain_name/by_country",params)
  end


  #
  # Upload an icon to serve out with this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackIcon( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/icon",params)
  end


  #
  # Get a flatpack using a domain name
  #
  #  @param flatpack_id - the id to search for
  #  @return - the data from the api
  #
  def GETFlatpackInherit( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/flatpack/inherit",params)
  end


  #
  # returns the LESS theme from a flatpack
  #
  #  @param flatpack_id - the unique id to search for
  #  @return - the data from the api
  #
  def GETFlatpackLess( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/flatpack/less",params)
  end


  #
  # Remove a canned link to an existing flatpack site.
  #
  #  @param flatpack_id - the id of the flatpack to delete
  #  @param gen_id - the id of the canned link to remove
  #  @return - the data from the api
  #
  def DELETEFlatpackLink( flatpack_id, gen_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['gen_id'] = gen_id
    return doCurl("delete","/flatpack/link",params)
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
  def POSTFlatpackLink( flatpack_id, keywords, location, linkText)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['keywords'] = keywords
    params['location'] = location
    params['linkText'] = linkText
    return doCurl("post","/flatpack/link",params)
  end


  #
  # Remove all canned links from an existing flatpack.
  #
  #  @param flatpack_id - the id of the flatpack to remove links from
  #  @return - the data from the api
  #
  def DELETEFlatpackLinkAll( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("delete","/flatpack/link/all",params)
  end


  #
  # Upload a logo to serve out with this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackLogo( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/logo",params)
  end


  #
  # Add a hd logo to a flatpack domain
  #
  #  @param flatpack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackLogoHd( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/logo/hd",params)
  end


  #
  # Delete a Redirect link from a flatpack
  #
  #  @param flatpack_id - the unique id to search for
  #  @return - the data from the api
  #
  def DELETEFlatpackRedirect( flatpack_id)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    return doCurl("delete","/flatpack/redirect",params)
  end


  #
  # Add a Redirect link to a flatpack
  #
  #  @param flatpack_id - the unique id to search for
  #  @param redirectTo
  #  @return - the data from the api
  #
  def POSTFlatpackRedirect( flatpack_id, redirectTo)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['redirectTo'] = redirectTo
    return doCurl("post","/flatpack/redirect",params)
  end


  #
  # Upload a TXT file to act as the sitemap for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTFlatpackSitemap( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/sitemap",params)
  end


  #
  # Delete a group with a specified group_id
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def DELETEGroup( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("delete","/group",params)
  end


  #
  # Update/Add a Group
  #
  #  @param group_id
  #  @param name
  #  @param description
  #  @param url
  #  @param stamp_user_id
  #  @param stamp_sql
  #  @return - the data from the api
  #
  def POSTGroup( group_id, name, description, url, stamp_user_id, stamp_sql)
    params = Hash.new
    params['group_id'] = group_id
    params['name'] = name
    params['description'] = description
    params['url'] = url
    params['stamp_user_id'] = stamp_user_id
    params['stamp_sql'] = stamp_sql
    return doCurl("post","/group",params)
  end


  #
  # Returns group that matches a given group id
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def GETGroup( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("get","/group",params)
  end


  #
  # Returns all groups
  #
  #  @return - the data from the api
  #
  def GETGroupAll()
    params = Hash.new
    return doCurl("get","/group/all",params)
  end


  #
  # Bulk delete entities from a specified group
  #
  #  @param group_id
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTGroupBulk_delete( group_id, filedata)
    params = Hash.new
    params['group_id'] = group_id
    params['filedata'] = filedata
    return doCurl("post","/group/bulk_delete",params)
  end


  #
  # Bulk ingest entities into a specified group
  #
  #  @param group_id
  #  @param filedata
  #  @param category_type
  #  @return - the data from the api
  #
  def POSTGroupBulk_ingest( group_id, filedata, category_type)
    params = Hash.new
    params['group_id'] = group_id
    params['filedata'] = filedata
    params['category_type'] = category_type
    return doCurl("post","/group/bulk_ingest",params)
  end


  #
  # Bulk update entities with a specified group
  #
  #  @param group_id
  #  @param data
  #  @return - the data from the api
  #
  def POSTGroupBulk_update( group_id, data)
    params = Hash.new
    params['group_id'] = group_id
    params['data'] = data
    return doCurl("post","/group/bulk_update",params)
  end


  #
  # Get number of claims today
  #
  #  @param from_date
  #  @param to_date
  #  @param country_id
  #  @return - the data from the api
  #
  def GETHeartbeatBy_date( from_date, to_date, country_id)
    params = Hash.new
    params['from_date'] = from_date
    params['to_date'] = to_date
    params['country_id'] = country_id
    return doCurl("get","/heartbeat/by_date",params)
  end


  #
  # Get number of claims today
  #
  #  @param country
  #  @param claim_type
  #  @return - the data from the api
  #
  def GETHeartbeatTodayClaims( country, claim_type)
    params = Hash.new
    params['country'] = country
    params['claim_type'] = claim_type
    return doCurl("get","/heartbeat/today/claims",params)
  end


  #
  # Process a bulk file
  #
  #  @param job_id
  #  @param filedata - A tab separated file for ingest
  #  @return - the data from the api
  #
  def POSTIngest_file( job_id, filedata)
    params = Hash.new
    params['job_id'] = job_id
    params['filedata'] = filedata
    return doCurl("post","/ingest_file",params)
  end


  #
  # Add a ingest job to the collection
  #
  #  @param description
  #  @param category_type
  #  @return - the data from the api
  #
  def POSTIngest_job( description, category_type)
    params = Hash.new
    params['description'] = description
    params['category_type'] = category_type
    return doCurl("post","/ingest_job",params)
  end


  #
  # Get an ingest job from the collection
  #
  #  @param job_id
  #  @return - the data from the api
  #
  def GETIngest_job( job_id)
    params = Hash.new
    params['job_id'] = job_id
    return doCurl("get","/ingest_job",params)
  end


  #
  # Get an ingest log from the collection
  #
  #  @param job_id
  #  @param success
  #  @param errors
  #  @param limit
  #  @param skip
  #  @return - the data from the api
  #
  def GETIngest_logBy_job_id( job_id, success, errors, limit, skip)
    params = Hash.new
    params['job_id'] = job_id
    params['success'] = success
    params['errors'] = errors
    params['limit'] = limit
    params['skip'] = skip
    return doCurl("get","/ingest_log/by_job_id",params)
  end


  #
  # Check the status of the Ingest queue, and potentially flush it
  #
  #  @param flush
  #  @return - the data from the api
  #
  def GETIngest_queue( flush)
    params = Hash.new
    params['flush'] = flush
    return doCurl("get","/ingest_queue",params)
  end


  #
  # Returns entities that do not have claim or advertisers data
  #
  #  @param country_id - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param from_date
  #  @param to_date
  #  @param limit
  #  @param offset
  #  @param reduce - Set true to return the count value only.
  #  @return - the data from the api
  #
  def GETLeadsAdded( country_id, from_date, to_date, limit, offset, reduce)
    params = Hash.new
    params['country_id'] = country_id
    params['from_date'] = from_date
    params['to_date'] = to_date
    params['limit'] = limit
    params['offset'] = offset
    params['reduce'] = reduce
    return doCurl("get","/leads/added",params)
  end


  #
  # Returns entities that have advertisers data
  #
  #  @param country_id - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param from_date
  #  @param to_date
  #  @param limit
  #  @param offset
  #  @param reduce - Set true to return the count value only.
  #  @return - the data from the api
  #
  def GETLeadsAdvertisers( country_id, from_date, to_date, limit, offset, reduce)
    params = Hash.new
    params['country_id'] = country_id
    params['from_date'] = from_date
    params['to_date'] = to_date
    params['limit'] = limit
    params['offset'] = offset
    params['reduce'] = reduce
    return doCurl("get","/leads/advertisers",params)
  end


  #
  # Returns entities that have claim data
  #
  #  @param country_id - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param from_date
  #  @param to_date
  #  @param limit
  #  @param offset
  #  @param reduce - Set true to return the count value only.
  #  @return - the data from the api
  #
  def GETLeadsClaimed( country_id, from_date, to_date, limit, offset, reduce)
    params = Hash.new
    params['country_id'] = country_id
    params['from_date'] = from_date
    params['to_date'] = to_date
    params['limit'] = limit
    params['offset'] = offset
    params['reduce'] = reduce
    return doCurl("get","/leads/claimed",params)
  end


  #
  # Read a location with the supplied ID in the locations reference database.
  #
  #  @param location_id
  #  @return - the data from the api
  #
  def GETLocation( location_id)
    params = Hash.new
    params['location_id'] = location_id
    return doCurl("get","/location",params)
  end


  #
  # Create/update a new locz document with the supplied ID in the locations reference database.
  #
  #  @param location_id
  #  @param type
  #  @param country
  #  @param language
  #  @param name
  #  @param formal_name
  #  @param resolution
  #  @param population
  #  @param description
  #  @param timezone
  #  @param latitude
  #  @param longitude
  #  @param parent_town
  #  @param parent_county
  #  @param parent_province
  #  @param parent_region
  #  @param parent_neighbourhood
  #  @param parent_district
  #  @param postalcode
  #  @param searchable_id
  #  @param searchable_ids
  #  @return - the data from the api
  #
  def POSTLocation( location_id, type, country, language, name, formal_name, resolution, population, description, timezone, latitude, longitude, parent_town, parent_county, parent_province, parent_region, parent_neighbourhood, parent_district, postalcode, searchable_id, searchable_ids)
    params = Hash.new
    params['location_id'] = location_id
    params['type'] = type
    params['country'] = country
    params['language'] = language
    params['name'] = name
    params['formal_name'] = formal_name
    params['resolution'] = resolution
    params['population'] = population
    params['description'] = description
    params['timezone'] = timezone
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['parent_town'] = parent_town
    params['parent_county'] = parent_county
    params['parent_province'] = parent_province
    params['parent_region'] = parent_region
    params['parent_neighbourhood'] = parent_neighbourhood
    params['parent_district'] = parent_district
    params['postalcode'] = postalcode
    params['searchable_id'] = searchable_id
    params['searchable_ids'] = searchable_ids
    return doCurl("post","/location",params)
  end


  #
  # Given a location_id or a lat/lon, find other locations within the radius
  #
  #  @param location_id
  #  @param latitude
  #  @param longitude
  #  @param radius - Radius in km
  #  @param resolution
  #  @param country
  #  @param num_results
  #  @return - the data from the api
  #
  def GETLocationContext( location_id, latitude, longitude, radius, resolution, country, num_results)
    params = Hash.new
    params['location_id'] = location_id
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['radius'] = radius
    params['resolution'] = resolution
    params['country'] = country
    params['num_results'] = num_results
    return doCurl("get","/location/context",params)
  end


  #
  # Read multiple locations with the supplied ID in the locations reference database.
  #
  #  @param location_ids
  #  @return - the data from the api
  #
  def GETLocationMultiple( location_ids)
    params = Hash.new
    params['location_ids'] = location_ids
    return doCurl("get","/location/multiple",params)
  end


  #
  # With a unique login_id a login can be retrieved
  #
  #  @param login_id
  #  @return - the data from the api
  #
  def GETLogin( login_id)
    params = Hash.new
    params['login_id'] = login_id
    return doCurl("get","/login",params)
  end


  #
  # Create/Update login details
  #
  #  @param login_id
  #  @param email
  #  @param password
  #  @return - the data from the api
  #
  def POSTLogin( login_id, email, password)
    params = Hash.new
    params['login_id'] = login_id
    params['email'] = email
    params['password'] = password
    return doCurl("post","/login",params)
  end


  #
  # With a unique login_id a login can be deleted
  #
  #  @param login_id
  #  @return - the data from the api
  #
  def DELETELogin( login_id)
    params = Hash.new
    params['login_id'] = login_id
    return doCurl("delete","/login",params)
  end


  #
  # With a unique email address a login can be retrieved
  #
  #  @param email
  #  @return - the data from the api
  #
  def GETLoginBy_email( email)
    params = Hash.new
    params['email'] = email
    return doCurl("get","/login/by_email",params)
  end


  #
  # Verify that a supplied email and password match a users saved login details
  #
  #  @param email
  #  @param password
  #  @return - the data from the api
  #
  def GETLoginVerify( email, password)
    params = Hash.new
    params['email'] = email
    params['password'] = password
    return doCurl("get","/login/verify",params)
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
  def GETLogo( a, b, c, d)
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
  def PUTLogo( a)
    params = Hash.new
    params['a'] = a
    return doCurl("put","/logo",params)
  end


  #
  # Find a category from cache or cloudant depending if it is in the cache
  #
  #  @param string - A string to search against, E.g. Plumbers
  #  @param language - An ISO compatible language code, E.g. en
  #  @return - the data from the api
  #
  def GETLookupCategory( string, language)
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
  def GETLookupLegacyCategory( id, type)
    params = Hash.new
    params['id'] = id
    params['type'] = type
    return doCurl("get","/lookup/legacy/category",params)
  end


  #
  # Find a location from cache or cloudant depending if it is in the cache (locz)
  #
  #  @param string
  #  @param language
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @return - the data from the api
  #
  def GETLookupLocation( string, language, country, latitude, longitude)
    params = Hash.new
    params['string'] = string
    params['language'] = language
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    return doCurl("get","/lookup/location",params)
  end


  #
  # Returns a list of mashery IDs domain names in which direct/inherited flatpack country match the specified one and status equals production.
  #
  #  @return - the data from the api
  #
  def GETMasheryidAll()
    params = Hash.new
    return doCurl("get","/masheryid/all",params)
  end


  #
  # Find all matches by phone number, returning up to 10 matches
  #
  #  @param phone
  #  @param country
  #  @param exclude - Entity ID to exclude from the results
  #  @return - the data from the api
  #
  def GETMatchByphone( phone, country, exclude)
    params = Hash.new
    params['phone'] = phone
    params['country'] = country
    params['exclude'] = exclude
    return doCurl("get","/match/byphone",params)
  end


  #
  # Perform a match on the two supplied entities, returning the outcome and showing our working
  #
  #  @param primary_entity_id
  #  @param secondary_entity_id
  #  @param return_entities - Should we return the entity documents
  #  @return - the data from the api
  #
  def GETMatchOftheday( primary_entity_id, secondary_entity_id, return_entities)
    params = Hash.new
    params['primary_entity_id'] = primary_entity_id
    params['secondary_entity_id'] = secondary_entity_id
    params['return_entities'] = return_entities
    return doCurl("get","/match/oftheday",params)
  end


  #
  # Will create a new Matching Instruction or update an existing one
  #
  #  @param entity_id
  #  @param entity_name
  #  @return - the data from the api
  #
  def POSTMatching_instruction( entity_id, entity_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['entity_name'] = entity_name
    return doCurl("post","/matching_instruction",params)
  end


  #
  # Delete Matching instruction
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def DELETEMatching_instruction( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/matching_instruction",params)
  end


  #
  # Fetch all available Matching instructions
  #
  #  @param limit
  #  @return - the data from the api
  #
  def GETMatching_instructionAll( limit)
    params = Hash.new
    params['limit'] = limit
    return doCurl("get","/matching_instruction/all",params)
  end


  #
  # Create a matching log
  #
  #  @param primary_entity_id
  #  @param secondary_entity_id
  #  @param primary_name
  #  @param secondary_name
  #  @param address_score
  #  @param address_match
  #  @param name_score
  #  @param name_match
  #  @param distance
  #  @param phone_match
  #  @param category_match
  #  @param email_match
  #  @param website_match
  #  @param match
  #  @return - the data from the api
  #
  def PUTMatching_log( primary_entity_id, secondary_entity_id, primary_name, secondary_name, address_score, address_match, name_score, name_match, distance, phone_match, category_match, email_match, website_match, match)
    params = Hash.new
    params['primary_entity_id'] = primary_entity_id
    params['secondary_entity_id'] = secondary_entity_id
    params['primary_name'] = primary_name
    params['secondary_name'] = secondary_name
    params['address_score'] = address_score
    params['address_match'] = address_match
    params['name_score'] = name_score
    params['name_match'] = name_match
    params['distance'] = distance
    params['phone_match'] = phone_match
    params['category_match'] = category_match
    params['email_match'] = email_match
    params['website_match'] = website_match
    params['match'] = match
    return doCurl("put","/matching_log",params)
  end


  #
  # With a known user ID add/create the maxclaims blcok
  #
  #  @param user_id
  #  @param contract_id
  #  @param country
  #  @param number
  #  @param expiry_date
  #  @return - the data from the api
  #
  def POSTMaxclaimsActivate( user_id, contract_id, country, number, expiry_date)
    params = Hash.new
    params['user_id'] = user_id
    params['contract_id'] = contract_id
    params['country'] = country
    params['number'] = number
    params['expiry_date'] = expiry_date
    return doCurl("post","/maxclaims/activate",params)
  end


  #
  # Fetching a message
  #
  #  @param message_id - The message id to pull the message for
  #  @return - the data from the api
  #
  def GETMessage( message_id)
    params = Hash.new
    params['message_id'] = message_id
    return doCurl("get","/message",params)
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
  def POSTMessage( message_id, ses_id, from_user_id, from_email, to_entity_id, to_email, subject, body, bounced)
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
  # Fetching messages by ses_id
  #
  #  @param ses_id - The amazon id to pull the message for
  #  @return - the data from the api
  #
  def GETMessageBy_ses_id( ses_id)
    params = Hash.new
    params['ses_id'] = ses_id
    return doCurl("get","/message/by_ses_id",params)
  end


  #
  # Update/Add a multipack
  #
  #  @param multipack_id - this record's unique, auto-generated id - if supplied, then this is an edit, otherwise it's an add
  #  @param group_id - the id of the group that this site serves
  #  @param domainName - the domain name to serve this multipack site on (no leading http:// or anything please)
  #  @param multipackName - the name of the Flat pack instance
  #  @param less - the LESS configuration to use to overrides the Bootstrap CSS
  #  @param country - the country to use for searches etc
  #  @param menuTop - the JSON that describes a navigation at the top of the page
  #  @param menuBottom - the JSON that describes a navigation below the masthead
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @param menuFooter - the JSON that describes a navigation at the bottom of the page
  #  @param searchNumberResults - the number of search results per page
  #  @param searchTitle - Title of serps page
  #  @param searchDescription - Description of serps page
  #  @param searchTitleNoWhere - Title when no where is specified
  #  @param searchDescriptionNoWhere - Description of serps page when no where is specified
  #  @param searchIntroHeader - Introductory header
  #  @param searchIntroText - Introductory text
  #  @param searchShowAll - display all search results on one page
  #  @param searchUnitOfDistance - the unit of distance to use for search
  #  @param cookiePolicyShow - whether to show cookie policy
  #  @param cookiePolicyUrl - url of cookie policy
  #  @param twitterUrl - url of twitter feed
  #  @param facebookUrl - url of facebook feed
  #  @return - the data from the api
  #
  def POSTMultipack( multipack_id, group_id, domainName, multipackName, less, country, menuTop, menuBottom, language, menuFooter, searchNumberResults, searchTitle, searchDescription, searchTitleNoWhere, searchDescriptionNoWhere, searchIntroHeader, searchIntroText, searchShowAll, searchUnitOfDistance, cookiePolicyShow, cookiePolicyUrl, twitterUrl, facebookUrl)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['group_id'] = group_id
    params['domainName'] = domainName
    params['multipackName'] = multipackName
    params['less'] = less
    params['country'] = country
    params['menuTop'] = menuTop
    params['menuBottom'] = menuBottom
    params['language'] = language
    params['menuFooter'] = menuFooter
    params['searchNumberResults'] = searchNumberResults
    params['searchTitle'] = searchTitle
    params['searchDescription'] = searchDescription
    params['searchTitleNoWhere'] = searchTitleNoWhere
    params['searchDescriptionNoWhere'] = searchDescriptionNoWhere
    params['searchIntroHeader'] = searchIntroHeader
    params['searchIntroText'] = searchIntroText
    params['searchShowAll'] = searchShowAll
    params['searchUnitOfDistance'] = searchUnitOfDistance
    params['cookiePolicyShow'] = cookiePolicyShow
    params['cookiePolicyUrl'] = cookiePolicyUrl
    params['twitterUrl'] = twitterUrl
    params['facebookUrl'] = facebookUrl
    return doCurl("post","/multipack",params)
  end


  #
  # Get a multipack
  #
  #  @param multipack_id - the unique id to search for
  #  @return - the data from the api
  #
  def GETMultipack( multipack_id)
    params = Hash.new
    params['multipack_id'] = multipack_id
    return doCurl("get","/multipack",params)
  end


  #
  # Add an admin theme to a multipack
  #
  #  @param multipack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTMultipackAdminCSS( multipack_id, filedata)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['filedata'] = filedata
    return doCurl("post","/multipack/adminCSS",params)
  end


  #
  # Add a Admin logo to a Multipack domain
  #
  #  @param multipack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTMultipackAdminLogo( multipack_id, filedata)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['filedata'] = filedata
    return doCurl("post","/multipack/adminLogo",params)
  end


  #
  # Get a multipack using a domain name
  #
  #  @param domainName - the domain name to search for
  #  @return - the data from the api
  #
  def GETMultipackBy_domain_name( domainName)
    params = Hash.new
    params['domainName'] = domainName
    return doCurl("get","/multipack/by_domain_name",params)
  end


  #
  # duplicates a given multipack
  #
  #  @param multipack_id - the unique id to search for
  #  @param domainName - the domain name to serve this multipack site on (no leading http:// or anything please)
  #  @param group_id - the group to use for search
  #  @return - the data from the api
  #
  def GETMultipackClone( multipack_id, domainName, group_id)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['domainName'] = domainName
    params['group_id'] = group_id
    return doCurl("get","/multipack/clone",params)
  end


  #
  # returns the LESS theme from a multipack
  #
  #  @param multipack_id - the unique id to search for
  #  @return - the data from the api
  #
  def GETMultipackLess( multipack_id)
    params = Hash.new
    params['multipack_id'] = multipack_id
    return doCurl("get","/multipack/less",params)
  end


  #
  # Add a logo to a multipack domain
  #
  #  @param multipack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTMultipackLogo( multipack_id, filedata)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['filedata'] = filedata
    return doCurl("post","/multipack/logo",params)
  end


  #
  # Add a map pin to a multipack domain
  #
  #  @param multipack_id - the unique id to search for
  #  @param filedata
  #  @param mapPinOffsetX
  #  @param mapPinOffsetY
  #  @return - the data from the api
  #
  def POSTMultipackMap_pin( multipack_id, filedata, mapPinOffsetX, mapPinOffsetY)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['filedata'] = filedata
    params['mapPinOffsetX'] = mapPinOffsetX
    params['mapPinOffsetY'] = mapPinOffsetY
    return doCurl("post","/multipack/map_pin",params)
  end


  #
  # Fetch an ops_log
  #
  #  @param ops_log_id
  #  @return - the data from the api
  #
  def GETOps_log( ops_log_id)
    params = Hash.new
    params['ops_log_id'] = ops_log_id
    return doCurl("get","/ops_log",params)
  end


  #
  # Create an ops_log
  #
  #  @param success
  #  @param type
  #  @param action
  #  @param data
  #  @param slack_channel
  #  @return - the data from the api
  #
  def POSTOps_log( success, type, action, data, slack_channel)
    params = Hash.new
    params['success'] = success
    params['type'] = type
    params['action'] = action
    params['data'] = data
    params['slack_channel'] = slack_channel
    return doCurl("post","/ops_log",params)
  end


  #
  # Run PTB for a given ingest job ID.
  #
  #  @param ingest_job_id - The ingest job ID
  #  @param email - When all entity IDs are pushed to the PTB queue, an email containing debug info will be sent.
  #  @return - the data from the api
  #
  def POSTPaintBy_ingest_job_id( ingest_job_id, email)
    params = Hash.new
    params['ingest_job_id'] = ingest_job_id
    params['email'] = email
    return doCurl("post","/paint/by_ingest_job_id",params)
  end


  #
  # With a known entity id syndication of data back to a partner is enabled
  #
  #  @param entity_id
  #  @param publisher_id
  #  @param expiry_date
  #  @return - the data from the api
  #
  def POSTPartnersyndicateActivate( entity_id, publisher_id, expiry_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['expiry_date'] = expiry_date
    return doCurl("post","/partnersyndicate/activate",params)
  end


  #
  # Call CK syndication instruction and call cancel endpoint for partner/supplier_id
  #
  #  @param supplierid
  #  @param vendor
  #  @return - the data from the api
  #
  def POSTPartnersyndicateCancel( supplierid, vendor)
    params = Hash.new
    params['supplierid'] = supplierid
    params['vendor'] = vendor
    return doCurl("post","/partnersyndicate/cancel",params)
  end


  #
  # This will call into CK in order to create the entity on the third party system.
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def POSTPartnersyndicateCreate( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("post","/partnersyndicate/create",params)
  end


  #
  # If this call fails CK is nudged for a human intervention for the future (so the call is NOT passive)
  #
  #  @param vendor_cat_id
  #  @param vendor_cat_string
  #  @param vendor
  #  @return - the data from the api
  #
  def GETPartnersyndicateRequestcat( vendor_cat_id, vendor_cat_string, vendor)
    params = Hash.new
    params['vendor_cat_id'] = vendor_cat_id
    params['vendor_cat_string'] = vendor_cat_string
    params['vendor'] = vendor
    return doCurl("get","/partnersyndicate/requestcat",params)
  end


  #
  # This will do nothing if the entity does not have a current partnersyndicate block. Syndication is invoked automatically when entities are saved, so this endpoint is designed for checking the status of syndication.
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def POSTPartnersyndicateUpdateToCk( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("post","/partnersyndicate/updateToCk",params)
  end


  #
  # When a plugin is added to the system it must be added to the service
  #
  #  @param id
  #  @param slug
  #  @param owner
  #  @param scope
  #  @param status
  #  @param params
  #  @return - the data from the api
  #
  def POSTPlugin( id, slug, owner, scope, status, params)
    params = Hash.new
    params['id'] = id
    params['slug'] = slug
    params['owner'] = owner
    params['scope'] = scope
    params['status'] = status
    params['params'] = params
    return doCurl("post","/plugin",params)
  end


  #
  # Get plugin data
  #
  #  @param id
  #  @return - the data from the api
  #
  def GETPlugin( id)
    params = Hash.new
    params['id'] = id
    return doCurl("get","/plugin",params)
  end


  #
  # With a known entity id, a plugin is enabled
  #
  #  @param entity_id
  #  @param plugin
  #  @param inapp_name
  #  @param expiry_date
  #  @return - the data from the api
  #
  def POSTPluginActivate( entity_id, plugin, inapp_name, expiry_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['plugin'] = plugin
    params['inapp_name'] = inapp_name
    params['expiry_date'] = expiry_date
    return doCurl("post","/plugin/activate",params)
  end


  #
  # With a known entity id, a plugin is cancelled
  #
  #  @param entity_id
  #  @param plugin
  #  @param inapp_name
  #  @param expiry_date
  #  @return - the data from the api
  #
  def POSTPluginCancel( entity_id, plugin, inapp_name, expiry_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['plugin'] = plugin
    params['inapp_name'] = inapp_name
    params['expiry_date'] = expiry_date
    return doCurl("post","/plugin/cancel",params)
  end


  #
  # Arbitrary big data
  #
  #  @param pluginid
  #  @param name
  #  @param filter1
  #  @param filter2
  #  @param order
  #  @param fields - a json string with up to 20 fields indexed 'field1' thru 'field20'
  #  @return - the data from the api
  #
  def GETPluginDatarow( pluginid, name, filter1, filter2, order, fields)
    params = Hash.new
    params['pluginid'] = pluginid
    params['name'] = name
    params['filter1'] = filter1
    params['filter2'] = filter2
    params['order'] = order
    params['fields'] = fields
    return doCurl("get","/plugin/datarow",params)
  end


  #
  # Arbitrary big data
  #
  #  @param rowdataid
  #  @param pluginid
  #  @param name
  #  @param filter1
  #  @param filter2
  #  @param fields - a json string with up to 20 fields indexed 'field1' thru 'field20'
  #  @return - the data from the api
  #
  def POSTPluginDatarow( rowdataid, pluginid, name, filter1, filter2, fields)
    params = Hash.new
    params['rowdataid'] = rowdataid
    params['pluginid'] = pluginid
    params['name'] = name
    params['filter1'] = filter1
    params['filter2'] = filter2
    params['fields'] = fields
    return doCurl("post","/plugin/datarow",params)
  end


  #
  # With a known entity id, a plugin is enabled
  #
  #  @param pluginid
  #  @param userid
  #  @param entity_id
  #  @param storekey
  #  @param storeval
  #  @return - the data from the api
  #
  def POSTPluginVar( pluginid, userid, entity_id, storekey, storeval)
    params = Hash.new
    params['pluginid'] = pluginid
    params['userid'] = userid
    params['entity_id'] = entity_id
    params['storekey'] = storekey
    params['storeval'] = storeval
    return doCurl("post","/plugin/var",params)
  end


  #
  # Get variables related to a particular entity
  #
  #  @param entityid
  #  @return - the data from the api
  #
  def GETPluginVarsByEntityId( entityid)
    params = Hash.new
    params['entityid'] = entityid
    return doCurl("get","/plugin/vars/byEntityId",params)
  end


  #
  # Get info on all plugins
  #
  #  @return - the data from the api
  #
  def GETPlugins()
    params = Hash.new
    return doCurl("get","/plugins",params)
  end


  #
  # Allows a private object to be removed
  #
  #  @param private_object_id - The id of the private object to remove
  #  @return - the data from the api
  #
  def DELETEPrivate_object( private_object_id)
    params = Hash.new
    params['private_object_id'] = private_object_id
    return doCurl("delete","/private_object",params)
  end


  #
  # With a known entity id, a private object can be added.
  #
  #  @param entity_id - The entity to associate the private object with
  #  @param data - The data to store
  #  @return - the data from the api
  #
  def PUTPrivate_object( entity_id, data)
    params = Hash.new
    params['entity_id'] = entity_id
    params['data'] = data
    return doCurl("put","/private_object",params)
  end


  #
  # Allows a private object to be returned based on the entity_id and masheryid
  #
  #  @param entity_id - The entity associated with the private object
  #  @return - the data from the api
  #
  def GETPrivate_objectAll( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/private_object/all",params)
  end


  #
  # Update/Add a product
  #
  #  @param product_id - The ID of the product
  #  @param shortname - Desc
  #  @param name - The name of the product
  #  @param strapline - The description of the product
  #  @param alternate_title - The alternate title of the product
  #  @param fpzones - Hints for flatpack display (set a single hint 'void' to have this ignored)
  #  @param paygateid - The product id in the payment gateway (required for Stripe)
  #  @param price - The price of the product
  #  @param tax_rate - The tax markup for this product
  #  @param currency - The currency in which the price is in
  #  @param active - is this an active product
  #  @param billing_period
  #  @param title - Title of the product
  #  @param intro_paragraph - introduction paragraph
  #  @param bullets - pipe separated product features
  #  @param outro_paragraph - closing paragraph
  #  @param product_description_html - Overriding product description html blob
  #  @param thankyou_html - overriding thank you paragraph html
  #  @param thanks_paragraph - thank you paragraph
  #  @param video_url - video url
  #  @return - the data from the api
  #
  def POSTProduct( product_id, shortname, name, strapline, alternate_title, fpzones, paygateid, price, tax_rate, currency, active, billing_period, title, intro_paragraph, bullets, outro_paragraph, product_description_html, thankyou_html, thanks_paragraph, video_url)
    params = Hash.new
    params['product_id'] = product_id
    params['shortname'] = shortname
    params['name'] = name
    params['strapline'] = strapline
    params['alternate_title'] = alternate_title
    params['fpzones'] = fpzones
    params['paygateid'] = paygateid
    params['price'] = price
    params['tax_rate'] = tax_rate
    params['currency'] = currency
    params['active'] = active
    params['billing_period'] = billing_period
    params['title'] = title
    params['intro_paragraph'] = intro_paragraph
    params['bullets'] = bullets
    params['outro_paragraph'] = outro_paragraph
    params['product_description_html'] = product_description_html
    params['thankyou_html'] = thankyou_html
    params['thanks_paragraph'] = thanks_paragraph
    params['video_url'] = video_url
    return doCurl("post","/product",params)
  end


  #
  # Returns the product information given a valid product_id
  #
  #  @param product_id
  #  @return - the data from the api
  #
  def GETProduct( product_id)
    params = Hash.new
    params['product_id'] = product_id
    return doCurl("get","/product",params)
  end


  #
  # Uploads logo image to product
  #
  #  @param product_id
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTProductImageLogo( product_id, filedata)
    params = Hash.new
    params['product_id'] = product_id
    params['filedata'] = filedata
    return doCurl("post","/product/image/logo",params)
  end


  #
  # Delete the logo image within a specific product
  #
  #  @param product_id
  #  @return - the data from the api
  #
  def DELETEProductImageLogo( product_id)
    params = Hash.new
    params['product_id'] = product_id
    return doCurl("delete","/product/image/logo",params)
  end


  #
  # Delete the main image within a specific product
  #
  #  @param product_id
  #  @return - the data from the api
  #
  def DELETEProductImageMain( product_id)
    params = Hash.new
    params['product_id'] = product_id
    return doCurl("delete","/product/image/main",params)
  end


  #
  # Adds partblahnersyndicate provisioning object to a product
  #
  #  @param product_id
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTProductImageMain( product_id, filedata)
    params = Hash.new
    params['product_id'] = product_id
    params['filedata'] = filedata
    return doCurl("post","/product/image/main",params)
  end


  #
  # Delete the small image within a specific product
  #
  #  @param product_id
  #  @return - the data from the api
  #
  def DELETEProductImageSmall( product_id)
    params = Hash.new
    params['product_id'] = product_id
    return doCurl("delete","/product/image/small",params)
  end


  #
  # Uploads small image to product
  #
  #  @param product_id
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTProductImageSmall( product_id, filedata)
    params = Hash.new
    params['product_id'] = product_id
    params['filedata'] = filedata
    return doCurl("post","/product/image/small",params)
  end


  #
  # Removes a provisioning object from product
  #
  #  @param product_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def DELETEProductProvisioning( product_id, gen_id)
    params = Hash.new
    params['product_id'] = product_id
    params['gen_id'] = gen_id
    return doCurl("delete","/product/provisioning",params)
  end


  #
  # Adds advertising provisioning object to a product
  #
  #  @param product_id
  #  @param publisher_id
  #  @param max_tags
  #  @param max_locations
  #  @return - the data from the api
  #
  def POSTProductProvisioningAdvert( product_id, publisher_id, max_tags, max_locations)
    params = Hash.new
    params['product_id'] = product_id
    params['publisher_id'] = publisher_id
    params['max_tags'] = max_tags
    params['max_locations'] = max_locations
    return doCurl("post","/product/provisioning/advert",params)
  end


  #
  # Adds claim provisioning object to a product
  #
  #  @param product_id
  #  @param package
  #  @return - the data from the api
  #
  def POSTProductProvisioningClaim( product_id, package)
    params = Hash.new
    params['product_id'] = product_id
    params['package'] = package
    return doCurl("post","/product/provisioning/claim",params)
  end


  #
  # Adds maxclaims provisioning object to a product
  #
  #  @param product_id
  #  @param country
  #  @param number
  #  @return - the data from the api
  #
  def POSTProductProvisioningMaxclaims( product_id, country, number)
    params = Hash.new
    params['product_id'] = product_id
    params['country'] = country
    params['number'] = number
    return doCurl("post","/product/provisioning/maxclaims",params)
  end


  #
  # Adds partnersyndicate provisioning object to a product
  #
  #  @param product_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTProductProvisioningPartnersyndicate( product_id, publisher_id)
    params = Hash.new
    params['product_id'] = product_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/product/provisioning/partnersyndicate",params)
  end


  #
  # Adds plugin provisioning object to a product
  #
  #  @param product_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTProductProvisioningPlugin( product_id, publisher_id)
    params = Hash.new
    params['product_id'] = product_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/product/provisioning/plugin",params)
  end


  #
  # Adds SCheduleSMS provisioning object to a product
  #
  #  @param product_id
  #  @param package
  #  @return - the data from the api
  #
  def POSTProductProvisioningSchedulesms( product_id, package)
    params = Hash.new
    params['product_id'] = product_id
    params['package'] = package
    return doCurl("post","/product/provisioning/schedulesms",params)
  end


  #
  # Adds syndication provisioning object to a product
  #
  #  @param product_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def POSTProductProvisioningSyndication( product_id, publisher_id)
    params = Hash.new
    params['product_id'] = product_id
    params['publisher_id'] = publisher_id
    return doCurl("post","/product/provisioning/syndication",params)
  end


  #
  # Perform the whole PTB process on the supplied entity
  #
  #  @param entity_id
  #  @param destructive
  #  @return - the data from the api
  #
  def GETPtbAll( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/ptb/all",params)
  end


  #
  # Report on what happened to specific entity_id
  #
  #  @param year - the year to examine
  #  @param month - the month to examine
  #  @param entity_id - the entity to research
  #  @return - the data from the api
  #
  def GETPtbLog( year, month, entity_id)
    params = Hash.new
    params['year'] = year
    params['month'] = month
    params['entity_id'] = entity_id
    return doCurl("get","/ptb/log",params)
  end


  #
  # Process an entity with a specific PTB module
  #
  #  @param entity_id
  #  @param module
  #  @param destructive
  #  @return - the data from the api
  #
  def GETPtbModule( entity_id, __module, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['module'] = __module
    params['destructive'] = destructive
    return doCurl("get","/ptb/module",params)
  end


  #
  # Report on the run-rate of the Paint the Bridge System
  #
  #  @param country - the country to get the runrate for
  #  @param year - the year to examine
  #  @param month - the month to examine
  #  @param day - the day to examine
  #  @return - the data from the api
  #
  def GETPtbRunrate( country, year, month, day)
    params = Hash.new
    params['country'] = country
    params['year'] = year
    params['month'] = month
    params['day'] = day
    return doCurl("get","/ptb/runrate",params)
  end


  #
  # Report on the value being added by Paint The Bridge
  #
  #  @param country - the country to get the runrate for
  #  @param year - the year to examine
  #  @param month - the month to examine
  #  @param day - the day to examine
  #  @return - the data from the api
  #
  def GETPtbValueadded( country, year, month, day)
    params = Hash.new
    params['country'] = country
    params['year'] = year
    params['month'] = month
    params['day'] = day
    return doCurl("get","/ptb/valueadded",params)
  end


  #
  # Returns publisher that matches a given publisher id
  #
  #  @param publisher_id
  #  @return - the data from the api
  #
  def GETPublisher( publisher_id)
    params = Hash.new
    params['publisher_id'] = publisher_id
    return doCurl("get","/publisher",params)
  end


  #
  # Update/Add a publisher
  #
  #  @param publisher_id
  #  @param country
  #  @param name
  #  @param description
  #  @param active
  #  @param url_patterns
  #  @param premium_adverts_platinum
  #  @param premium_adverts_gold
  #  @return - the data from the api
  #
  def POSTPublisher( publisher_id, country, name, description, active, url_patterns, premium_adverts_platinum, premium_adverts_gold)
    params = Hash.new
    params['publisher_id'] = publisher_id
    params['country'] = country
    params['name'] = name
    params['description'] = description
    params['active'] = active
    params['url_patterns'] = url_patterns
    params['premium_adverts_platinum'] = premium_adverts_platinum
    params['premium_adverts_gold'] = premium_adverts_gold
    return doCurl("post","/publisher",params)
  end


  #
  # Delete a publisher with a specified publisher_id
  #
  #  @param publisher_id
  #  @return - the data from the api
  #
  def DELETEPublisher( publisher_id)
    params = Hash.new
    params['publisher_id'] = publisher_id
    return doCurl("delete","/publisher",params)
  end


  #
  # Returns publisher that matches a given publisher id
  #
  #  @param country
  #  @return - the data from the api
  #
  def GETPublisherByCountry( country)
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
  def GETPublisherByEntityId( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/publisher/byEntityId",params)
  end


  #
  # Returns a publisher that has the specified masheryid
  #
  #  @param publisher_masheryid
  #  @return - the data from the api
  #
  def GETPublisherBy_masheryid( publisher_masheryid)
    params = Hash.new
    params['publisher_masheryid'] = publisher_masheryid
    return doCurl("get","/publisher/by_masheryid",params)
  end


  #
  # Retrieve queue items.
  #
  #  @param limit
  #  @param queue_name
  #  @return - the data from the api
  #
  def GETQueue( limit, queue_name)
    params = Hash.new
    params['limit'] = limit
    params['queue_name'] = queue_name
    return doCurl("get","/queue",params)
  end


  #
  # Create a queue item
  #
  #  @param queue_name
  #  @param data
  #  @return - the data from the api
  #
  def PUTQueue( queue_name, data)
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
  def DELETEQueue( queue_id)
    params = Hash.new
    params['queue_id'] = queue_id
    return doCurl("delete","/queue",params)
  end


  #
  # Find a queue item by its cloudant id
  #
  #  @param queue_id
  #  @return - the data from the api
  #
  def GETQueueBy_id( queue_id)
    params = Hash.new
    params['queue_id'] = queue_id
    return doCurl("get","/queue/by_id",params)
  end


  #
  # Add an error to a queue item
  #
  #  @param queue_id
  #  @param error
  #  @return - the data from the api
  #
  def POSTQueueError( queue_id, error)
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
  def GETQueueSearch( type, id)
    params = Hash.new
    params['type'] = type
    params['id'] = id
    return doCurl("get","/queue/search",params)
  end


  #
  # Unlock queue items.
  #
  #  @param queue_name
  #  @param seconds
  #  @return - the data from the api
  #
  def POSTQueueUnlock( queue_name, seconds)
    params = Hash.new
    params['queue_name'] = queue_name
    params['seconds'] = seconds
    return doCurl("post","/queue/unlock",params)
  end


  #
  # Create an SQS queue item
  #
  #  @param queue_name
  #  @param data
  #  @return - the data from the api
  #
  def PUTQueue_sqs( queue_name, data)
    params = Hash.new
    params['queue_name'] = queue_name
    params['data'] = data
    return doCurl("put","/queue_sqs",params)
  end


  #
  # Get the attributes of an SQS queue
  #
  #  @param queue_name
  #  @return - the data from the api
  #
  def GETQueue_sqsAttributes( queue_name)
    params = Hash.new
    params['queue_name'] = queue_name
    return doCurl("get","/queue_sqs/attributes",params)
  end


  #
  # Returns reseller that matches a given reseller id
  #
  #  @param reseller_id
  #  @return - the data from the api
  #
  def GETReseller( reseller_id)
    params = Hash.new
    params['reseller_id'] = reseller_id
    return doCurl("get","/reseller",params)
  end


  #
  # Update/Add a reseller
  #
  #  @param reseller_id
  #  @param country
  #  @param name
  #  @param description
  #  @param active
  #  @param products
  #  @param master_user_id
  #  @param canViewEmployee
  #  @return - the data from the api
  #
  def POSTReseller( reseller_id, country, name, description, active, products, master_user_id, canViewEmployee)
    params = Hash.new
    params['reseller_id'] = reseller_id
    params['country'] = country
    params['name'] = name
    params['description'] = description
    params['active'] = active
    params['products'] = products
    params['master_user_id'] = master_user_id
    params['canViewEmployee'] = canViewEmployee
    return doCurl("post","/reseller",params)
  end


  #
  # Return a sales log by id
  #
  #  @param sales_log_id - The sales log id to pull
  #  @return - the data from the api
  #
  def GETSales_log( sales_log_id)
    params = Hash.new
    params['sales_log_id'] = sales_log_id
    return doCurl("get","/sales_log",params)
  end


  #
  # Return a sales log by id
  #
  #  @param from_date
  #  @param country
  #  @param action_type
  #  @return - the data from the api
  #
  def GETSales_logBy_countryBy_date( from_date, country, action_type)
    params = Hash.new
    params['from_date'] = from_date
    params['country'] = country
    params['action_type'] = action_type
    return doCurl("get","/sales_log/by_country/by_date",params)
  end


  #
  # Return a sales log by date range, filtered by masheryid if it is given
  #
  #  @param from_date
  #  @param to_date
  #  @param group
  #  @param limit - Applicable only when group=false
  #  @param skip - Applicable only when group=false
  #  @return - the data from the api
  #
  def GETSales_logBy_date( from_date, to_date, group, limit, skip)
    params = Hash.new
    params['from_date'] = from_date
    params['to_date'] = to_date
    params['group'] = group
    params['limit'] = limit
    params['skip'] = skip
    return doCurl("get","/sales_log/by_date",params)
  end


  #
  # Log a sale
  #
  #  @param entity_id - The entity the sale was made against
  #  @param country - The country code the sales log orginated
  #  @param action_type - The type of action we are performing
  #  @param ad_type - The type of advertisements
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
  def POSTSales_logEntity( entity_id, country, action_type, ad_type, publisher_id, mashery_id, reseller_ref, reseller_agent_id, max_tags, max_locations, extra_tags, extra_locations, expiry_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
    params['action_type'] = action_type
    params['ad_type'] = ad_type
    params['publisher_id'] = publisher_id
    params['mashery_id'] = mashery_id
    params['reseller_ref'] = reseller_ref
    params['reseller_agent_id'] = reseller_agent_id
    params['max_tags'] = max_tags
    params['max_locations'] = max_locations
    params['extra_tags'] = extra_tags
    params['extra_locations'] = extra_locations
    params['expiry_date'] = expiry_date
    return doCurl("post","/sales_log/entity",params)
  end


  #
  # Add a Sales Log document for a syndication action
  #
  #  @param action_type
  #  @param syndication_type
  #  @param publisher_id
  #  @param expiry_date
  #  @param entity_id
  #  @param group_id
  #  @param seed_masheryid
  #  @param supplier_masheryid
  #  @param country
  #  @param reseller_masheryid
  #  @return - the data from the api
  #
  def POSTSales_logSyndication( action_type, syndication_type, publisher_id, expiry_date, entity_id, group_id, seed_masheryid, supplier_masheryid, country, reseller_masheryid)
    params = Hash.new
    params['action_type'] = action_type
    params['syndication_type'] = syndication_type
    params['publisher_id'] = publisher_id
    params['expiry_date'] = expiry_date
    params['entity_id'] = entity_id
    params['group_id'] = group_id
    params['seed_masheryid'] = seed_masheryid
    params['supplier_masheryid'] = supplier_masheryid
    params['country'] = country
    params['reseller_masheryid'] = reseller_masheryid
    return doCurl("post","/sales_log/syndication",params)
  end


  #
  # Converts an Entity into a submission at the Scoot Partner API
  #
  #  @param entity_id - The entity to parse
  #  @param reseller - The reseller Mashery ID, it also determines which Scoot API key to use
  #  @param scoot_id - If specified, the related Scoot listing will be updated.
  #  @param autofill_scoot_id - If scoot_id is not given, look for past successful syndication logs to fill in the Scoot ID
  #  @return - the data from the api
  #
  def POSTScoot_priority( entity_id, reseller, scoot_id, autofill_scoot_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['reseller'] = reseller
    params['scoot_id'] = scoot_id
    params['autofill_scoot_id'] = autofill_scoot_id
    return doCurl("post","/scoot_priority",params)
  end


  #
  # Make a url shorter
  #
  #  @param url - the url to shorten
  #  @param idOnly - Return just the Shortened URL ID
  #  @return - the data from the api
  #
  def PUTShortenurl( url, idOnly)
    params = Hash.new
    params['url'] = url
    params['idOnly'] = idOnly
    return doCurl("put","/shortenurl",params)
  end


  #
  # get the long url from the db
  #
  #  @param id - the id to fetch from the db
  #  @return - the data from the api
  #
  def GETShortenurl( id)
    params = Hash.new
    params['id'] = id
    return doCurl("get","/shortenurl",params)
  end


  #
  # For insance, reporting a phone number as wrong
  #
  #  @param entity_id - A valid entity_id e.g. 379236608286720
  #  @param country - The country code from where the signal originated e.g. ie
  #  @param gen_id - The gen_id for the item being reported
  #  @param signal_type - The signal that is to be reported e.g. wrong
  #  @param data_type - The type of data being reported
  #  @param inactive_reason - The reason for making the entity inactive
  #  @param inactive_description - A description to accompany the inactive reasoning
  #  @param feedback - Some feedback from the person submitting the signal
  #  @return - the data from the api
  #
  def POSTSignal( entity_id, country, gen_id, signal_type, data_type, inactive_reason, inactive_description, feedback)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
    params['gen_id'] = gen_id
    params['signal_type'] = signal_type
    params['data_type'] = data_type
    params['inactive_reason'] = inactive_reason
    params['inactive_description'] = inactive_description
    params['feedback'] = feedback
    return doCurl("post","/signal",params)
  end


  #
  # With a given country and entity id suffix, this endpoint will return a list of entity IDs and their last modified dates for sitemap generation.
  #
  #  @param country - Target country code.
  #  @param id_suffix - Target entity Id suffix (4 digits).
  #  @param skip
  #  @param limit
  #  @return - the data from the api
  #
  def GETSitemapEntity( country, id_suffix, skip, limit)
    params = Hash.new
    params['country'] = country
    params['id_suffix'] = id_suffix
    params['skip'] = skip
    params['limit'] = limit
    return doCurl("get","/sitemap/entity",params)
  end


  #
  # With a given country, this endpoint will return a list of entity ID suffixes which have records.
  #
  #  @param country - Target country code.
  #  @return - the data from the api
  #
  def GETSitemapEntitySummary( country)
    params = Hash.new
    params['country'] = country
    return doCurl("get","/sitemap/entity/summary",params)
  end


  #
  # Get a spider document
  #
  #  @param spider_id
  #  @return - the data from the api
  #
  def GETSpider( spider_id)
    params = Hash.new
    params['spider_id'] = spider_id
    return doCurl("get","/spider",params)
  end


  #
  # Get the number of times an entity has been served out as an advert or on serps/bdp pages
  #
  #  @param entity_id - A valid entity_id e.g. 379236608286720
  #  @param year - The year to report on
  #  @param month - The month to report on
  #  @return - the data from the api
  #
  def GETStatsEntityBy_date( entity_id, year, month)
    params = Hash.new
    params['entity_id'] = entity_id
    params['year'] = year
    params['month'] = month
    return doCurl("get","/stats/entity/by_date",params)
  end


  #
  # Get the stats on an entity in a given year
  #
  #  @param entity_id - A valid entity_id e.g. 379236608286720
  #  @param year - The year to report on
  #  @return - the data from the api
  #
  def GETStatsEntityBy_year( entity_id, year)
    params = Hash.new
    params['entity_id'] = entity_id
    params['year'] = year
    return doCurl("get","/stats/entity/by_year",params)
  end


  #
  # Confirms that the API is active, and returns the current version number
  #
  #  @return - the data from the api
  #
  def GETStatus()
    params = Hash.new
    return doCurl("get","/status",params)
  end


  #
  # get a Syndication
  #
  #  @param syndication_id
  #  @return - the data from the api
  #
  def GETSyndication( syndication_id)
    params = Hash.new
    params['syndication_id'] = syndication_id
    return doCurl("get","/syndication",params)
  end


  #
  # get a Syndication by entity_id
  #
  #  @param entity_id
  #  @return - the data from the api
  #
  def GETSyndicationBy_entity_id( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/syndication/by_entity_id",params)
  end


  #
  # Get a Syndication by Reseller (Mashery ID) and optional entity ID
  #
  #  @param reseller_masheryid
  #  @param entity_id
  #  @return - the data from the api
  #
  def GETSyndicationBy_reseller( reseller_masheryid, entity_id)
    params = Hash.new
    params['reseller_masheryid'] = reseller_masheryid
    params['entity_id'] = entity_id
    return doCurl("get","/syndication/by_reseller",params)
  end


  #
  # Cancel a syndication
  #
  #  @param syndication_id
  #  @return - the data from the api
  #
  def POSTSyndicationCancel( syndication_id)
    params = Hash.new
    params['syndication_id'] = syndication_id
    return doCurl("post","/syndication/cancel",params)
  end


  #
  # Add a Syndicate
  #
  #  @param syndication_type
  #  @param publisher_id
  #  @param expiry_date
  #  @param entity_id
  #  @param group_id
  #  @param seed_masheryid
  #  @param supplier_masheryid
  #  @param country
  #  @param data_filter
  #  @return - the data from the api
  #
  def POSTSyndicationCreate( syndication_type, publisher_id, expiry_date, entity_id, group_id, seed_masheryid, supplier_masheryid, country, data_filter)
    params = Hash.new
    params['syndication_type'] = syndication_type
    params['publisher_id'] = publisher_id
    params['expiry_date'] = expiry_date
    params['entity_id'] = entity_id
    params['group_id'] = group_id
    params['seed_masheryid'] = seed_masheryid
    params['supplier_masheryid'] = supplier_masheryid
    params['country'] = country
    params['data_filter'] = data_filter
    return doCurl("post","/syndication/create",params)
  end


  #
  # Renew a Syndicate
  #
  #  @param syndication_type
  #  @param publisher_id
  #  @param entity_id
  #  @param group_id
  #  @param seed_masheryid
  #  @param supplier_masheryid
  #  @param country
  #  @param expiry_date
  #  @return - the data from the api
  #
  def POSTSyndicationRenew( syndication_type, publisher_id, entity_id, group_id, seed_masheryid, supplier_masheryid, country, expiry_date)
    params = Hash.new
    params['syndication_type'] = syndication_type
    params['publisher_id'] = publisher_id
    params['entity_id'] = entity_id
    params['group_id'] = group_id
    params['seed_masheryid'] = seed_masheryid
    params['supplier_masheryid'] = supplier_masheryid
    params['country'] = country
    params['expiry_date'] = expiry_date
    return doCurl("post","/syndication/renew",params)
  end


  #
  # When we get a syndication update make a record of it
  #
  #  @param entity_id - The entity to pull
  #  @param publisher_id - The publisher this log entry refers to
  #  @param action - The log type
  #  @param success - If the syndication was successful
  #  @param message - An optional message e.g. submitted to the syndication partner
  #  @param syndicated_id - The entity as known to the publisher
  #  @param reseller_id - The optional reseller id used in the syndications
  #  @return - the data from the api
  #
  def POSTSyndication_log( entity_id, publisher_id, action, success, message, syndicated_id, reseller_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['action'] = action
    params['success'] = success
    params['message'] = message
    params['syndicated_id'] = syndicated_id
    params['reseller_id'] = reseller_id
    return doCurl("post","/syndication_log",params)
  end


  #
  # Get all syndication log entries for a given entity id
  #
  #  @param entity_id
  #  @param page
  #  @param per_page
  #  @return - the data from the api
  #
  def GETSyndication_logBy_entity_id( entity_id, page, per_page)
    params = Hash.new
    params['entity_id'] = entity_id
    params['page'] = page
    params['per_page'] = per_page
    return doCurl("get","/syndication_log/by_entity_id",params)
  end


  #
  # Get the latest syndication log feedback entry for a given entity id and publisher
  #
  #  @param entity_id
  #  @param publisher_id
  #  @return - the data from the api
  #
  def GETSyndication_logLast_syndicated_id( entity_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    return doCurl("get","/syndication_log/last_syndicated_id",params)
  end


  #
  # Creates a new Syndication Submission
  #
  #  @param syndication_type
  #  @param entity_id
  #  @param publisher_id
  #  @param submission_id
  #  @return - the data from the api
  #
  def PUTSyndication_submission( syndication_type, entity_id, publisher_id, submission_id)
    params = Hash.new
    params['syndication_type'] = syndication_type
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['submission_id'] = submission_id
    return doCurl("put","/syndication_submission",params)
  end


  #
  # Returns a Syndication Submission
  #
  #  @param syndication_submission_id
  #  @return - the data from the api
  #
  def GETSyndication_submission( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("get","/syndication_submission",params)
  end


  #
  # Set active to false for a Syndication Submission
  #
  #  @param syndication_submission_id
  #  @return - the data from the api
  #
  def POSTSyndication_submissionDeactivate( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("post","/syndication_submission/deactivate",params)
  end


  #
  # Set the processed date to now for a Syndication Submission
  #
  #  @param syndication_submission_id
  #  @return - the data from the api
  #
  def POSTSyndication_submissionProcessed( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("post","/syndication_submission/processed",params)
  end


  #
  # Provides a tokenised URL to redirect a user so they can add an entity to Central Index
  #
  #  @param language - The language to use to render the add path e.g. en
  #  @param business_name - The name of the business (to be presented as a default) e.g. The Dog and Duck
  #  @param business_phone - The phone number of the business (to be presented as a default) e.g. 20 8480-2777
  #  @param business_postcode - The postcode of the business (to be presented as a default) e.g. EC1 1AA
  #  @param portal_name - The name of the website that data is to be added on e.g. YourLocal
  #  @param supplier_id - The supplier id e.g. 1234xxx889
  #  @param partner - syndication partner (eg 192)
  #  @param country - The country of the entity to be added e.g. gb
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def GETTokenAdd( language, business_name, business_phone, business_postcode, portal_name, supplier_id, partner, country, flatpack_id)
    params = Hash.new
    params['language'] = language
    params['business_name'] = business_name
    params['business_phone'] = business_phone
    params['business_postcode'] = business_postcode
    params['portal_name'] = portal_name
    params['supplier_id'] = supplier_id
    params['partner'] = partner
    params['country'] = country
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/add",params)
  end


  #
  # Provides a tokenised URL to redirect a user to claim an entity on Central Index
  #
  #  @param entity_id - Entity ID to be claimed e.g. 380348266819584
  #  @param supplier_id - Supplier ID to be added (along with masheryid) e.g. 380348266819584
  #  @param language - The language to use to render the claim path e.g. en
  #  @param portal_name - The name of the website that entity is being claimed on e.g. YourLocal
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param admin_host - The admin host to refer back to - will only be respected if whitelisted in configuration
  #  @return - the data from the api
  #
  def GETTokenClaim( entity_id, supplier_id, language, portal_name, flatpack_id, admin_host)
    params = Hash.new
    params['entity_id'] = entity_id
    params['supplier_id'] = supplier_id
    params['language'] = language
    params['portal_name'] = portal_name
    params['flatpack_id'] = flatpack_id
    params['admin_host'] = admin_host
    return doCurl("get","/token/claim",params)
  end


  #
  # Fetch token for the contact us method
  #
  #  @param portal_name - The portal name
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param language - en, es, etc...
  #  @param referring_url - the url where the request came from
  #  @return - the data from the api
  #
  def GETTokenContact_us( portal_name, flatpack_id, language, referring_url)
    params = Hash.new
    params['portal_name'] = portal_name
    params['flatpack_id'] = flatpack_id
    params['language'] = language
    params['referring_url'] = referring_url
    return doCurl("get","/token/contact_us",params)
  end


  #
  # Allows us to identify the user, entity and element from an encoded endpoint URL's token
  #
  #  @param token
  #  @return - the data from the api
  #
  def GETTokenDecode( token)
    params = Hash.new
    params['token'] = token
    return doCurl("get","/token/decode",params)
  end


  #
  # Fetch token for edit path
  #
  #  @param entity_id - The id of the entity being upgraded
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param edit_page - the page in the edit path that the user should land on
  #  @return - the data from the api
  #
  def GETTokenEdit( entity_id, language, flatpack_id, edit_page)
    params = Hash.new
    params['entity_id'] = entity_id
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    params['edit_page'] = edit_page
    return doCurl("get","/token/edit",params)
  end


  #
  # Fetch token for some admin page.
  #
  #  @param portal_name - The name of the application that has initiated the login process, example: 'Your Local'
  #  @param code - Secret string which will be validated by the target page.
  #  @param expireAt - When this token expires in UNIX timestamp. The target page should validate this.
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param multipack_id - The id of the multipack site where the request originated
  #  @param data - Optional extra data to be passed to the targeted page.
  #  @return - the data from the api
  #
  def GETTokenEncode( portal_name, code, expireAt, language, flatpack_id, multipack_id, data)
    params = Hash.new
    params['portal_name'] = portal_name
    params['code'] = code
    params['expireAt'] = expireAt
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    params['multipack_id'] = multipack_id
    params['data'] = data
    return doCurl("get","/token/encode",params)
  end


  #
  # Fetch token for login path
  #
  #  @param portal_name - The name of the application that has initiated the login process, example: 'Your Local'
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param multipack_id - The id of the multipack site where the request originated
  #  @return - the data from the api
  #
  def GETTokenLogin( portal_name, language, flatpack_id, multipack_id)
    params = Hash.new
    params['portal_name'] = portal_name
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    params['multipack_id'] = multipack_id
    return doCurl("get","/token/login",params)
  end


  #
  # Get a tokenised url for an password reset
  #
  #  @param login_id - Login id
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param entity_id
  #  @param action
  #  @return - the data from the api
  #
  def GETTokenLoginReset_password( login_id, flatpack_id, entity_id, action)
    params = Hash.new
    params['login_id'] = login_id
    params['flatpack_id'] = flatpack_id
    params['entity_id'] = entity_id
    params['action'] = action
    return doCurl("get","/token/login/reset_password",params)
  end


  #
  # Get a tokenised url for an email verification
  #
  #  @param email - Email address
  #  @param first_name - First name of the new user
  #  @param last_name - Last name of the new user
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param entity_id
  #  @param action
  #  @return - the data from the api
  #
  def GETTokenLoginSet_password( email, first_name, last_name, flatpack_id, entity_id, action)
    params = Hash.new
    params['email'] = email
    params['first_name'] = first_name
    params['last_name'] = last_name
    params['flatpack_id'] = flatpack_id
    params['entity_id'] = entity_id
    params['action'] = action
    return doCurl("get","/token/login/set_password",params)
  end


  #
  # Fetch token for messaging path
  #
  #  @param entity_id - The id of the entity being messaged
  #  @param portal_name - The name of the application that has initiated the email process, example: 'Your Local'
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def GETTokenMessage( entity_id, portal_name, language, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/message",params)
  end


  #
  # Fetch token for partnerclaim path
  #
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param partner - The partner (eg 192)
  #  @param partnerid - the supplier id from the partner site
  #  @param preclaimed - is this already claimed on the partner site (used for messaging)
  #  @return - the data from the api
  #
  def GETTokenPartnerclaim( language, flatpack_id, partner, partnerid, preclaimed)
    params = Hash.new
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    params['partner'] = partner
    params['partnerid'] = partnerid
    params['preclaimed'] = preclaimed
    return doCurl("get","/token/partnerclaim",params)
  end


  #
  # Fetch token for partnerclaim path (ie we start at a CI entity id rather than an external partner id)
  #
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param partner - The partner (eg 192)
  #  @param entityid - the CI entity id
  #  @param preclaimed - is this already claimed on the partner site (used for messaging)
  #  @return - the data from the api
  #
  def GETTokenPartnerclaimInternal( language, flatpack_id, partner, entityid, preclaimed)
    params = Hash.new
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    params['partner'] = partner
    params['entityid'] = entityid
    params['preclaimed'] = preclaimed
    return doCurl("get","/token/partnerclaim/internal",params)
  end


  #
  # Fetch token for product path
  #
  #  @param entity_id - The id of the entity to add a product to
  #  @param product_id - The product id of the product
  #  @param language - The language for the app
  #  @param portal_name - The portal name
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param source - email, social media etc
  #  @param channel - 
  #  @param campaign - the campaign identifier
  #  @return - the data from the api
  #
  def GETTokenProduct( entity_id, product_id, language, portal_name, flatpack_id, source, channel, campaign)
    params = Hash.new
    params['entity_id'] = entity_id
    params['product_id'] = product_id
    params['language'] = language
    params['portal_name'] = portal_name
    params['flatpack_id'] = flatpack_id
    params['source'] = source
    params['channel'] = channel
    params['campaign'] = campaign
    return doCurl("get","/token/product",params)
  end


  #
  # Fetch token for product path
  #
  #  @param entity_id - The id of the entity to add a product to
  #  @param portal_name - The portal name
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param language - en, es, etc...
  #  @return - the data from the api
  #
  def GETTokenProduct_selector( entity_id, portal_name, flatpack_id, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['flatpack_id'] = flatpack_id
    params['language'] = language
    return doCurl("get","/token/product_selector",params)
  end


  #
  # Provides a tokenised URL that allows a user to report incorrect entity information
  #
  #  @param entity_id - The unique Entity ID e.g. 379236608286720
  #  @param portal_name - The name of the portal that the user is coming from e.g. YourLocal
  #  @param language - The language to use to render the report path
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def GETTokenReport( entity_id, portal_name, language, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/report",params)
  end


  #
  # Get a tokenised url for the review path
  #
  #  @param portal_name - The portal name
  #  @param entity_id
  #  @param language - en, es, etc...
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def GETTokenReview( portal_name, entity_id, language, flatpack_id)
    params = Hash.new
    params['portal_name'] = portal_name
    params['entity_id'] = entity_id
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/review",params)
  end


  #
  # Get a tokenised url for the testimonial path
  #
  #  @param portal_name - The portal name
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @param language - en, es, etc...
  #  @param entity_id
  #  @param shorten_url
  #  @return - the data from the api
  #
  def GETTokenTestimonial( portal_name, flatpack_id, language, entity_id, shorten_url)
    params = Hash.new
    params['portal_name'] = portal_name
    params['flatpack_id'] = flatpack_id
    params['language'] = language
    params['entity_id'] = entity_id
    params['shorten_url'] = shorten_url
    return doCurl("get","/token/testimonial",params)
  end


  #
  # The JaroWinklerDistance between two entities postal address objects
  #
  #  @param first_entity_id - The entity id of the first entity to be used in the postal address difference
  #  @param second_entity_id - The entity id of the second entity to be used in the postal address difference
  #  @return - the data from the api
  #
  def GETToolsAddressdiff( first_entity_id, second_entity_id)
    params = Hash.new
    params['first_entity_id'] = first_entity_id
    params['second_entity_id'] = second_entity_id
    return doCurl("get","/tools/addressdiff",params)
  end


  #
  # An API call to test crashing the server
  #
  #  @return - the data from the api
  #
  def GETToolsCrash()
    params = Hash.new
    return doCurl("get","/tools/crash",params)
  end


  #
  # Provide a method, a path and some data to run a load of curl commands and get emailed when complete
  #
  #  @param method - The method e.g. POST
  #  @param path - The relative api call e.g. /entity/phone
  #  @param filedata - A tab separated file for ingest
  #  @param email - Response email address e.g. dave@fender.com
  #  @return - the data from the api
  #
  def POSTToolsCurl( method, path, filedata, email)
    params = Hash.new
    params['method'] = method
    params['path'] = path
    params['filedata'] = filedata
    params['email'] = email
    return doCurl("post","/tools/curl",params)
  end


  #
  # Use this call to get information (in HTML or JSON) about the data structure of given entity object (e.g. a phone number or an address)
  #
  #  @param object - The API call documentation is required for
  #  @param format - The format of the returned data eg. JSON or HTML
  #  @return - the data from the api
  #
  def GETToolsDocs( object, format)
    params = Hash.new
    params['object'] = object
    params['format'] = format
    return doCurl("get","/tools/docs",params)
  end


  #
  # Format an address according to the rules of the country supplied
  #
  #  @param address - The address to format
  #  @param country - The country where the address is based
  #  @return - the data from the api
  #
  def GETToolsFormatAddress( address, country)
    params = Hash.new
    params['address'] = address
    params['country'] = country
    return doCurl("get","/tools/format/address",params)
  end


  #
  # Format a phone number according to the rules of the country supplied
  #
  #  @param number - The telephone number to format
  #  @param country - The country where the telephone number is based
  #  @param ignoreRegionCheck - If ture, we only check if the phone number is valid, ignoring country context
  #  @return - the data from the api
  #
  def GETToolsFormatPhone( number, country, ignoreRegionCheck)
    params = Hash.new
    params['number'] = number
    params['country'] = country
    params['ignoreRegionCheck'] = ignoreRegionCheck
    return doCurl("get","/tools/format/phone",params)
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
  #  @param province
  #  @param postcode
  #  @param country
  #  @return - the data from the api
  #
  def GETToolsGeocode( building_number, address1, address2, address3, district, town, county, province, postcode, country)
    params = Hash.new
    params['building_number'] = building_number
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['province'] = province
    params['postcode'] = postcode
    params['country'] = country
    return doCurl("get","/tools/geocode",params)
  end


  #
  # Given a spreadsheet ID, and a worksheet ID, add a row
  #
  #  @param spreadsheet_key - The key of the spreadsheet to edit
  #  @param worksheet_key - The key of the worksheet to edit - failure to provide this will assume worksheet with the label 'Sheet1'
  #  @param data - A comma separated list to add as cells
  #  @return - the data from the api
  #
  def POSTToolsGooglesheetAdd_row( spreadsheet_key, worksheet_key, data)
    params = Hash.new
    params['spreadsheet_key'] = spreadsheet_key
    params['worksheet_key'] = worksheet_key
    params['data'] = data
    return doCurl("post","/tools/googlesheet/add_row",params)
  end


  #
  # Given a spreadsheet ID and the name of a worksheet identify the Google ID for the worksheet
  #
  #  @param spreadsheet_key - The key of the spreadsheet
  #  @param worksheet_name - The name/label of the worksheet to identify
  #  @return - the data from the api
  #
  def POSTToolsGooglesheetWorksheet_id( spreadsheet_key, worksheet_name)
    params = Hash.new
    params['spreadsheet_key'] = spreadsheet_key
    params['worksheet_name'] = worksheet_name
    return doCurl("post","/tools/googlesheet/worksheet_id",params)
  end


  #
  # Given some image data we can resize and upload the images
  #
  #  @param filedata - The image data to upload and resize
  #  @param type - The type of image to upload and resize
  #  @param image_dir - Set the destination directory of the generated images on S3. Only available when Image API is enabled.
  #  @return - the data from the api
  #
  def POSTToolsImage( filedata, type, image_dir)
    params = Hash.new
    params['filedata'] = filedata
    params['type'] = type
    params['image_dir'] = image_dir
    return doCurl("post","/tools/image",params)
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
  def GETToolsIodocs( mode, path, endpoint, doctype)
    params = Hash.new
    params['mode'] = mode
    params['path'] = path
    params['endpoint'] = endpoint
    params['doctype'] = doctype
    return doCurl("get","/tools/iodocs",params)
  end


  #
  # compile the supplied less with the standard Bootstrap less into a CSS file
  #
  #  @param less - The LESS code to compile
  #  @return - the data from the api
  #
  def GETToolsLess( less)
    params = Hash.new
    params['less'] = less
    return doCurl("get","/tools/less",params)
  end


  #
  # Parse unstructured address data to fit our structured address objects
  #
  #  @param address
  #  @param postcode
  #  @param country
  #  @param normalise
  #  @return - the data from the api
  #
  def GETToolsParseAddress( address, postcode, country, normalise)
    params = Hash.new
    params['address'] = address
    params['postcode'] = postcode
    params['country'] = country
    params['normalise'] = normalise
    return doCurl("get","/tools/parse/address",params)
  end


  #
  # Ring the person and verify their account
  #
  #  @param to - The phone number to verify
  #  @param from - The phone number to call from
  #  @param pin - The pin to verify the phone number with
  #  @param twilio_voice - The language to read the verification in
  #  @param extension - The pin to verify the phone number with
  #  @return - the data from the api
  #
  def GETToolsPhonecallVerify( to, from, pin, twilio_voice, extension)
    params = Hash.new
    params['to'] = to
    params['from'] = from
    params['pin'] = pin
    params['twilio_voice'] = twilio_voice
    params['extension'] = extension
    return doCurl("get","/tools/phonecall/verify",params)
  end


  #
  # Return the phonetic representation of a string
  #
  #  @param text
  #  @return - the data from the api
  #
  def GETToolsPhonetic( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/phonetic",params)
  end


  #
  # Attempt to process a phone number, removing anything which is not a digit
  #
  #  @param number
  #  @return - the data from the api
  #
  def GETToolsProcess_phone( number)
    params = Hash.new
    params['number'] = number
    return doCurl("get","/tools/process_phone",params)
  end


  #
  # Fully process a string. This includes removing punctuation, stops words and stemming a string. Also returns the phonetic representation of this string.
  #
  #  @param text
  #  @return - the data from the api
  #
  def GETToolsProcess_string( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/process_string",params)
  end


  #
  # Force refresh of search indexes
  #
  #  @return - the data from the api
  #
  def GETToolsReindex()
    params = Hash.new
    return doCurl("get","/tools/reindex",params)
  end


  #
  # Check to see if a supplied email address is valid
  #
  #  @param from - The phone number from which the SMS orginates
  #  @param to - The phone number to which the SMS is to be sent
  #  @param message - The message to be sent in the SMS
  #  @return - the data from the api
  #
  def GETToolsSendsms( from, to, message)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['message'] = message
    return doCurl("get","/tools/sendsms",params)
  end


  #
  # Spider a single url looking for key facts
  #
  #  @param url
  #  @param pages
  #  @param country
  #  @param save
  #  @return - the data from the api
  #
  def GETToolsSpider( url, pages, country, save)
    params = Hash.new
    params['url'] = url
    params['pages'] = pages
    params['country'] = country
    params['save'] = save
    return doCurl("get","/tools/spider",params)
  end


  #
  # Returns a stemmed version of a string
  #
  #  @param text
  #  @return - the data from the api
  #
  def GETToolsStem( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/stem",params)
  end


  #
  # Removes stopwords from a string
  #
  #  @param text
  #  @return - the data from the api
  #
  def GETToolsStopwords( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/stopwords",params)
  end


  #
  # Fetch the result of submitted data we sent to InfoGroup
  #
  #  @param syndication_submission_id - The syndication_submission_id to fetch info for
  #  @return - the data from the api
  #
  def GETToolsSubmissionInfogroup( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("get","/tools/submission/infogroup",params)
  end


  #
  # Fetch the entity and convert it to 118 Places CSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicate118( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/118",params)
  end


  #
  # Fetch the entity and convert it to Bing Ads CSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateBingads( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/bingads",params)
  end


  #
  # Fetch the entity and convert it to Bing Places CSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateBingplaces( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/bingplaces",params)
  end


  #
  # Fetch the entity and convert it to DnB TSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateDnb( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/dnb",params)
  end


  #
  # Fetch the entity and convert add it to arlington
  #
  #  @param entity_id - The entity_id to fetch
  #  @param reseller_masheryid - The reseller_masheryid
  #  @param destructive - Add the entity or simulate adding the entity
  #  @param data_filter - The level of filtering to apply to the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateEnablemedia( entity_id, reseller_masheryid, destructive, data_filter)
    params = Hash.new
    params['entity_id'] = entity_id
    params['reseller_masheryid'] = reseller_masheryid
    params['destructive'] = destructive
    params['data_filter'] = data_filter
    return doCurl("get","/tools/syndicate/enablemedia",params)
  end


  #
  # Fetch the entity and convert add it to Factual
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateFactual( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/factual",params)
  end


  #
  # Fetch the entity and convert it to Factual CSV / TSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateFactualcsv( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/factualcsv",params)
  end


  #
  # Syndicate an entity to Foursquare
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateFoursquare( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/foursquare",params)
  end


  #
  # Fetch the entity and convert it to TomTom XML format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateGoogle( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/google",params)
  end


  #
  # Fetch the entity and convert it to Infobel CSV / TSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateInfobelcsv( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/infobelcsv",params)
  end


  #
  # Fetch the entity and convert add it to InfoGroup
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateInfogroup( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/infogroup",params)
  end


  #
  # Fetch the entity and convert add it to Judy's Book
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateJudysbook( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/judysbook",params)
  end


  #
  # Fetch the entity and convert it to Google KML format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateKml( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/kml",params)
  end


  #
  # Syndicate database to localdatabase.com
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateLocaldatabase( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/localdatabase",params)
  end


  #
  # Fetch the entity and convert it to Nokia NBS CSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateNokia( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/nokia",params)
  end


  #
  # Post an entity to OpenStreetMap
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateOsm( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/osm",params)
  end


  #
  # Syndicate an entity to ThomsonLocal
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateThomsonlocal( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/thomsonlocal",params)
  end


  #
  # Fetch the entity and convert it to TomTom XML format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateTomtom( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/tomtom",params)
  end


  #
  # Fetch the entity and convert it to YALWA csv
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def GETToolsSyndicateYalwa( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/yalwa",params)
  end


  #
  # Fetch the entity and convert add it to Yassaaaabeeee!!
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def GETToolsSyndicateYasabe( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/yasabe",params)
  end


  #
  # Test to see whether this supplied data would already match an entity
  #
  #  @param name
  #  @param building_number
  #  @param branch_name
  #  @param address1
  #  @param address2
  #  @param address3
  #  @param district
  #  @param town
  #  @param county
  #  @param province
  #  @param postcode
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @param timezone
  #  @param telephone_number
  #  @param additional_telephone_number
  #  @param email
  #  @param website
  #  @param category_id
  #  @param category_type
  #  @param do_not_display
  #  @param referrer_url
  #  @param referrer_name
  #  @return - the data from the api
  #
  def GETToolsTestmatch( name, building_number, branch_name, address1, address2, address3, district, town, county, province, postcode, country, latitude, longitude, timezone, telephone_number, additional_telephone_number, email, website, category_id, category_type, do_not_display, referrer_url, referrer_name)
    params = Hash.new
    params['name'] = name
    params['building_number'] = building_number
    params['branch_name'] = branch_name
    params['address1'] = address1
    params['address2'] = address2
    params['address3'] = address3
    params['district'] = district
    params['town'] = town
    params['county'] = county
    params['province'] = province
    params['postcode'] = postcode
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['timezone'] = timezone
    params['telephone_number'] = telephone_number
    params['additional_telephone_number'] = additional_telephone_number
    params['email'] = email
    params['website'] = website
    params['category_id'] = category_id
    params['category_type'] = category_type
    params['do_not_display'] = do_not_display
    params['referrer_url'] = referrer_url
    params['referrer_name'] = referrer_name
    return doCurl("get","/tools/testmatch",params)
  end


  #
  # Send a transactional email via Adestra or other email provider
  #
  #  @param email_id - The ID of the email to send
  #  @param destination_email - The email address to send to
  #  @param email_supplier - The email supplier
  #  @return - the data from the api
  #
  def GETToolsTransactional_email( email_id, destination_email, email_supplier)
    params = Hash.new
    params['email_id'] = email_id
    params['destination_email'] = destination_email
    params['email_supplier'] = email_supplier
    return doCurl("get","/tools/transactional_email",params)
  end


  #
  # Upload a file to our asset server and return the url
  #
  #  @param filedata
  #  @return - the data from the api
  #
  def POSTToolsUpload( filedata)
    params = Hash.new
    params['filedata'] = filedata
    return doCurl("post","/tools/upload",params)
  end


  #
  # Find a canonical URL from a supplied URL
  #
  #  @param url - The url to process
  #  @param max_redirects - The maximum number of reirects
  #  @return - the data from the api
  #
  def GETToolsUrl_details( url, max_redirects)
    params = Hash.new
    params['url'] = url
    params['max_redirects'] = max_redirects
    return doCurl("get","/tools/url_details",params)
  end


  #
  # Check to see if a supplied email address is valid
  #
  #  @param email_address - The email address to validate
  #  @return - the data from the api
  #
  def GETToolsValidate_email( email_address)
    params = Hash.new
    params['email_address'] = email_address
    return doCurl("get","/tools/validate_email",params)
  end


  #
  # Calls a number to make sure it is active
  #
  #  @param phone_number - The phone number to validate
  #  @param country - The country code of the phone number to be validated
  #  @return - the data from the api
  #
  def GETToolsValidate_phone( phone_number, country)
    params = Hash.new
    params['phone_number'] = phone_number
    params['country'] = country
    return doCurl("get","/tools/validate_phone",params)
  end


  #
  # Deleting a traction
  #
  #  @param traction_id
  #  @return - the data from the api
  #
  def DELETETraction( traction_id)
    params = Hash.new
    params['traction_id'] = traction_id
    return doCurl("delete","/traction",params)
  end


  #
  # Fetching a traction
  #
  #  @param traction_id
  #  @return - the data from the api
  #
  def GETTraction( traction_id)
    params = Hash.new
    params['traction_id'] = traction_id
    return doCurl("get","/traction",params)
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
  #  @param reseller_masheryid
  #  @param publisher_masheryid
  #  @param description
  #  @return - the data from the api
  #
  def POSTTraction( traction_id, trigger_type, action_type, country, email_addresses, title, body, api_method, api_url, api_params, active, reseller_masheryid, publisher_masheryid, description)
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
    params['reseller_masheryid'] = reseller_masheryid
    params['publisher_masheryid'] = publisher_masheryid
    params['description'] = description
    return doCurl("post","/traction",params)
  end


  #
  # Fetching active tractions
  #
  #  @return - the data from the api
  #
  def GETTractionActive()
    params = Hash.new
    return doCurl("get","/traction/active",params)
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
  def PUTTransaction( entity_id, user_id, basket_total, basket, currency, notes)
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
  # Given a transaction_id retrieve information on it
  #
  #  @param transaction_id
  #  @return - the data from the api
  #
  def GETTransaction( transaction_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    return doCurl("get","/transaction",params)
  end


  #
  # Set a transactions status to authorised
  #
  #  @param transaction_id
  #  @param paypal_getexpresscheckoutdetails
  #  @return - the data from the api
  #
  def POSTTransactionAuthorised( transaction_id, paypal_getexpresscheckoutdetails)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_getexpresscheckoutdetails'] = paypal_getexpresscheckoutdetails
    return doCurl("post","/transaction/authorised",params)
  end


  #
  # Given a transaction_id retrieve information on it
  #
  #  @param paypal_transaction_id
  #  @return - the data from the api
  #
  def GETTransactionBy_paypal_transaction_id( paypal_transaction_id)
    params = Hash.new
    params['paypal_transaction_id'] = paypal_transaction_id
    return doCurl("get","/transaction/by_paypal_transaction_id",params)
  end


  #
  # Set a transactions status to cancelled
  #
  #  @param transaction_id
  #  @return - the data from the api
  #
  def POSTTransactionCancelled( transaction_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    return doCurl("post","/transaction/cancelled",params)
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
  def POSTTransactionComplete( transaction_id, paypal_doexpresscheckoutpayment, user_id, entity_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_doexpresscheckoutpayment'] = paypal_doexpresscheckoutpayment
    params['user_id'] = user_id
    params['entity_id'] = entity_id
    return doCurl("post","/transaction/complete",params)
  end


  #
  # Set a transactions status to inprogess
  #
  #  @param transaction_id
  #  @param paypal_setexpresscheckout
  #  @return - the data from the api
  #
  def POSTTransactionInprogress( transaction_id, paypal_setexpresscheckout)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_setexpresscheckout'] = paypal_setexpresscheckout
    return doCurl("post","/transaction/inprogress",params)
  end


  #
  # Update user based on email address or social_network/social_network_id
  #
  #  @param email
  #  @param user_id
  #  @param first_name
  #  @param last_name
  #  @param active
  #  @param last_flatpack - Last visited flatpack (used for admin deep linking)
  #  @param trust
  #  @param creation_date
  #  @param user_type
  #  @param social_network
  #  @param social_network_id
  #  @param reseller_admin_masheryid
  #  @param group_id
  #  @param admin_upgrader
  #  @param opt_in_marketing
  #  @return - the data from the api
  #
  def POSTUser( email, user_id, first_name, last_name, active, last_flatpack, trust, creation_date, user_type, social_network, social_network_id, reseller_admin_masheryid, group_id, admin_upgrader, opt_in_marketing)
    params = Hash.new
    params['email'] = email
    params['user_id'] = user_id
    params['first_name'] = first_name
    params['last_name'] = last_name
    params['active'] = active
    params['last_flatpack'] = last_flatpack
    params['trust'] = trust
    params['creation_date'] = creation_date
    params['user_type'] = user_type
    params['social_network'] = social_network
    params['social_network_id'] = social_network_id
    params['reseller_admin_masheryid'] = reseller_admin_masheryid
    params['group_id'] = group_id
    params['admin_upgrader'] = admin_upgrader
    params['opt_in_marketing'] = opt_in_marketing
    return doCurl("post","/user",params)
  end


  #
  # With a unique ID address an user can be retrieved
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def GETUser( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/user",params)
  end


  #
  # Is this user allowed to edit this entity
  #
  #  @param entity_id
  #  @param user_id
  #  @return - the data from the api
  #
  def GETUserAllowed_to_edit( entity_id, user_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['user_id'] = user_id
    return doCurl("get","/user/allowed_to_edit",params)
  end


  #
  # With a unique email address an user can be retrieved
  #
  #  @param email
  #  @return - the data from the api
  #
  def GETUserBy_email( email)
    params = Hash.new
    params['email'] = email
    return doCurl("get","/user/by_email",params)
  end


  #
  # Returns all the users that match the supplied group_id
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def GETUserBy_groupid( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("get","/user/by_groupid",params)
  end


  #
  # Returns all the users that match the supplied reseller_admin_masheryid
  #
  #  @param reseller_admin_masheryid
  #  @return - the data from the api
  #
  def GETUserBy_reseller_admin_masheryid( reseller_admin_masheryid)
    params = Hash.new
    params['reseller_admin_masheryid'] = reseller_admin_masheryid
    return doCurl("get","/user/by_reseller_admin_masheryid",params)
  end


  #
  # With a unique ID address an user can be retrieved
  #
  #  @param name
  #  @param id
  #  @return - the data from the api
  #
  def GETUserBy_social_media( name, id)
    params = Hash.new
    params['name'] = name
    params['id'] = id
    return doCurl("get","/user/by_social_media",params)
  end


  #
  # Downgrade an existing user
  #
  #  @param user_id
  #  @param user_type
  #  @return - the data from the api
  #
  def POSTUserDowngrade( user_id, user_type)
    params = Hash.new
    params['user_id'] = user_id
    params['user_type'] = user_type
    return doCurl("post","/user/downgrade",params)
  end


  #
  # Removes group_admin privileges from a specified user
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def POSTUserGroup_admin_remove( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("post","/user/group_admin_remove",params)
  end


  #
  # Log user activities into MariaDB
  #
  #  @param user_id
  #  @param action_type
  #  @param domain
  #  @param time
  #  @return - the data from the api
  #
  def POSTUserLog_activity( user_id, action_type, domain, time)
    params = Hash.new
    params['user_id'] = user_id
    params['action_type'] = action_type
    params['domain'] = domain
    params['time'] = time
    return doCurl("post","/user/log_activity",params)
  end


  #
  # List user activity times within given date range (between inclusive from and exclusive to)
  #
  #  @param user_id
  #  @param action_type
  #  @param from
  #  @param to
  #  @return - the data from the api
  #
  def GETUserLog_activityList_time( user_id, action_type, from, to)
    params = Hash.new
    params['user_id'] = user_id
    params['action_type'] = action_type
    params['from'] = from
    params['to'] = to
    return doCurl("get","/user/log_activity/list_time",params)
  end


  #
  # Retrieve list of entities that the user manages
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def GETUserManaged_entities( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/user/managed_entities",params)
  end


  #
  # Removes reseller privileges from a specified user
  #
  #  @param user_id
  #  @return - the data from the api
  #
  def POSTUserReseller_remove( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("post","/user/reseller_remove",params)
  end


  #
  # Deletes a specific social network from a user
  #
  #  @param user_id
  #  @param social_network
  #  @return - the data from the api
  #
  def DELETEUserSocial_network( user_id, social_network)
    params = Hash.new
    params['user_id'] = user_id
    params['social_network'] = social_network
    return doCurl("delete","/user/social_network",params)
  end


  #
  # Shows what would be emitted by a view, given a document
  #
  #  @param database - the database being worked on e.g. entities
  #  @param designdoc - the design document containing the view e.g. _design/report
  #  @param view - the name of the view to be tested e.g. bydate
  #  @param doc - the JSON document to be analysed e.g. {}
  #  @return - the data from the api
  #
  def GETViewhelper( database, designdoc, view, doc)
    params = Hash.new
    params['database'] = database
    params['designdoc'] = designdoc
    params['view'] = view
    params['doc'] = doc
    return doCurl("get","/viewhelper",params)
  end


  #
  # Converts an Entity into webcard JSON and then doing a PUT /webcard/json
  #
  #  @param entity_id - The entity to create on webcard
  #  @return - the data from the api
  #
  def POSTWebcard( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("post","/webcard",params)
  end


end

