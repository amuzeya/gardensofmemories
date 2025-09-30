#!/bin/bash

# YSL Beauty Experience - Deployment Script
# Deploy to gcloud-allan server at gardensofmemories.landng.com

set -e

echo "🚀 Starting deployment of YSL Beauty Experience..."

# Configuration
SERVER="gcloud-allan"

DOMAIN="gardensofmemories.landng.com"
WEB_ROOT="/var/www/$DOMAIN"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN.conf"
BUILD_DIR="build/web"

echo "📋 Configuration:"
echo "  Server: $SERVER"
echo "  Domain: $DOMAIN"
echo "  Web Root: $WEB_ROOT"
echo "  Build Directory: $BUILD_DIR"
echo ""

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Build directory not found: $BUILD_DIR"
    echo "Please run 'flutter build web --release' first"
    exit 1
fi

echo "📦 Creating deployment archive..."
cd build/web
tar -czf ../../ysl-beauty-web.tar.gz .
cd ../..

echo "🔗 Connecting to server and setting up deployment..."

ssh $SERVER << 'EOF'
    echo "🏗️  Setting up directory structure on server..."
    
    # Create web root directory
    sudo mkdir -p /var/www/gardensofmemories.landng.com
    sudo chown -R www-data:www-data /var/www/gardensofmemories.landng.com
    sudo chmod -R 755 /var/www/gardensofmemories.landng.com
    
    echo "✅ Directory structure created"
EOF

echo "📤 Uploading web files to server..."
scp ysl-beauty-web.tar.gz $SERVER:~/

echo "📥 Extracting files on server..."
ssh $SERVER << 'EOF'
    echo "📂 Extracting web files..."
    cd /tmp
    sudo tar -xzf ~/ysl-beauty-web.tar.gz -C /var/www/gardensofmemories.landng.com/
    sudo chown -R www-data:www-data /var/www/gardensofmemories.landng.com
    sudo chmod -R 755 /var/www/gardensofmemories.landng.com
    rm ~/ysl-beauty-web.tar.gz
    
    echo "✅ Web files extracted and permissions set"
EOF

echo "📤 Uploading nginx configuration..."
scp gardensofmemories.landng.com.conf $SERVER:~/

echo "⚙️  Setting up nginx configuration..."
ssh $SERVER << 'EOF'
    echo "🔧 Installing nginx configuration..."
    sudo cp ~/gardensofmemories.landng.com.conf /etc/nginx/sites-available/gardensofmemories.landng.com.conf
    sudo rm ~/gardensofmemories.landng.com.conf
    
    # Enable the site
    sudo ln -sf /etc/nginx/sites-available/gardensofmemories.landng.com.conf /etc/nginx/sites-enabled/
    
    # Test nginx configuration
    echo "🧪 Testing nginx configuration..."
    sudo nginx -t
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx configuration is valid"
        echo "🔄 Reloading nginx..."
        sudo systemctl reload nginx
        echo "✅ Nginx reloaded successfully"
    else
        echo "❌ Nginx configuration test failed"
        exit 1
    fi
EOF

echo "🔒 Setting up SSL certificate with Let's Encrypt..."
ssh $SERVER << 'EOF'
    echo "📜 Installing SSL certificate..."
    
    # Install certbot if not already installed
    if ! command -v certbot &> /dev/null; then
        echo "📦 Installing certbot..."
        sudo apt update
        sudo apt install -y certbot python3-certbot-nginx
    fi
    
    # Obtain SSL certificate
    echo "🔐 Obtaining SSL certificate for gardensofmemories.landng.com..."
    sudo certbot --nginx -d gardensofmemories.landng.com --non-interactive --agree-tos --email webmaster@landng.com --redirect
    
    if [ $? -eq 0 ]; then
        echo "✅ SSL certificate installed successfully"
        echo "🔄 Reloading nginx with SSL configuration..."
        sudo systemctl reload nginx
        echo "✅ Deployment completed successfully!"
    else
        echo "❌ SSL certificate installation failed"
        echo "⚠️  Site is accessible via HTTP only"
    fi
EOF

# Clean up local files
echo "🧹 Cleaning up..."
rm ysl-beauty-web.tar.gz

echo ""
echo "🎉 Deployment Complete!"
echo "🌐 Your YSL Beauty Experience app is now available at:"
echo "   HTTP:  http://gardensofmemories.landng.com"
echo "   HTTPS: https://gardensofmemories.landng.com"
echo ""
echo "📊 Next steps:"
echo "  1. Test the application in your browser"
echo "  2. Verify SSL certificate is working"
echo "  3. Check nginx logs if needed: sudo tail -f /var/log/nginx/gardensofmemories.landng.com_*.log"
echo ""