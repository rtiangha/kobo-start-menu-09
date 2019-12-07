#!/bin/sh
theurl="http://w1.weather.gov/xml/current_obs/KNYC.xml"

cd "${0%/*}"
source wget_call
