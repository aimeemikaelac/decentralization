import json

import flask
import httplib2

from apiclient import discovery
from oauth2client import client


app = flask.Flask(__name__)


@app.route('/')
def index():
  if 'credentials' not in flask.session:
    return flask.redirect(flask.url_for('oauth2callback'))
  credentials = client.OAuth2Credentials.from_json(flask.session['credentials'])
  if credentials.access_token_expired:
    return flask.redirect(flask.url_for('oauth2callback'))
  else:
    http_auth = credentials.authorize(httplib2.Http())
#    drive_service = discovery.build('drive', 'v2', http_auth)
    compute_service = discovery.build('compute', 'v1', http_auth)
#    files = drive_service.files().list().execute()
    projects = compute_service.projects().get(project='folkloric-union-98706').execute()
    return json.dumps(projects)
#    print str(projects.to_json)
#    print projects.name
#    projects_json = json.dumps(projects.to_json)
#    print projects_json
##    project = projects_json['My First Project']
#    project_names = []
#    project_ids = []
#    project_id = None
#    for proj in projects_json:
#        project_names.append(proj['name'])
#        project_ids.append(proj['id'])
#        if proj['name'] == 'My First Project':
#            project_id = proj['id']
#
#    page_text = ""
#    if project_id is not None:
#        zone = 'us-central1-f'
#        source_disk_image = "projects/debian-cloud/global/images/debian-7-wheezy-v20150320"
#        machine_type = "zones/%s/machineTypes/n1-standard-1" % zone
#        config = {
#            'name': name,
#            'machineType': machine_type,
#    
#            # Specify the boot disk and the image to use as a source.
#            'disks': [
#                {
#                    'boot': True,
#                    'autoDelete': True,
#                    'initializeParams': {
#                        'sourceImage': source_disk_image,
#                    }
#                }
#            ],
#    
#            # Specify a network interface with NAT to access the public
#            # internet.
#            'networkInterfaces': [{
#                'network': 'global/networks/default',
#                'accessConfigs': [
#                    {'type': 'ONE_TO_ONE_NAT', 'name': 'External NAT'}
#                ]
#            }],
#    
#            # Allow the instance to access cloud storage and logging.
#            'serviceAccounts': [{
#                'email': 'default',
#                'scopes': [
#                    'https://www.googleapis.com/auth/devstorage.read_write',
#                    'https://www.googleapis.com/auth/logging.write'
#                ]
#            }],
#        }
#        compute_service.instances().insert(project=project_id, zone=zone, body=config)
#    else:
#        page_text = "Could not find project ID\n"
#    project_names_str = " , ".join(project_names)
#    project_ids_str = " , ".join(project_ids)
#    page_text += project_names_str
#    page_text += "\n" + project_ids_str
##    return json.dumps(files)
#    return page_text


@app.route('/oauth2callback')
def oauth2callback():
  flow = client.flow_from_clientsecrets(
      'client_secrets.json',
      scope='https://www.googleapis.com/auth/compute',
      redirect_uri=flask.url_for('oauth2callback', _external=True))
  if 'code' not in flask.request.args:
    auth_uri = flow.step1_get_authorize_url()
    return flask.redirect(auth_uri)
  else:
    auth_code = flask.request.args.get('code')
    credentials = flow.step2_exchange(auth_code)
    flask.session['credentials'] = credentials.to_json()
    return flask.redirect(flask.url_for('index'))


if __name__ == '__main__':
  import uuid
  app.secret_key = str(uuid.uuid4())
  app.debug = True
  app.run(host='0.0.0.0')
