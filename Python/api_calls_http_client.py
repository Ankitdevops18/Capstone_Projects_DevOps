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
  