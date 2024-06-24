import http.client
import json
import os
import hashlib
import uuid
import mimetypes
import base64
from codecs import encode


access_token = "{{ token_reponse. json, access_token }}"
API_HOST = "{{ API host }}"

def delete_by_scope_id(access_token, scope_id):
  conn = http.client.HTTPSConnection(API_HOST)
  payload = ""
  headers = {"Authorization": "Bearer " + access_token}
  conn.request("DELETE", "/portal/asset/scope/" + scope_id, payload, headers)
  res = conn.getresponse()
  data = res.read()
  return data.decode("utf-8")


already_deleted_scopés = []

def delete_all_by_scope_id(access_token, scope_id):

 if already_deleted_scopés.count(scope_id) > 0 : 
   print ("ScopeId already deleted", scope_id)
   return
 
 result = delete_by_scope_id(access_token, scope_id)
 while result == '{"asset": {"status": true}}':
  result = delete_by_scope_id(access_token, scope_id)
 already_deleted_scopés.append (scope_id)


def add_asset( scopeId,
path,
type_
):
  print(scopeId,path,type_)

def read_file(file_path):
  return open(file_path, mode=r, encodig="utf-8").read()


def sync_asset_data():
 # APT _DIR_ FOLDER - "APIs"
 # apis_dir_names - os. listdir(APT_DIR_FOLDER)

  lang = "{{ language }}"
  LANG_DIR = "{{ base_path }}" + "/" + "{{ api_folder }}"
  OVERVIEW_DIR = LANG_DIR + "/" + "Overview"
  ATTACHMENT_DIR = LANG_DIR + "/" + "attachments"
  IMAGE_DIR = LANG_DIR + "/" + "images" 
  
  overviews = os.listdir(OVERVIEW_DIR)

  print(OVERVIEW_DIR)
  print (ATTACHMENT_DIR)
  print (IMAGE_DIR)

  # For each api with in the set, get the overview data
  for overview in overviews:
    CONTENT_SRC_PATH = OVERVIEW_DIR + "/" + overview
    print(CONTENT_SRC_PATH)
    apiSpecId = "{{ scope_id }}"
    print(apiSpecId)

  #Get Asset Type
  if ".txt" in overview :
    asset_type - "ApiOverviewParent"
  elif "specs.yaml" in overview :
    asset_type - "ApiSpec"
  elif "documentation.md" in overview :
    asset_type - "DocumentationMarkdown"
  elif "overview.md" in overview :
    asset_type - "OverviewMarkdown"
  else :
    asset_type = "APIOverview"

  #Getting File Path file_path -
  file_path = "/apis/" + "{{ api_folder }}" + "overview" + "/"+ overview



# delete_all_by_scope_id(access_token,apiSpecId)
#_add_asset (scopeld, path, type_, data, permissionType,langauge,content, assetName):


  # upload overview files
  overview_filecontent = read_file(CONTENT_SRC_PATH)

  ovparent_result = add_asset(
  apiSpecId,
  file_path,
  asset_type,
  overview_filecontent,
  "Internal",
  lang,
  overview_filecontent,
  overview
  )

  # upload all attachments get id
  if os.path.isdir(ATTACHMENT_DIR):
    attachments = os.listdir (ATTACHMENT_DIR)
    for attachment in attachments:
      attachment_file_path = ATTACHMENT_DIR + "/" + attachment
      attachment_result = add_asset(
        apiSpecId,
        "/" +"{f api_folder }}" + "/" + "attachments" + "/" + "Attachment",
        "Internal", 
        lang,
        "download-only", 
        attachment, 
        attachment_file_path,
      )

def main():
  sync_asset_data()


main()