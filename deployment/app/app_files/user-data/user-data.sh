#!/bin/bash
#Setting up CloudWatch Logging
sudo mkdir -p /var/awslogs/
sudo mkdir -p /var/awslogs/state/
#Setting up Custom Metrics
sudo -s
cd /etc/awslogs || exit
sudo curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
sudo unzip CloudWatchMonitoringScripts-1.2.1.zip
sudo rm CloudWatchMonitoringScripts-1.2.1.zip

cp /tmp/awscreds.conf /etc/awslogs
cp /tmp/awscli.conf /etc/awslogs
cp /tmp/awscreds.conf /etc/awslogs/aws-scripts-mon/
cp /tmp/awscli.conf /etc/awslogs/aws-scripts-mon/
# Monitor memory usage and disk usage
echo "*/5 * * * * /etc/awslogs/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --disk-space-util --disk-path=/ --from-cron" | sudo tee -a /var/spool/cron/root
sudo service awslogs start
# Setting Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
#Cleaning logs
echo "0 0 * * * find /var/log -mtime +7 -delete" >> /var/spool/cron/root

# Setup directories for artifact to be fetched from S3.
sudo mkdir -p /web/uncompressed
sudo mkdir -p /code
# shellcheck disable=SC2154
aws s3 cp "${file}" /web/source.tar.gz
sudo tar -xzf /web/source.tar.gz -C /web/uncompressed/
sudo mv /web/uncompressed/app/* /code/
sudo chown -R apache:apache /code
# Setup nginx configuration
sudo cp -f /code/config/nginx/nginx.conf /etc/nginx/.
# Setup php-fpm configuration
echo "env[APP_ENV] = 'prod'" >> /etc/php-fpm-7.1.d/www.conf
sudo service php-fpm restart
sudo service nginx restart