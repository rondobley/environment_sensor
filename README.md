# SensorHub

This is a project I did to learn some functional programming. I wanted to track the 
temperature in two places, and I came across Build a Weather Station with
Elixir and Nerves: Visualize Your Sensor Data with Phoenix and Grafana 1st Edition
by Alexander Koutmos, Bruce Tate, Frank Hunleth. I figure this would be a good projet 
to kill birds with one stone.

The book was useful, but my end result is quite different as I had different needs. I
did not need all the sensors, just the BMP280s. Also, I want to have two BMP280s on 
the same bus. Additionally, I did not write the code the receives the data in Exlir, 
I wrote that in Go. See [https://github.com/rondobley/environment-sensor-receiver](https://github.com/rondobley/environment-sensor-receiver).

Deviating from the book brought some challenges, but that made it an overall learning
experience as I had to dig around to figure out solutions that met my requirements.
In particular, I had to figure out how to get two BMP280 sensors running on the same bus
with a supervisor. I am sure that code could be improved.

The code is in two parts. One is the sensor hub code, which runs the sensors and allows for
them to be read. The other is the publisher which reads the sensors every 10 seconds
and post the data in JSON format to the receiver. 

Overall, this is not anything near production quality code, just a home project. Maybe
someone else will find something useful here, but at least I learned something. 
