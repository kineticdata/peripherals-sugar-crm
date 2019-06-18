module SugarCRM
  class LoginError < RuntimeError; end
  class EmptyResponse < RuntimeError; end
  class UnhandledResponse < RuntimeError; end
  class InvalidSugarCRMUrl < RuntimeError; end
  class InvalidRequest < RuntimeError; end
  class InvalidModule <RuntimeError; end
  class AttributeParsingError < RuntimeError; end
  class RecordNotFound < RuntimeError; end
  class InvalidRecord < RuntimeError; end
  class RecordSaveFailed < RuntimeError; end
  class AssociationFailed < RuntimeError; end
  class UninitializedModule < RuntimeError; end
  class InvalidAttribute < RuntimeError; end
  class InvalidAttributeType < RuntimeError; end
  class InvalidAssociation < RuntimeError; end
end