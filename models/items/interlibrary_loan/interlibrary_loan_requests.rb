class InterlibraryLoanRequests < Items
  def initialize(parsed_response:)
    super
    @items = parsed_response.map { |item| InterlibraryLoanRequest.new(item) }
  end

  def self.for(uniqname:, client: ILLiadClient.new)
    url = "/Transaction/UserRequests/#{uniqname}" 
    query = {}
    query["$filter"] = "not startswith(TransactionStatus, 'Cancelled') and not endswith(TransactionStatus, 'Finished') and TransactionStatus ne 'Delivered to Web' and TransactionStatus ne 'Checked Out to Customer'"

    response = client.get(url, query)
    if response.code == 200
      InterlibraryLoanRequests.new(parsed_response: response.parsed_response)
    else
      #Error!
    end
  end
end

class InterlibraryLoanRequest < InterlibraryLoanItem
end
