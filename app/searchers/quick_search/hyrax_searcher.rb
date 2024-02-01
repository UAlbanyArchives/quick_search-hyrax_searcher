require 'nokogiri'

module QuickSearch
  class HyraxSearcher < QuickSearch::Searcher
    
    def search
      @http.ssl_config.verify_mode=(OpenSSL::SSL::VERIFY_NONE)
      resp = @http.get(base_url, parameters.to_query)
      @response = JSON.parse(resp.body)
    end
    
    def results
      if results_list
        results_list

      else
        @results_list = []

        #@match_fields = ['title_ssm', '']
	
        @response['data'].each do |value|
          result = OpenStruct.new
          #result.title = value['title_tesim'][0]
	  result.title = Nokogiri::HTML(value['attributes']['title']).text
          result.link = link_builder(value)
          
          if value['attributes'].key?('date_created_tesim')
            result.date = Nokogiri::HTML(value['attributes']['date_created_tesim']['attributes']['value']).text
          end
          if value['attributes'].key?('resource_type_tesim')
            result.format = Nokogiri::HTML(value['attributes']['resource_type_tesim']['attributes']['value']).text
          end
          if value['attributes'].key?('thumbnail_path_ss')
            result.thumbnail = URI::join(base_url, value['attributes']['thumbnail_path_ss']['attributes']['value']).to_s
          end
          if value['attributes'].key?('collection_tesim')
            result.collection = [Nokogiri::HTML(value['attributes']['collection_tesim']['attributes']['value']).text, collection_builder(Nokogiri::HTML(value['attributes']['collection_number_tesim']['attributes']['value']).text).to_s]
          end
          
          if value['attributes'].key?('collecting_area_tesim')
            result.collecting_area = Nokogiri::HTML(value['attributes']['collecting_area_tesim']['attributes']['value']).text
          end
          

          @results_list << result
        end

        @results_list
      end

    end
    
    def base_url
      "https://archives.albany.edu/catalog"
    end

    def parameters
      {
        'search_field' => 'all_fields',
        'q' => http_request_queries['not_escaped'],
        'utf8' => true,
        'per_page' => @per_page,
        'format' => 'json'
      }
    end

    def link_builder(value)
      link = URI::join(base_url, +"/concern/" + value['type'].downcase + "s/" + value['id']).to_s

      link
    end

    def collection_builder(uri)
      #collection_link = uri
      collection_link = URI::join("https://archives.albany.edu/description/catalog/" + uri.tr(".", "-"))

      collection_link
    end

    def total
      @response['meta']['pages']['total_count'].to_i
    end

    def loaded_link
      "https://archives.albany.edu/catalog?search_field=all_fields&q=" + http_request_queries['not_escaped']
    end

  end
end
