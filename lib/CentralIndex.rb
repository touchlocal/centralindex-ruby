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
  def getActivity_stream( type, country, latitude_1, longitude_1, latitude_2, longitude_2, number_results, unique_action)
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
  def postActivity_stream( entity_id, entity_name, type, country, longitude, latitude)
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
  # Get all advertisers that have been updated from a give date for a given reseller
  #
  #  @param from_date
  #  @param country
  #  @return - the data from the api
  #
  def getAdvertiserUpdated( from_date, country)
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
  def getAdvertiserUpdatedBy_publisher( publisher_id, from_date, country)
    params = Hash.new
    params['publisher_id'] = publisher_id
    params['from_date'] = from_date
    params['country'] = country
    return doCurl("get","/advertiser/updated/by_publisher",params)
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
  #  @param language - An ISO compatible language code, E.g. en e.g. en
  #  @return - the data from the api
  #
  def getAutocompleteLocation( str, country, language)
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
  def getAutocompleteLocationBy_resolution( str, country, resolution)
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
  #  @param destructive
  #  @return - the data from the api
  #
  def putBusiness( name, building_number, branch_name, address1, address2, address3, district, town, county, province, postcode, country, latitude, longitude, timezone, telephone_number, additional_telephone_number, email, website, category_id, category_type, do_not_display, referrer_url, referrer_name, destructive)
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
    params['destructive'] = destructive
    return doCurl("put","/business",params)
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
  def postBusiness_tool( tool_id, country, headline, description, link_url, active)
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
  # Returns business tool that matches a given tool id
  #
  #  @param tool_id
  #  @return - the data from the api
  #
  def getBusiness_tool( tool_id)
    params = Hash.new
    params['tool_id'] = tool_id
    return doCurl("get","/business_tool",params)
  end


  #
  # Delete a business tool with a specified tool_id
  #
  #  @param tool_id
  #  @return - the data from the api
  #
  def deleteBusiness_tool( tool_id)
    params = Hash.new
    params['tool_id'] = tool_id
    return doCurl("delete","/business_tool",params)
  end


  #
  # Returns active business tools for a specific masheryid in a given country
  #
  #  @param country
  #  @return - the data from the api
  #
  def getBusiness_toolBy_masheryid( country)
    params = Hash.new
    params['country'] = country
    return doCurl("get","/business_tool/by_masheryid",params)
  end


  #
  # Assigns a Business Tool image
  #
  #  @param tool_id
  #  @param filedata
  #  @return - the data from the api
  #
  def postBusiness_toolImage( tool_id, filedata)
    params = Hash.new
    params['tool_id'] = tool_id
    params['filedata'] = filedata
    return doCurl("post","/business_tool/image",params)
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
  # Returns all Central Index categories and associated data
  #
  #  @return - the data from the api
  #
  def getCategoryAll()
    params = Hash.new
    return doCurl("get","/category/all",params)
  end


  #
  # With a known category id, a mapping object can be deleted.
  #
  #  @param category_id
  #  @param category_type
  #  @param mapped_id
  #  @return - the data from the api
  #
  def deleteCategoryMappings( category_id, category_type, mapped_id)
    params = Hash.new
    params['category_id'] = category_id
    params['category_type'] = category_type
    params['mapped_id'] = mapped_id
    return doCurl("delete","/category/mappings",params)
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
  # Get the contract from the ID supplied
  #
  #  @param contract_id
  #  @return - the data from the api
  #
  def getContract( contract_id)
    params = Hash.new
    params['contract_id'] = contract_id
    return doCurl("get","/contract",params)
  end


  #
  # Get a contract from the payment provider id supplied
  #
  #  @param payment_provider
  #  @param payment_provider_id
  #  @return - the data from the api
  #
  def getContractBy_payment_provider_id( payment_provider, payment_provider_id)
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
  def getContractBy_user_id( user_id)
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
  def postContractCancel( contract_id)
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
  #  @param billing_period
  #  @param source
  #  @param channel
  #  @param campaign
  #  @param referrer_domain
  #  @param referrer_name
  #  @param flatpack_id
  #  @return - the data from the api
  #
  def postContractCreate( entity_id, user_id, payment_provider, basket, billing_period, source, channel, campaign, referrer_domain, referrer_name, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['user_id'] = user_id
    params['payment_provider'] = payment_provider
    params['basket'] = basket
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
  def postContractFreeactivate( contract_id, user_name, user_surname, user_email_address)
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
  def postContractPaymentFailure( contract_id, failure_reason, payment_date, amount, currency, response)
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
  def postContractPaymentSetup( contract_id, payment_provider_id, payment_provider_profile, user_name, user_surname, user_billing_address, user_email_address)
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
  def postContractPaymentSuccess( contract_id, payment_date, amount, currency, response)
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
  def postContractProvision( contract_id)
    params = Hash.new
    params['contract_id'] = contract_id
    return doCurl("post","/contract/provision",params)
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
  def postContract_log( contract_id, date, payment_provider, response, success, amount, currency)
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
  # Get the contract log from the ID supplied
  #
  #  @param contract_log_id
  #  @return - the data from the api
  #
  def getContract_log( contract_log_id)
    params = Hash.new
    params['contract_log_id'] = contract_log_id
    return doCurl("get","/contract_log",params)
  end


  #
  # Get the contract logs from the ID supplied
  #
  #  @param contract_id
  #  @param page
  #  @param per_page
  #  @return - the data from the api
  #
  def getContract_logBy_contract_id( contract_id, page, per_page)
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
  def getContract_logBy_payment_provider( payment_provider, page, per_page)
    params = Hash.new
    params['payment_provider'] = payment_provider
    params['page'] = page
    params['per_page'] = per_page
    return doCurl("get","/contract_log/by_payment_provider",params)
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
  def postCountry( country_id, name, synonyms, continentName, continent, geonameId, dbpediaURL, freebaseURL, population, currencyCode, languages, areaInSqKm, capital, east, west, north, south, claimProductId, claimMethods, twilio_sms, twilio_phone, twilio_voice, currency_symbol, currency_symbol_html, postcodeLookupActive, addressFields, addressMatching, dateFormat, iso_3166_alpha_3, iso_3166_numeric)
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
  # For a given country add/update a background image to show in the add/edit path
  #
  #  @param country_id
  #  @param filedata
  #  @param backgroundImageAttr
  #  @return - the data from the api
  #
  def postCountryBackgroundImage( country_id, filedata, backgroundImageAttr)
    params = Hash.new
    params['country_id'] = country_id
    params['filedata'] = filedata
    params['backgroundImageAttr'] = backgroundImageAttr
    return doCurl("post","/country/backgroundImage",params)
  end


  #
  # For a given country add/update a social login background image to show in the add/edit path
  #
  #  @param country_id
  #  @param filedata
  #  @return - the data from the api
  #
  def postCountrySocialLoginImage( country_id, filedata)
    params = Hash.new
    params['country_id'] = country_id
    params['filedata'] = filedata
    return doCurl("post","/country/socialLoginImage",params)
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
  # Allows a whole entity to be pulled from the datastore by its unique id
  #
  #  @param entity_id - The unique entity ID e.g. 379236608286720
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntity( entity_id, domain, path)
    params = Hash.new
    params['entity_id'] = entity_id
    params['domain'] = domain
    params['path'] = path
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
  def postEntityAdd( entity_id, add_referrer_url, add_referrer_name)
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
  def deleteEntityAdvertiser( entity_id, gen_id)
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
  def postEntityAdvertiserCancel( entity_id, publisher_id, reseller_ref, reseller_agent_id)
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
  # Adding an affiliate adblock to a known entity
  #
  #  @param entity_id
  #  @param adblock - Number of results returned per page
  #  @return - the data from the api
  #
  def postEntityAffiliate_adblock( entity_id, adblock)
    params = Hash.new
    params['entity_id'] = entity_id
    params['adblock'] = adblock
    return doCurl("post","/entity/affiliate_adblock",params)
  end


  #
  # Deleteing an affiliate adblock from a known entity
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityAffiliate_adblock( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/affiliate_adblock",params)
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
  def postEntityAffiliate_link( entity_id, affiliate_name, affiliate_link, affiliate_message, affiliate_logo, affiliate_action)
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
  def deleteEntityAffiliate_link( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/affiliate_link",params)
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
  # Get all entities within a specified group
  #
  #  @param group_id
  #  @return - the data from the api
  #
  def getEntityBy_groupid( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("get","/entity/by_groupid",params)
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
  def deleteEntityBy_supplier( entity_id, supplier_masheryid, supplier_id, supplier_user_id)
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
  #  @param supplier_id - The Supplier ID
  #  @return - the data from the api
  #
  def getEntityBy_supplier_id( supplier_id)
    params = Hash.new
    params['supplier_id'] = supplier_id
    return doCurl("get","/entity/by_supplier_id",params)
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
  # Allow an entity to be claimed by a valid user
  #
  #  @param entity_id
  #  @param claimed_user_id
  #  @param claimed_reseller_id
  #  @param expiry_date
  #  @param claimed_date
  #  @param claim_method
  #  @param phone_number
  #  @param referrer_url
  #  @param referrer_name
  #  @return - the data from the api
  #
  def postEntityClaim( entity_id, claimed_user_id, claimed_reseller_id, expiry_date, claimed_date, claim_method, phone_number, referrer_url, referrer_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['claimed_user_id'] = claimed_user_id
    params['claimed_reseller_id'] = claimed_reseller_id
    params['expiry_date'] = expiry_date
    params['claimed_date'] = claimed_date
    params['claim_method'] = claim_method
    params['phone_number'] = phone_number
    params['referrer_url'] = referrer_url
    params['referrer_name'] = referrer_name
    return doCurl("post","/entity/claim",params)
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
  # With a known entity id, a description object can be added.
  #
  #  @param entity_id
  #  @param headline
  #  @param body
  #  @param gen_id
  #  @return - the data from the api
  #
  def postEntityDescription( entity_id, headline, body, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    params['gen_id'] = gen_id
    return doCurl("post","/entity/description",params)
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
  # With a known entity id, a image can be retrieved from a url and added.
  #
  #  @param entity_id
  #  @param image_url
  #  @param image_name
  #  @return - the data from the api
  #
  def postEntityImageBy_url( entity_id, image_url, image_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['image_url'] = image_url
    params['image_name'] = image_name
    return doCurl("post","/entity/image/by_url",params)
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
  def postEntityInvoice_address( entity_id, building_number, address1, address2, address3, district, town, county, province, postcode, address_type)
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
  # Find all entities in a group
  #
  #  @param group_id - A valid group_id
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @return - the data from the api
  #
  def getEntityList_by_group_id( group_id, per_page, page)
    params = Hash.new
    params['group_id'] = group_id
    params['per_page'] = per_page
    params['page'] = page
    return doCurl("get","/entity/list_by_group_id",params)
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
  # With a known entity id, a logo can be retrieved from a url and added.
  #
  #  @param entity_id
  #  @param logo_url
  #  @param logo_name
  #  @return - the data from the api
  #
  def postEntityLogoBy_url( entity_id, logo_url, logo_name)
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
  #  @return - the data from the api
  #
  def postEntityMerge( from, to, override_trust, uncontribute_masheryid, uncontribute_userid, uncontribute_supplierid)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['override_trust'] = override_trust
    params['uncontribute_masheryid'] = uncontribute_masheryid
    params['uncontribute_userid'] = uncontribute_userid
    params['uncontribute_supplierid'] = uncontribute_supplierid
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
  def postEntityMigrate_category( from, to, limit)
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
  def postEntityName( entity_id, name, formal_name, branch_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['name'] = name
    params['formal_name'] = formal_name
    params['branch_name'] = branch_name
    return doCurl("post","/entity/name",params)
  end


  #
  # With a known entity id, a opening times object can be removed.
  #
  #  @param entity_id - The id of the entity to edit
  #  @return - the data from the api
  #
  def deleteEntityOpening_times( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/opening_times",params)
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
  # Allows a payment_type object to be reduced in confidence
  #
  #  @param entity_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteEntityPayment_type( entity_id, gen_id)
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
  def postEntityPayment_type( entity_id, payment_type)
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
  #  @param trackable
  #  @return - the data from the api
  #
  def postEntityPhone( entity_id, number, trackable)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
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
  def deleteEntityPhone( entity_id, gen_id)
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
  def postEntityPostal_address( entity_id, building_number, address1, address2, address3, district, town, county, province, postcode, address_type, do_not_display)
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
  def getEntityProvisionalBy_supplier_id( supplier_id)
    params = Hash.new
    params['supplier_id'] = supplier_id
    return doCurl("get","/entity/provisional/by_supplier_id",params)
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
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchByboundingbox( latitude_1, longitude_1, latitude_2, longitude_2, per_page, page, country, language, domain, path)
    params = Hash.new
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/byboundingbox",params)
  end


  #
  # Search for matching entities
  #
  #  @param where - Location to search for results. E.g. Dublin e.g. Dublin
  #  @param per_page - How many results per page
  #  @param page - What page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the search context (optional)
  #  @param longitude - The decimal longitude of the search context (optional)
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchBylocation( where, per_page, page, country, language, latitude, longitude, domain, path)
    params = Hash.new
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/bylocation",params)
  end


  #
  # Search for entities matching the supplied group_id and where, ordered by nearness
  #
  #  @param group_id - the group_id to search for
  #  @param where - the location to search in
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search context
  #  @param longitude - The decimal longitude of the centre point of the search context
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchGroupBylocation( group_id, where, country, per_page, page, language, latitude, longitude, domain, path)
    params = Hash.new
    params['group_id'] = group_id
    params['where'] = where
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/group/bylocation",params)
  end


  #
  # Search for entities matching the supplied group_id, ordered by nearness
  #
  #  @param group_id - the group_id to search for
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchGroupBynearest( group_id, country, per_page, page, language, latitude, longitude, domain, path)
    params = Hash.new
    params['group_id'] = group_id
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/group/bynearest",params)
  end


  #
  # Search for entities matching the supplied 'who', ordered by nearness
  #
  #  @param keyword - What to get results for. E.g. cafe e.g. cafe
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchKeywordBynearest( keyword, country, per_page, page, language, latitude, longitude, domain, path)
    params = Hash.new
    params['keyword'] = keyword
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/keyword/bynearest",params)
  end


  #
  # Search for matching entities
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param per_page - Number of results returned per page
  #  @param page - The page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhat( what, per_page, page, country, language, domain, path)
    params = Hash.new
    params['what'] = what
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
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
  #  @param per_page
  #  @param page
  #  @param country - A valid ISO 3166 country code e.g. ie
  #  @param language
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhatByboundingbox( what, latitude_1, longitude_1, latitude_2, longitude_2, per_page, page, country, language, domain, path)
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
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/what/byboundingbox",params)
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
  #  @param latitude - The decimal latitude of the search context (optional)
  #  @param longitude - The decimal longitude of the search context (optional)
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhatBylocation( what, where, per_page, page, country, language, latitude, longitude, domain, path)
    params = Hash.new
    params['what'] = what
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/what/bylocation",params)
  end


  #
  # Search for matching entities, ordered by nearness
  #
  #  @param what - What to get results for. E.g. Plumber e.g. plumber
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhatBynearest( what, country, per_page, page, language, latitude, longitude, domain, path)
    params = Hash.new
    params['what'] = what
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/what/bynearest",params)
  end


  #
  # Search for matching entities
  #
  #  @param who - Company name e.g. Starbucks
  #  @param per_page - How many results per page
  #  @param page - What page number to retrieve
  #  @param country - Which country to return results for. An ISO compatible country code, E.g. ie e.g. ie
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWho( who, per_page, page, country, language, domain, path)
    params = Hash.new
    params['who'] = who
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
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
  #  @param per_page
  #  @param page
  #  @param country
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhoByboundingbox( who, latitude_1, longitude_1, latitude_2, longitude_2, per_page, page, country, language, domain, path)
    params = Hash.new
    params['who'] = who
    params['latitude_1'] = latitude_1
    params['longitude_1'] = longitude_1
    params['latitude_2'] = latitude_2
    params['longitude_2'] = longitude_2
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
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
  #  @param latitude - The decimal latitude of the search context (optional)
  #  @param longitude - The decimal longitude of the search context (optional)
  #  @param language - An ISO compatible language code, E.g. en
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhoBylocation( who, where, per_page, page, country, latitude, longitude, language, domain, path)
    params = Hash.new
    params['who'] = who
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['language'] = language
    params['domain'] = domain
    params['path'] = path
    return doCurl("get","/entity/search/who/bylocation",params)
  end


  #
  # Search for entities matching the supplied 'who', ordered by nearness
  #
  #  @param who - What to get results for. E.g. Plumber e.g. plumber
  #  @param country - The country to fetch results for e.g. gb
  #  @param per_page - Number of results returned per page
  #  @param page - Which page number to retrieve
  #  @param language - An ISO compatible language code, E.g. en
  #  @param latitude - The decimal latitude of the centre point of the search
  #  @param longitude - The decimal longitude of the centre point of the search
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def getEntitySearchWhoBynearest( who, country, per_page, page, language, latitude, longitude, domain, path)
    params = Hash.new
    params['who'] = who
    params['country'] = country
    params['per_page'] = per_page
    params['page'] = page
    params['language'] = language
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['domain'] = domain
    params['path'] = path
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
  def postEntitySend_email( entity_id, gen_id, from_email, subject, content)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['from_email'] = from_email
    params['subject'] = subject
    params['content'] = content
    return doCurl("post","/entity/send_email",params)
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
  # With a known entity id, a status object can be updated.
  #
  #  @param entity_id
  #  @param status
  #  @param inactive_reason
  #  @param inactive_description
  #  @return - the data from the api
  #
  def postEntityStatus( entity_id, status, inactive_reason, inactive_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['status'] = status
    params['inactive_reason'] = inactive_reason
    params['inactive_description'] = inactive_description
    return doCurl("post","/entity/status",params)
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
  # Get the updates a uncontribute would perform
  #
  #  @param entity_id - The entity to pull
  #  @param object_name - The entity object to update
  #  @param supplier_id - The supplier_id to remove
  #  @param user_id - The user_id to remove
  #  @return - the data from the api
  #
  def getEntityUncontribute( entity_id, object_name, supplier_id, user_id)
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
  # Find the provided user in all the sub objects and update the trust
  #
  #  @param entity_id - the entity_id to update
  #  @param user_id - the user to search for
  #  @param trust - The new trust for the user
  #  @return - the data from the api
  #
  def postEntityUser_trust( entity_id, user_id, trust)
    params = Hash.new
    params['entity_id'] = entity_id
    params['user_id'] = user_id
    params['trust'] = trust
    return doCurl("post","/entity/user_trust",params)
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
  # With a known entity id, a website object can be added.
  #
  #  @param entity_id
  #  @param website_url
  #  @param display_url
  #  @param website_description
  #  @param gen_id
  #  @return - the data from the api
  #
  def postEntityWebsite( entity_id, website_url, display_url, website_description, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['website_url'] = website_url
    params['display_url'] = display_url
    params['website_description'] = website_description
    params['gen_id'] = gen_id
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
  # Add an entityserve document
  #
  #  @param entity_id - The id of the entity to create the entityserve event for
  #  @param country - the ISO code of the country
  #  @param event_type - The event type being recorded
  #  @param domain
  #  @param path
  #  @return - the data from the api
  #
  def putEntityserve( entity_id, country, event_type, domain, path)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
    params['event_type'] = event_type
    params['domain'] = domain
    params['path'] = path
    return doCurl("put","/entityserve",params)
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
  # Update/Add a flatpack
  #
  #  @param flatpack_id - this record's unique, auto-generated id - if supplied, then this is an edit, otherwise it's an add
  #  @param domainName - the domain name to serve this flatpack site on (no leading http:// or anything please)
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
  #  @param linkToRoot - the root domain name to serve this flatpack site on (no leading http:// or anything please)
  #  @return - the data from the api
  #
  def postFlatpack( flatpack_id, domainName, stub, flatpackName, less, language, country, mapsType, mapKey, searchFormShowOn, searchFormShowKeywordsBox, searchFormShowLocationBox, searchFormKeywordsAutoComplete, searchFormLocationsAutoComplete, searchFormDefaultLocation, searchFormPlaceholderKeywords, searchFormPlaceholderLocation, searchFormKeywordsLabel, searchFormLocationLabel, cannedLinksHeader, homepageTitle, homepageDescription, homepageIntroTitle, homepageIntroText, head, adblock, bodyTop, bodyBottom, header_menu, header_menu_bottom, footer_menu, bdpTitle, bdpDescription, bdpAds, serpTitle, serpDescription, serpNumberResults, serpNumberAdverts, serpAds, serpTitleNoWhat, serpDescriptionNoWhat, cookiePolicyUrl, cookiePolicyNotice, addBusinessButtonText, twitterUrl, facebookUrl, copyright, phoneReveal, loginLinkText, contextLocationId, addBusinessButtonPosition, denyIndexing, contextRadius, activityStream, activityStreamSize, products, linkToRoot)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['domainName'] = domainName
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
    return doCurl("post","/flatpack",params)
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
  # Upload a CSS file for the Admin for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackAdminCSS( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/adminCSS",params)
  end


  #
  # Upload an image to serve out as the large logo in the Admin for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackAdminLargeLogo( flatpack_id, filedata)
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
  def postFlatpackAdminSmallLogo( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/adminSmallLogo",params)
  end


  #
  # Get flatpacks by country and location
  #
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @return - the data from the api
  #
  def getFlatpackBy_country( country, latitude, longitude)
    params = Hash.new
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    return doCurl("get","/flatpack/by_country",params)
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
  # Clone an existing flatpack
  #
  #  @param flatpack_id - the flatpack_id to clone
  #  @param domainName - the domain of the new flatpack site (no leading http:// or anything please)
  #  @return - the data from the api
  #
  def getFlatpackClone( flatpack_id, domainName)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['domainName'] = domainName
    return doCurl("get","/flatpack/clone",params)
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
  # Add a hd logo to a flatpack domain
  #
  #  @param flatpack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackLogoHd( flatpack_id, filedata)
    params = Hash.new
    params['flatpack_id'] = flatpack_id
    params['filedata'] = filedata
    return doCurl("post","/flatpack/logo/hd",params)
  end


  #
  # Upload a TXT file to act as the sitemap for this flatpack
  #
  #  @param flatpack_id - the id of the flatpack to update
  #  @param filedata
  #  @return - the data from the api
  #
  def postFlatpackSitemap( flatpack_id, filedata)
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
  def deleteGroup( group_id)
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
  def postGroup( group_id, name, description, url, stamp_user_id, stamp_sql)
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
  def getGroup( group_id)
    params = Hash.new
    params['group_id'] = group_id
    return doCurl("get","/group",params)
  end


  #
  # Returns all groups
  #
  #  @return - the data from the api
  #
  def getGroupAll()
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
  def postGroupBulk_delete( group_id, filedata)
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
  def postGroupBulk_ingest( group_id, filedata, category_type)
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
  def postGroupBulk_update( group_id, data)
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
  def getHeartbeatBy_date( from_date, to_date, country_id)
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
  def getHeartbeatTodayClaims( country, claim_type)
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
  def postIngest_file( job_id, filedata)
    params = Hash.new
    params['job_id'] = job_id
    params['filedata'] = filedata
    return doCurl("post","/ingest_file",params)
  end


  #
  # Get an ingest job from the collection
  #
  #  @param job_id
  #  @return - the data from the api
  #
  def getIngest_job( job_id)
    params = Hash.new
    params['job_id'] = job_id
    return doCurl("get","/ingest_job",params)
  end


  #
  # Add a ingest job to the collection
  #
  #  @param description
  #  @param category_type
  #  @return - the data from the api
  #
  def postIngest_job( description, category_type)
    params = Hash.new
    params['description'] = description
    params['category_type'] = category_type
    return doCurl("post","/ingest_job",params)
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
  def getIngest_logBy_job_id( job_id, success, errors, limit, skip)
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
  def getIngest_queue( flush)
    params = Hash.new
    params['flush'] = flush
    return doCurl("get","/ingest_queue",params)
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
  def postLocation( location_id, type, country, language, name, formal_name, resolution, population, description, timezone, latitude, longitude, parent_town, parent_county, parent_province, parent_region, parent_neighbourhood, parent_district, postalcode, searchable_id, searchable_ids)
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
  # Given a location_id or a lat/lon, find other locations within the radius
  #
  #  @param location_id
  #  @param latitude
  #  @param longitude
  #  @param radius - Radius in km
  #  @param resolution
  #  @param country
  #  @return - the data from the api
  #
  def getLocationContext( location_id, latitude, longitude, radius, resolution, country)
    params = Hash.new
    params['location_id'] = location_id
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['radius'] = radius
    params['resolution'] = resolution
    params['country'] = country
    return doCurl("get","/location/context",params)
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
  # Find a location from cache or cloudant depending if it is in the cache (locz)
  #
  #  @param string
  #  @param language
  #  @param country
  #  @param latitude
  #  @param longitude
  #  @return - the data from the api
  #
  def getLookupLocation( string, language, country, latitude, longitude)
    params = Hash.new
    params['string'] = string
    params['language'] = language
    params['country'] = country
    params['latitude'] = latitude
    params['longitude'] = longitude
    return doCurl("get","/lookup/location",params)
  end


  #
  # Find all matches by phone number and then return all matches that also match company name and location. Default location_strictness is defined in Km and the default is set to 0.2 (200m)
  #
  #  @param phone
  #  @param company_name
  #  @param latitude
  #  @param longitude
  #  @param postcode
  #  @param country
  #  @param name_strictness
  #  @param location_strictness
  #  @return - the data from the api
  #
  def getMatchByphone( phone, company_name, latitude, longitude, postcode, country, name_strictness, location_strictness)
    params = Hash.new
    params['phone'] = phone
    params['company_name'] = company_name
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['postcode'] = postcode
    params['country'] = country
    params['name_strictness'] = name_strictness
    params['location_strictness'] = location_strictness
    return doCurl("get","/match/byphone",params)
  end


  #
  # Find all matches by phone number, returning up to 10 matches
  #
  #  @param phone
  #  @param country
  #  @param exclude - Entity ID to exclude from the results
  #  @return - the data from the api
  #
  def getMatchByphone2( phone, country, exclude)
    params = Hash.new
    params['phone'] = phone
    params['country'] = country
    params['exclude'] = exclude
    return doCurl("get","/match/byphone2",params)
  end


  #
  # Perform a match on the two supplied entities, returning the outcome and showing our working
  #
  #  @param primary_entity_id
  #  @param secondary_entity_id
  #  @param return_entities - Should we return the entity documents
  #  @return - the data from the api
  #
  def getMatchOftheday( primary_entity_id, secondary_entity_id, return_entities)
    params = Hash.new
    params['primary_entity_id'] = primary_entity_id
    params['secondary_entity_id'] = secondary_entity_id
    params['return_entities'] = return_entities
    return doCurl("get","/match/oftheday",params)
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
  #  @return - the data from the api
  #
  def putMatching_log( primary_entity_id, secondary_entity_id, primary_name, secondary_name, address_score, address_match, name_score, name_match, distance)
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
    return doCurl("put","/matching_log",params)
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
  #  @param cookiePolicyShow - whether to show cookie policy
  #  @param cookiePolicyUrl - url of cookie policy
  #  @param twitterUrl - url of twitter feed
  #  @param facebookUrl - url of facebook feed
  #  @return - the data from the api
  #
  def postMultipack( multipack_id, group_id, domainName, multipackName, less, country, menuTop, menuBottom, language, menuFooter, searchNumberResults, searchTitle, searchDescription, searchTitleNoWhere, searchDescriptionNoWhere, searchIntroHeader, searchIntroText, searchShowAll, cookiePolicyShow, cookiePolicyUrl, twitterUrl, facebookUrl)
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
  def getMultipack( multipack_id)
    params = Hash.new
    params['multipack_id'] = multipack_id
    return doCurl("get","/multipack",params)
  end


  #
  # Get a multipack using a domain name
  #
  #  @param domainName - the domain name to search for
  #  @return - the data from the api
  #
  def getMultipackBy_domain_name( domainName)
    params = Hash.new
    params['domainName'] = domainName
    return doCurl("get","/multipack/by_domain_name",params)
  end


  #
  # Add a logo to a multipack domain
  #
  #  @param multipack_id - the unique id to search for
  #  @param filedata
  #  @return - the data from the api
  #
  def postMultipackLogo( multipack_id, filedata)
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
  def postMultipackMap_pin( multipack_id, filedata, mapPinOffsetX, mapPinOffsetY)
    params = Hash.new
    params['multipack_id'] = multipack_id
    params['filedata'] = filedata
    params['mapPinOffsetX'] = mapPinOffsetX
    params['mapPinOffsetY'] = mapPinOffsetY
    return doCurl("post","/multipack/map_pin",params)
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
  # Returns the product information given a valid product_id
  #
  #  @param product_id
  #  @return - the data from the api
  #
  def getProduct( product_id)
    params = Hash.new
    params['product_id'] = product_id
    return doCurl("get","/product",params)
  end


  #
  # Update/Add a product
  #
  #  @param product_id - The ID of the product
  #  @param name - The name of the product
  #  @param strapline - The description of the product
  #  @param price - The price of the product
  #  @param tax_rate - The tax markup for this product
  #  @param currency - The currency in which the price is in
  #  @param active - is this an active product
  #  @param billing_period
  #  @param title - Title of the product
  #  @param intro_paragraph - introduction paragraph
  #  @param bullets - pipe separated product features
  #  @param outro_paragraph - closing paragraph
  #  @param thanks_paragraph - thank you paragraph
  #  @return - the data from the api
  #
  def postProduct( product_id, name, strapline, price, tax_rate, currency, active, billing_period, title, intro_paragraph, bullets, outro_paragraph, thanks_paragraph)
    params = Hash.new
    params['product_id'] = product_id
    params['name'] = name
    params['strapline'] = strapline
    params['price'] = price
    params['tax_rate'] = tax_rate
    params['currency'] = currency
    params['active'] = active
    params['billing_period'] = billing_period
    params['title'] = title
    params['intro_paragraph'] = intro_paragraph
    params['bullets'] = bullets
    params['outro_paragraph'] = outro_paragraph
    params['thanks_paragraph'] = thanks_paragraph
    return doCurl("post","/product",params)
  end


  #
  # Removes a provisioning object from product
  #
  #  @param product_id
  #  @param gen_id
  #  @return - the data from the api
  #
  def deleteProductProvisioning( product_id, gen_id)
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
  def postProductProvisioningAdvert( product_id, publisher_id, max_tags, max_locations)
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
  #  @return - the data from the api
  #
  def postProductProvisioningClaim( product_id)
    params = Hash.new
    params['product_id'] = product_id
    return doCurl("post","/product/provisioning/claim",params)
  end


  #
  # Adds SCheduleSMS provisioning object to a product
  #
  #  @param product_id
  #  @param package
  #  @return - the data from the api
  #
  def postProductProvisioningSchedulesms( product_id, package)
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
  def postProductProvisioningSyndication( product_id, publisher_id)
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
  def getPtbAll( entity_id, destructive)
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
  def getPtbLog( year, month, entity_id)
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
  def getPtbModule( entity_id, __module, destructive)
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
  def getPtbRunrate( country, year, month, day)
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
  def getPtbValueadded( country, year, month, day)
    params = Hash.new
    params['country'] = country
    params['year'] = year
    params['month'] = month
    params['day'] = day
    return doCurl("get","/ptb/valueadded",params)
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
  #  @return - the data from the api
  #
  def postPublisher( publisher_id, country, name, description, active, url_patterns)
    params = Hash.new
    params['publisher_id'] = publisher_id
    params['country'] = country
    params['name'] = name
    params['description'] = description
    params['active'] = active
    params['url_patterns'] = url_patterns
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
  # Find a queue item by its cloudant id
  #
  #  @param queue_id
  #  @return - the data from the api
  #
  def getQueueBy_id( queue_id)
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
  # Update/Add a reseller
  #
  #  @param reseller_id
  #  @param country
  #  @param name
  #  @param description
  #  @param active
  #  @param products
  #  @return - the data from the api
  #
  def postReseller( reseller_id, country, name, description, active, products)
    params = Hash.new
    params['reseller_id'] = reseller_id
    params['country'] = country
    params['name'] = name
    params['description'] = description
    params['active'] = active
    params['products'] = products
    return doCurl("post","/reseller",params)
  end


  #
  # Returns reseller that matches a given reseller id
  #
  #  @param reseller_id
  #  @return - the data from the api
  #
  def getReseller( reseller_id)
    params = Hash.new
    params['reseller_id'] = reseller_id
    return doCurl("get","/reseller",params)
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
  # Return a sales log by id
  #
  #  @param from_date
  #  @param country
  #  @param action_type
  #  @return - the data from the api
  #
  def getSales_logBy_countryBy_date( from_date, country, action_type)
    params = Hash.new
    params['from_date'] = from_date
    params['country'] = country
    params['action_type'] = action_type
    return doCurl("get","/sales_log/by_country/by_date",params)
  end


  #
  # Return a sales log by id
  #
  #  @param from_date
  #  @param to_date
  #  @return - the data from the api
  #
  def getSales_logBy_date( from_date, to_date)
    params = Hash.new
    params['from_date'] = from_date
    params['to_date'] = to_date
    return doCurl("get","/sales_log/by_date",params)
  end


  #
  # Log a sale
  #
  #  @param entity_id - The entity the sale was made against
  #  @param country - The country code the sales log orginated
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
  def postSales_logEntity( entity_id, country, action_type, publisher_id, mashery_id, reseller_ref, reseller_agent_id, max_tags, max_locations, extra_tags, extra_locations, expiry_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
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
  def postSales_logSyndication( action_type, syndication_type, publisher_id, expiry_date, entity_id, group_id, seed_masheryid, supplier_masheryid, country, reseller_masheryid)
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
  # Make a url shorter
  #
  #  @param url - the url to shorten
  #  @return - the data from the api
  #
  def putShortenurl( url)
    params = Hash.new
    params['url'] = url
    return doCurl("put","/shortenurl",params)
  end


  #
  # get the long url from the db
  #
  #  @param id - the id to fetch from the db
  #  @return - the data from the api
  #
  def getShortenurl( id)
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
  #  @return - the data from the api
  #
  def postSignal( entity_id, country, gen_id, signal_type, data_type, inactive_reason, inactive_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['country'] = country
    params['gen_id'] = gen_id
    params['signal_type'] = signal_type
    params['data_type'] = data_type
    params['inactive_reason'] = inactive_reason
    params['inactive_description'] = inactive_description
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
  # Get the stats on an entity in a given year
  #
  #  @param entity_id - A valid entity_id e.g. 379236608286720
  #  @param year - The year to report on
  #  @return - the data from the api
  #
  def getStatsEntityBy_year( entity_id, year)
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
  def getStatus()
    params = Hash.new
    return doCurl("get","/status",params)
  end


  #
  # get a Syndication
  #
  #  @param syndication_id
  #  @return - the data from the api
  #
  def getSyndication( syndication_id)
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
  def getSyndicationBy_entity_id( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/syndication/by_entity_id",params)
  end


  #
  # Cancel a syndication
  #
  #  @param syndication_id
  #  @return - the data from the api
  #
  def postSyndicationCancel( syndication_id)
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
  #  @return - the data from the api
  #
  def postSyndicationCreate( syndication_type, publisher_id, expiry_date, entity_id, group_id, seed_masheryid, supplier_masheryid, country)
    params = Hash.new
    params['syndication_type'] = syndication_type
    params['publisher_id'] = publisher_id
    params['expiry_date'] = expiry_date
    params['entity_id'] = entity_id
    params['group_id'] = group_id
    params['seed_masheryid'] = seed_masheryid
    params['supplier_masheryid'] = supplier_masheryid
    params['country'] = country
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
  def postSyndicationRenew( syndication_type, publisher_id, entity_id, group_id, seed_masheryid, supplier_masheryid, country, expiry_date)
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
  #  @return - the data from the api
  #
  def postSyndication_log( entity_id, publisher_id, action, success, message, syndicated_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['action'] = action
    params['success'] = success
    params['message'] = message
    params['syndicated_id'] = syndicated_id
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
  def getSyndication_logBy_entity_id( entity_id, page, per_page)
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
  def getSyndication_logLast_syndicated_id( entity_id, publisher_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    return doCurl("get","/syndication_log/last_syndicated_id",params)
  end


  #
  # Returns a Syndication Submission
  #
  #  @param syndication_submission_id
  #  @return - the data from the api
  #
  def getSyndication_submission( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("get","/syndication_submission",params)
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
  def putSyndication_submission( syndication_type, entity_id, publisher_id, submission_id)
    params = Hash.new
    params['syndication_type'] = syndication_type
    params['entity_id'] = entity_id
    params['publisher_id'] = publisher_id
    params['submission_id'] = submission_id
    return doCurl("put","/syndication_submission",params)
  end


  #
  # Set active to false for a Syndication Submission
  #
  #  @param syndication_submission_id
  #  @return - the data from the api
  #
  def postSyndication_submissionDeactivate( syndication_submission_id)
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
  def postSyndication_submissionProcessed( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("post","/syndication_submission/processed",params)
  end


  #
  # Provides a tokenised URL to redirect a user so they can add an entity to Central Index
  #
  #  @param language - The language to use to render the add path e.g. en
  #  @param portal_name - The name of the website that data is to be added on e.g. YourLocal
  #  @param country - The country of the entity to be added e.g. gb
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def getTokenAdd( language, portal_name, country, flatpack_id)
    params = Hash.new
    params['language'] = language
    params['portal_name'] = portal_name
    params['country'] = country
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/add",params)
  end


  #
  # Provides a tokenised URL to redirect a user to claim an entity on Central Index
  #
  #  @param entity_id - Entity ID to be claimed e.g. 380348266819584
  #  @param language - The language to use to render the claim path e.g. en
  #  @param portal_name - The name of the website that entity is being claimed on e.g. YourLocal
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def getTokenClaim( entity_id, language, portal_name, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['language'] = language
    params['portal_name'] = portal_name
    params['flatpack_id'] = flatpack_id
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
  def getTokenContact_us( portal_name, flatpack_id, language, referring_url)
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
  def getTokenDecode( token)
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
  def getTokenEdit( entity_id, language, flatpack_id, edit_page)
    params = Hash.new
    params['entity_id'] = entity_id
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    params['edit_page'] = edit_page
    return doCurl("get","/token/edit",params)
  end


  #
  # Fetch token for login path
  #
  #  @param portal_name - The name of the application that has initiated the login process, example: 'Your Local'
  #  @param language - The language for the app
  #  @param flatpack_id - The id of the flatpack site where the request originated
  #  @return - the data from the api
  #
  def getTokenLogin( portal_name, language, flatpack_id)
    params = Hash.new
    params['portal_name'] = portal_name
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/login",params)
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
  def getTokenMessage( entity_id, portal_name, language, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/message",params)
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
  def getTokenProduct( entity_id, product_id, language, portal_name, flatpack_id, source, channel, campaign)
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
  def getTokenProduct_selector( entity_id, portal_name, flatpack_id, language)
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
  def getTokenReport( entity_id, portal_name, language, flatpack_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['portal_name'] = portal_name
    params['language'] = language
    params['flatpack_id'] = flatpack_id
    return doCurl("get","/token/report",params)
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
  def getTokenTestimonial( portal_name, flatpack_id, language, entity_id, shorten_url)
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
  def getToolsAddressdiff( first_entity_id, second_entity_id)
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
  def getToolsCrash()
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
  def postToolsCurl( method, path, filedata, email)
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
  def getToolsDocs( object, format)
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
  def getToolsFormatAddress( address, country)
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
  #  @return - the data from the api
  #
  def getToolsFormatPhone( number, country)
    params = Hash.new
    params['number'] = number
    params['country'] = country
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
  #  @param geocoder
  #  @return - the data from the api
  #
  def getToolsGeocode( building_number, address1, address2, address3, district, town, county, province, postcode, country, geocoder)
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
    params['geocoder'] = geocoder
    return doCurl("get","/tools/geocode",params)
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
  # Given some image data we can resize and upload the images
  #
  #  @param filedata - The image data to upload and resize
  #  @param type - The type of image to upload and resize
  #  @return - the data from the api
  #
  def postToolsImage( filedata, type)
    params = Hash.new
    params['filedata'] = filedata
    params['type'] = type
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
  def getToolsIodocs( mode, path, endpoint, doctype)
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
  def getToolsLess( less)
    params = Hash.new
    params['less'] = less
    return doCurl("get","/tools/less",params)
  end


  #
  # Ring the person and verify their account
  #
  #  @param to - The phone number to verify
  #  @param from - The phone number to call from
  #  @param pin - The pin to verify the phone number with
  #  @param twilio_voice - The language to read the verification in
  #  @return - the data from the api
  #
  def getToolsPhonecallVerify( to, from, pin, twilio_voice)
    params = Hash.new
    params['to'] = to
    params['from'] = from
    params['pin'] = pin
    params['twilio_voice'] = twilio_voice
    return doCurl("get","/tools/phonecall/verify",params)
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
  # Force refresh of search indexes
  #
  #  @return - the data from the api
  #
  def getToolsReindex()
    params = Hash.new
    return doCurl("get","/tools/reindex",params)
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
  # Fetch the result of submitted data we sent to InfoGroup
  #
  #  @param syndication_submission_id - The syndication_submission_id to fetch info for
  #  @return - the data from the api
  #
  def getToolsSubmissionInfogroup( syndication_submission_id)
    params = Hash.new
    params['syndication_submission_id'] = syndication_submission_id
    return doCurl("get","/tools/submission/infogroup",params)
  end


  #
  # Fetch the entity and convert it to Bing Ads CSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def getToolsSyndicateBingads( entity_id)
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
  def getToolsSyndicateBingplaces( entity_id)
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
  def getToolsSyndicateDnb( entity_id)
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
  #  @return - the data from the api
  #
  def getToolsSyndicateEnablemedia( entity_id, reseller_masheryid, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['reseller_masheryid'] = reseller_masheryid
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/enablemedia",params)
  end


  #
  # Fetch the entity and convert add it to Factual
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def getToolsSyndicateFactual( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/factual",params)
  end


  #
  # Syndicate an entity to Foursquare
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def getToolsSyndicateFoursquare( entity_id, destructive)
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
  def getToolsSyndicateGoogle( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/google",params)
  end


  #
  # Fetch the entity and convert add it to InfoGroup
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def getToolsSyndicateInfogroup( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/infogroup",params)
  end


  #
  # Fetch the entity and convert it to Google KML format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def getToolsSyndicateKml( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/kml",params)
  end


  #
  # Fetch the entity and convert it to Nokia CSV format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def getToolsSyndicateNokia( entity_id)
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
  def getToolsSyndicateOsm( entity_id, destructive)
    params = Hash.new
    params['entity_id'] = entity_id
    params['destructive'] = destructive
    return doCurl("get","/tools/syndicate/osm",params)
  end


  #
  # Fetch the entity and convert it to TomTom XML format
  #
  #  @param entity_id - The entity_id to fetch
  #  @return - the data from the api
  #
  def getToolsSyndicateTomtom( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/tools/syndicate/tomtom",params)
  end


  #
  # Fetch the entity and convert add it to Yassaaaabeeee!!
  #
  #  @param entity_id - The entity_id to fetch
  #  @param destructive - Add the entity or simulate adding the entity
  #  @return - the data from the api
  #
  def getToolsSyndicateYasabe( entity_id, destructive)
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
  def getToolsTestmatch( name, building_number, branch_name, address1, address2, address3, district, town, county, province, postcode, country, latitude, longitude, timezone, telephone_number, additional_telephone_number, email, website, category_id, category_type, do_not_display, referrer_url, referrer_name)
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
  def getToolsTransactional_email( email_id, destination_email, email_supplier)
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
  def postToolsUpload( filedata)
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
  def getToolsUrl_details( url, max_redirects)
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
  def getToolsValidate_email( email_address)
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
  def getToolsValidate_phone( phone_number, country)
    params = Hash.new
    params['phone_number'] = phone_number
    params['country'] = country
    return doCurl("get","/tools/validate_phone",params)
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
  def postTraction( traction_id, trigger_type, action_type, country, email_addresses, title, body, api_method, api_url, api_params, active, reseller_masheryid, publisher_masheryid, description)
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
  def getTractionActive()
    params = Hash.new
    return doCurl("get","/traction/active",params)
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
  # Update user based on email address or social_network/social_network_id
  #
  #  @param email
  #  @param user_id
  #  @param first_name
  #  @param last_name
  #  @param active
  #  @param trust
  #  @param creation_date
  #  @param user_type
  #  @param social_network
  #  @param social_network_id
  #  @param reseller_admin_masheryid
  #  @param group_id
  #  @param admin_upgrader
  #  @return - the data from the api
  #
  def postUser( email, user_id, first_name, last_name, active, trust, creation_date, user_type, social_network, social_network_id, reseller_admin_masheryid, group_id, admin_upgrader)
    params = Hash.new
    params['email'] = email
    params['user_id'] = user_id
    params['first_name'] = first_name
    params['last_name'] = last_name
    params['active'] = active
    params['trust'] = trust
    params['creation_date'] = creation_date
    params['user_type'] = user_type
    params['social_network'] = social_network
    params['social_network_id'] = social_network_id
    params['reseller_admin_masheryid'] = reseller_admin_masheryid
    params['group_id'] = group_id
    params['admin_upgrader'] = admin_upgrader
    return doCurl("post","/user",params)
  end


  #
  # Is this user allowed to edit this entity
  #
  #  @param entity_id
  #  @param user_id
  #  @return - the data from the api
  #
  def getUserAllowed_to_edit( entity_id, user_id)
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
  def getUserBy_email( email)
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
  def getUserBy_groupid( group_id)
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
  def getUserBy_reseller_admin_masheryid( reseller_admin_masheryid)
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
  def getUserBy_social_media( name, id)
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
  def postUserDowngrade( user_id, user_type)
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
  def postUserGroup_admin_remove( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("post","/user/group_admin_remove",params)
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
  # Deletes a specific social network from a user
  #
  #  @param user_id
  #  @param social_network
  #  @return - the data from the api
  #
  def deleteUserSocial_network( user_id, social_network)
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
  def getViewhelper( database, designdoc, view, doc)
    params = Hash.new
    params['database'] = database
    params['designdoc'] = designdoc
    params['view'] = view
    params['doc'] = doc
    return doCurl("get","/viewhelper",params)
  end


end

