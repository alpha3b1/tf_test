from flask import Flask, render_template
import boto3
import os

app = Flask(__name__)
s3_bucket_name=os.environ['S3_BUCKET_NAME']
app.config['UPLOAD_FOLDER'] = os.path.join('static')

s3_client = boto3.client('s3')
#s3_bucket_name = 'pyxis-test-ig'

s3_client.download_file(s3_bucket_name, 'image.png', 'static/image.png')

img_png = os.path.join(app.config['UPLOAD_FOLDER'], 'image.png')

@app.route('/')
def hello():
    return render_template('index.html', user_image=img_png)
