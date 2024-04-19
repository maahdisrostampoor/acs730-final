#!/bin/bash
yum -y update
yum -y install httpd
# Get the instance ID
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Get the environment variable from the instance tags
availaibility_zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

<!DOCTYPE html>
<html>
<head>
    <title>Team Page</title>
    <style>
        /* CSS style for the random color */
        .random-color {
            display: block;
            /* Set a minimum width to ensure each name gets its own line */
            min-width: 100px;
            font-size: 36px; 
        }
    </style>
</head>
<body>
    <h1>Welcome to Group2 Web Page! My instance id is $instance_id in $availaibility_zone availaibility_zone</h1>
    <div class='team-members'>
        <p class='random-color'>1- Bilal Hassan</p>
        <p class='random-color'>2- Mahdis Rostampoor</p>
        <p class='random-color'>3- Ruhail Hamza Mohamed</p>
        <p class='random-color'>4- Sameer MD</p>
    </div>
    <script>
        // JavaScript to apply random color to each <li> element
        var names = document.getElementsByClassName('random-color');

        for (var i = 0; i < names.length; i++) {
            var randomColor = '#' + Math.floor(Math.random() * 16777215).toString(16); // Generate random hex color
            names[i].style.color = randomColor; // Apply the color
        }
    </script>
</body>
</html>
 > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
