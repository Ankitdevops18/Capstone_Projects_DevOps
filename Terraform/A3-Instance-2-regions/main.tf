provider "aws" {
  alias  = "ohio"
  region = "us-east-2"  # Ohio
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"  # N. Virginia
}