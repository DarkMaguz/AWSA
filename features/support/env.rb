require 'rubygems'
require 'aws-sdk'
require 'aws-sdk-ec2'
require 'pp'

$accessKeyID = ENV["AWS_ID"]
$secretAccessKey = ENV["AWS_KEY"]
$region =  'eu-west-1'
