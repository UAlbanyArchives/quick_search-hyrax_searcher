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

        @response['response']['docs'].each do |value|
          result = OpenStruct.new
          result.title = value['title_tesim'][0]
          result.link = link_builder(value)
          if value.key?('date_created_tesim')
            result.date = value['date_created_tesim'][0]
          end
          if value.key?('resource_type_tesim')
            result.format = value['resource_type_tesim'][0]
          end
          if value.key?('thumbnail_path_ss')
            result.thumbnail = URI::join(base_url, value['thumbnail_path_ss']).to_s
          end
          if value.key?('collection_tesim')
            result.collection = [value['collection_tesim'][0], collection_builder(value['collection_number_tesim'][0]).to_s]
          end
          
          if value.key?('collecting_area_tesim')
            result.collecting_area = value['collecting_area_tesim'][0]
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
      link = URI::join(base_url, +"/concern/" + value['has_model_ssim'][0].downcase + "s/" + value['id']).to_s

      link
    end

    def collection_builder(uri)
      collection_link = URI::join("https://archives.albany.edu/description/catalog/" + uri.tr(".", "-"))

      collection_link
    end

    def total
      @response['response']['pages']['total_count'].to_i
    end

    def loaded_link
      "https://archives.albany.edu/catalog?search_field=all_fields&q=" + http_request_queries['not_escaped']
    end

  end
end
