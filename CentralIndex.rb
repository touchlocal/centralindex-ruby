require 'net/http'

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
    return retval.body
  end


  def getStatus()
    params = Hash.new
    return doCurl("get","/status",params)
  end


  def getLogo( a, b, c, d)
    params = Hash.new
    params['a'] = a
    params['b'] = b
    params['c'] = c
    params['d'] = d
    return doCurl("get","/logo",params)
  end


  def putLogo( a)
    params = Hash.new
    params['a'] = a
    return doCurl("put","/logo",params)
  end


  def postEntityBulkCsv( filedata)
    params = Hash.new
    params['filedata'] = filedata
    return doCurl("post","/entity/bulk/csv",params)
  end


  def getEntityBulkCsvStatus( upload_id)
    params = Hash.new
    params['upload_id'] = upload_id
    return doCurl("get","/entity/bulk/csv/status",params)
  end


  def putEntity( type, scope, country, trust, our_data)
    params = Hash.new
    params['type'] = type
    params['scope'] = scope
    params['country'] = country
    params['trust'] = trust
    params['our_data'] = our_data
    return doCurl("put","/entity",params)
  end


  def getEntityBy_supplier_id( supplier_id)
    params = Hash.new
    params['supplier_id'] = supplier_id
    return doCurl("get","/entity/by_supplier_id",params)
  end


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


  def getEntitySearchWhoBylocation( who, where, per_page, page, country)
    params = Hash.new
    params['who'] = who
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    return doCurl("get","/entity/search/who/bylocation",params)
  end


  def getEntitySearchWhat( what, per_page, page, country, language)
    params = Hash.new
    params['what'] = what
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/what",params)
  end


  def getEntitySearchWho( who, per_page, page, country)
    params = Hash.new
    params['who'] = who
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    return doCurl("get","/entity/search/who",params)
  end


  def getEntitySearchBylocation( where, per_page, page, country, language)
    params = Hash.new
    params['where'] = where
    params['per_page'] = per_page
    params['page'] = page
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/search/bylocation",params)
  end


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


  def getEntityAdvertisers( tag, where, limit, country, language)
    params = Hash.new
    params['tag'] = tag
    params['where'] = where
    params['limit'] = limit
    params['country'] = country
    params['language'] = language
    return doCurl("get","/entity/advertisers",params)
  end


  def getEntity( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity",params)
  end


  def getEntityBy_user_id( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/entity/by_user_id",params)
  end


  def getEntityRevisions( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity/revisions",params)
  end


  def getEntityRevisionsByRevisionID( entity_id, revision_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['revision_id'] = revision_id
    return doCurl("get","/entity/revisions/byRevisionID",params)
  end


  def postEntityUnmerge( entity_id, supplier_masheryid, supplier_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['supplier_masheryid'] = supplier_masheryid
    params['supplier_id'] = supplier_id
    return doCurl("post","/entity/unmerge",params)
  end


  def getEntityChangelog( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("get","/entity/changelog",params)
  end


  def postEntityMerge( from, to)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    return doCurl("post","/entity/merge",params)
  end


  def getToolsReindex()
    params = Hash.new
    return doCurl("get","/tools/reindex",params)
  end


  def getEntityReport( entity_id, gen_id, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    params['language'] = language
    return doCurl("get","/entity/report",params)
  end


  def getToolsDecodereport( token)
    params = Hash.new
    params['token'] = token
    return doCurl("get","/tools/decodereport",params)
  end


  def postEntityMigrate_category( from, to, limit)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    params['limit'] = limit
    return doCurl("post","/entity/migrate_category",params)
  end


  def putBusiness( name, address1, address2, address3, district, town, county, postcode, country, latitude, longitude, timezone, telephone_number, telephone_type, email, website, category_id, category_name)
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
    params['telephone_type'] = telephone_type
    params['email'] = email
    params['website'] = website
    params['category_id'] = category_id
    params['category_name'] = category_name
    return doCurl("put","/business",params)
  end


  def getEntityAdd( language)
    params = Hash.new
    params['language'] = language
    return doCurl("get","/entity/add",params)
  end


  def getLookupLocation( string, country)
    params = Hash.new
    params['string'] = string
    params['country'] = country
    return doCurl("get","/lookup/location",params)
  end


  def getLookupCategory( string, language)
    params = Hash.new
    params['string'] = string
    params['language'] = language
    return doCurl("get","/lookup/category",params)
  end


  def getLookupLegacyCategory( id, type)
    params = Hash.new
    params['id'] = id
    params['type'] = type
    return doCurl("get","/lookup/legacy/category",params)
  end


  def postEntityName( entity_id, name, formal_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['name'] = name
    params['formal_name'] = formal_name
    return doCurl("post","/entity/name",params)
  end


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


  def deleteEntityEmployee( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/employee",params)
  end


  def postEntityPhone( entity_id, number, description, premium_rate, telephone_type, tps, ctps)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
    params['description'] = description
    params['premium_rate'] = premium_rate
    params['telephone_type'] = telephone_type
    params['tps'] = tps
    params['ctps'] = ctps
    return doCurl("post","/entity/phone",params)
  end


  def deleteEntityPhone( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/phone",params)
  end


  def postEntityFax( entity_id, number, description, premium_rate)
    params = Hash.new
    params['entity_id'] = entity_id
    params['number'] = number
    params['description'] = description
    params['premium_rate'] = premium_rate
    return doCurl("post","/entity/fax",params)
  end


  def deleteEntityFax( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/fax",params)
  end


  def putCategory( category_id, language, name)
    params = Hash.new
    params['category_id'] = category_id
    params['language'] = language
    params['name'] = name
    return doCurl("put","/category",params)
  end


  def postCategoryMappings( category_id, type, id, name)
    params = Hash.new
    params['category_id'] = category_id
    params['type'] = type
    params['id'] = id
    params['name'] = name
    return doCurl("post","/category/mappings",params)
  end


  def postCategorySynonym( category_id, synonym, language)
    params = Hash.new
    params['category_id'] = category_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("post","/category/synonym",params)
  end


  def deleteCategorySynonym( category_id, synonym, language)
    params = Hash.new
    params['category_id'] = category_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("delete","/category/synonym",params)
  end


  def postCategoryMerge( from, to)
    params = Hash.new
    params['from'] = from
    params['to'] = to
    return doCurl("post","/category/merge",params)
  end


  def postEntityCategory( entity_id, category_id, category_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['category_id'] = category_id
    params['category_name'] = category_name
    return doCurl("post","/entity/category",params)
  end


  def deleteEntityCategory( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/category",params)
  end


  def postEntityGeopoint( entity_id, longitude, latitude, accuracy)
    params = Hash.new
    params['entity_id'] = entity_id
    params['longitude'] = longitude
    params['latitude'] = latitude
    params['accuracy'] = accuracy
    return doCurl("post","/entity/geopoint",params)
  end


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


  def getMatchBylocation( company_name, latitude, longitude, name_strictness, location_strictness)
    params = Hash.new
    params['company_name'] = company_name
    params['latitude'] = latitude
    params['longitude'] = longitude
    params['name_strictness'] = name_strictness
    params['location_strictness'] = location_strictness
    return doCurl("get","/match/bylocation",params)
  end


  def getToolsStopwords( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/stopwords",params)
  end


  def getToolsStem( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/stem",params)
  end


  def getToolsPhonetic( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/phonetic",params)
  end


  def getToolsProcess_string( text)
    params = Hash.new
    params['text'] = text
    return doCurl("get","/tools/process_string",params)
  end


  def getToolsProcess_phone( number)
    params = Hash.new
    params['number'] = number
    return doCurl("get","/tools/process_phone",params)
  end


  def getToolsSpider( url)
    params = Hash.new
    params['url'] = url
    return doCurl("get","/tools/spider",params)
  end


  def getToolsGeocode( address)
    params = Hash.new
    params['address'] = address
    return doCurl("get","/tools/geocode",params)
  end


  def getToolsIodocs( mode, path, endpoint, doctype)
    params = Hash.new
    params['mode'] = mode
    params['path'] = path
    params['endpoint'] = endpoint
    params['doctype'] = doctype
    return doCurl("get","/tools/iodocs",params)
  end


  def getToolsDocs( object, format)
    params = Hash.new
    params['object'] = object
    params['format'] = format
    return doCurl("get","/tools/docs",params)
  end


  def getToolsFormatPhone( number, country)
    params = Hash.new
    params['number'] = number
    params['country'] = country
    return doCurl("get","/tools/format/phone",params)
  end


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


  def deleteEntityInvoice_address( entity_id)
    params = Hash.new
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/invoice_address",params)
  end


  def postEntityTag( entity_id, tag, language)
    params = Hash.new
    params['entity_id'] = entity_id
    params['tag'] = tag
    params['language'] = language
    return doCurl("post","/entity/tag",params)
  end


  def deleteEntityTag( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/tag",params)
  end


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


  def deleteEntityAdvertiser( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/advertiser",params)
  end


  def postEntityEmail( entity_id, email_address, email_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['email_address'] = email_address
    params['email_description'] = email_description
    return doCurl("post","/entity/email",params)
  end


  def deleteEntityEmail( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/email",params)
  end


  def postEntityWebsite( entity_id, website_url, display_url, website_description)
    params = Hash.new
    params['entity_id'] = entity_id
    params['website_url'] = website_url
    params['display_url'] = display_url
    params['website_description'] = website_description
    return doCurl("post","/entity/website",params)
  end


  def deleteEntityWebsite( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/website",params)
  end


  def postEntityImage( entity_id, filedata, image_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['filedata'] = filedata
    params['image_name'] = image_name
    return doCurl("post","/entity/image",params)
  end


  def deleteEntityImage( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/image",params)
  end


  def getLocation( location_id)
    params = Hash.new
    params['location_id'] = location_id
    return doCurl("get","/location",params)
  end


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


  def postLocationSynonym( location_id, synonym, language)
    params = Hash.new
    params['location_id'] = location_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("post","/location/synonym",params)
  end


  def deleteLocationSynonym( location_id, synonym, language)
    params = Hash.new
    params['location_id'] = location_id
    params['synonym'] = synonym
    params['language'] = language
    return doCurl("delete","/location/synonym",params)
  end


  def postLocationSource( location_id, type, url, ref)
    params = Hash.new
    params['location_id'] = location_id
    params['type'] = type
    params['url'] = url
    params['ref'] = ref
    return doCurl("post","/location/source",params)
  end


  def postEntityStatus( entity_id, status)
    params = Hash.new
    params['entity_id'] = entity_id
    params['status'] = status
    return doCurl("post","/entity/status",params)
  end


  def postEntityLogo( entity_id, filedata, logo_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['filedata'] = filedata
    params['logo_name'] = logo_name
    return doCurl("post","/entity/logo",params)
  end


  def deleteEntityLogo( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/logo",params)
  end


  def postEntityVideo( entity_id, title, description, thumbnail, embed_code)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['description'] = description
    params['thumbnail'] = thumbnail
    params['embed_code'] = embed_code
    return doCurl("post","/entity/video",params)
  end


  def deleteEntityVideo( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/video",params)
  end


  def postEntityAffiliate_link( entity_id, affiliate_name, affiliate_link, affiliate_message, affiliate_logo)
    params = Hash.new
    params['entity_id'] = entity_id
    params['affiliate_name'] = affiliate_name
    params['affiliate_link'] = affiliate_link
    params['affiliate_message'] = affiliate_message
    params['affiliate_logo'] = affiliate_logo
    return doCurl("post","/entity/affiliate_link",params)
  end


  def deleteEntityAffiliate_link( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/affiliate_link",params)
  end


  def postEntityDescription( entity_id, headline, body)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    return doCurl("post","/entity/description",params)
  end


  def deleteEntityDescription( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/description",params)
  end


  def postEntityList( entity_id, headline, body)
    params = Hash.new
    params['entity_id'] = entity_id
    params['headline'] = headline
    params['body'] = body
    return doCurl("post","/entity/list",params)
  end


  def deleteEntityList( gen_id, entity_id)
    params = Hash.new
    params['gen_id'] = gen_id
    params['entity_id'] = entity_id
    return doCurl("delete","/entity/list",params)
  end


  def postEntityDocument( entity_id, name, filedata)
    params = Hash.new
    params['entity_id'] = entity_id
    params['name'] = name
    params['filedata'] = filedata
    return doCurl("post","/entity/document",params)
  end


  def deleteEntityDocument( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/document",params)
  end


  def postEntityTestimonial( entity_id, title, text, date, testifier_name)
    params = Hash.new
    params['entity_id'] = entity_id
    params['title'] = title
    params['text'] = text
    params['date'] = date
    params['testifier_name'] = testifier_name
    return doCurl("post","/entity/testimonial",params)
  end


  def deleteEntityTestimonial( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/testimonial",params)
  end


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


  def deleteEntitySpecial_offer( entity_id, gen_id)
    params = Hash.new
    params['entity_id'] = entity_id
    params['gen_id'] = gen_id
    return doCurl("delete","/entity/special_offer",params)
  end


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


  def getUserBy_email( email)
    params = Hash.new
    params['email'] = email
    return doCurl("get","/user/by_email",params)
  end


  def getUser( user_id)
    params = Hash.new
    params['user_id'] = user_id
    return doCurl("get","/user",params)
  end


  def getUserBy_social_media( name, id)
    params = Hash.new
    params['name'] = name
    params['id'] = id
    return doCurl("get","/user/by_social_media",params)
  end


  def getAutocompleteCategory( str, language)
    params = Hash.new
    params['str'] = str
    params['language'] = language
    return doCurl("get","/autocomplete/category",params)
  end


  def getAutocompleteLocation( str, country)
    params = Hash.new
    params['str'] = str
    params['country'] = country
    return doCurl("get","/autocomplete/location",params)
  end


  def putQueue( queue_name, data)
    params = Hash.new
    params['queue_name'] = queue_name
    params['data'] = data
    return doCurl("put","/queue",params)
  end


  def deleteQueue( queue_id)
    params = Hash.new
    params['queue_id'] = queue_id
    return doCurl("delete","/queue",params)
  end


  def getQueue( limit, queue_name)
    params = Hash.new
    params['limit'] = limit
    params['queue_name'] = queue_name
    return doCurl("get","/queue",params)
  end


  def postQueueUnlock( queue_name, seconds)
    params = Hash.new
    params['queue_name'] = queue_name
    params['seconds'] = seconds
    return doCurl("post","/queue/unlock",params)
  end


  def postQueueError( queue_id, error)
    params = Hash.new
    params['queue_id'] = queue_id
    params['error'] = error
    return doCurl("post","/queue/error",params)
  end


  def getQueueSearch( type, id)
    params = Hash.new
    params['type'] = type
    params['id'] = id
    return doCurl("get","/queue/search",params)
  end


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


  def postTransactionInprogress( transaction_id, paypal_setexpresscheckout)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_setexpresscheckout'] = paypal_setexpresscheckout
    return doCurl("post","/transaction/inprogress",params)
  end


  def postTransactionAuthorised( transaction_id, paypal_getexpresscheckoutdetails)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_getexpresscheckoutdetails'] = paypal_getexpresscheckoutdetails
    return doCurl("post","/transaction/authorised",params)
  end


  def postTransactionComplete( transaction_id, paypal_doexpresscheckoutpayment, user_id, entity_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    params['paypal_doexpresscheckoutpayment'] = paypal_doexpresscheckoutpayment
    params['user_id'] = user_id
    params['entity_id'] = entity_id
    return doCurl("post","/transaction/complete",params)
  end


  def postTransactionCancelled( transaction_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    return doCurl("post","/transaction/cancelled",params)
  end


  def getTransaction( transaction_id)
    params = Hash.new
    params['transaction_id'] = transaction_id
    return doCurl("get","/transaction",params)
  end


  def getTransactionBy_paypal_transaction_id( paypal_transaction_id)
    params = Hash.new
    params['paypal_transaction_id'] = paypal_transaction_id
    return doCurl("get","/transaction/by_paypal_transaction_id",params)
  end


  def postEntityClaim( entity_id, claimed_user_id, claimed_date)
    params = Hash.new
    params['entity_id'] = entity_id
    params['claimed_user_id'] = claimed_user_id
    params['claimed_date'] = claimed_date
    return doCurl("post","/entity/claim",params)
  end


end

