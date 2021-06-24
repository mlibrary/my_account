class InterlibraryLoanItem < Item
  def initialize(parsed_response)
    super
    @title = @parsed_response["LoanTitle"] || ""
    @author = @parsed_response["LoanAuthor"] || ""
    @description = ""
  end
  def illiad_id
    @parsed_response["TransactionNumber"]
  end
  def illiad_url(action, form, type = false)
    "https://ill.lib.umich.edu/illiad/illiad.dll?Action=#{action}&#{type ? "Type" : "Form"}=#{form}&Value=#{self.illiad_id}"
  end
  def url 
    url_transaction
  end
  def url_transaction
    self.illiad_url(10, 72)
  end
  def url_cancel_request
    self.illiad_url(21, 10, true)
  end
  def url_request_renewal
    self.illiad_url(11, 71)
  end
  def creation_date
    @parsed_response["CreationDate"] ? DateTime.patron_format(@parsed_response["CreationDate"]) : ''
  end
  def expiration_date
    @parsed_response["DueDate"] ? DateTime.patron_format(@parsed_response["DueDate"]) : ''
  end
  def due_status
    LoanDate.parse(@parsed_response["DueDate"]).due_status
  end
  def transaction_date
    @parsed_response["TransactionDate"] ? DateTime.patron_format(@parsed_response["TransactionDate"]) : ''
  end
  def renewable?
    @parsed_response["RenewalsAllowed"]
  end
end
