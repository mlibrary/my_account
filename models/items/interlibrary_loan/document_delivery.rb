class DocumentDelivery < Items
  def initialize(parsed_response:)
    super
    @items = parsed_response.map { |item| DocumentDeliveryItem.new(item) }
  end

  def self.for(uniqname:, client: ILLiadClient.new)
    url = "/Transaction/UserRequests/#{uniqname}" 
    query = {}
    query["$filter"] = "RequestType eq 'Loan' and TransactionStatus eq 'Delivered to Web'"
    
    response = client.get(url, query)
    if response.code == 200
      DocumentDelivery.new(parsed_response: response.parsed_response)
    else
      #Error!
    end
  end
end

class DocumentDeliveryItem < InterlibraryLoanItem
end
