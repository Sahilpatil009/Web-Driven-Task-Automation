#!/bin/bash

# Setup script for EDI Project development environment

set -e

echo "🚀 Setting up EDI Project development environment..."

# Check prerequisites
echo "✅ Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2)
if [[ $(echo "$NODE_VERSION 18.0.0" | tr ' ' '\n' | sort -V | head -n1) != "18.0.0" ]]; then
    echo "❌ Node.js version must be 18.0.0 or higher. Current: $NODE_VERSION"
    exit 1
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ All prerequisites met!"

# Install root dependencies
echo "📦 Installing root dependencies..."
npm install

# Install workspace dependencies
echo "📦 Installing frontend dependencies..."
cd frontend && npm install && cd ..

echo "📦 Installing backend dependencies..."
cd backend && npm install && cd ..

echo "📦 Installing CLI dependencies..."
cd cli && npm install && cd ..

# Setup environment files
echo "🔧 Setting up environment files..."

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ Created .env from .env.example"
    else
        echo "⚠️  No .env.example found, creating basic .env"
        cat > .env << EOF
NODE_ENV=development
DATABASE_URL=postgresql://postgres:password@localhost:5432/edi_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-jwt-secret-change-in-production
EOF
    fi
else
    echo "✅ .env already exists"
fi

if [ ! -f frontend/.env.local ]; then
    cat > frontend/.env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:8000/api
NEXT_PUBLIC_APP_URL=http://localhost:3000
EOF
    echo "✅ Created frontend/.env.local"
else
    echo "✅ frontend/.env.local already exists"
fi

if [ ! -f backend/.env ]; then
    cat > backend/.env << EOF
NODE_ENV=development
PORT=8000
DATABASE_URL=postgresql://postgres:password@localhost:5432/edi_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-jwt-secret-change-in-production
EOF
    echo "✅ Created backend/.env"
else
    echo "✅ backend/.env already exists"
fi

# Setup Git hooks
echo "🔗 Setting up Git hooks..."
npm run prepare

# Start development services
echo "🐳 Starting development services..."
docker-compose up -d postgres redis

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Run initial setup (migrations, etc.)
echo "🗄️  Running database setup..."
# Add database migration commands here when available

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Start the development servers:"
echo "      npm run dev"
echo ""
echo "   2. Open your browser:"
echo "      Frontend: http://localhost:3000"
echo "      Backend API: http://localhost:8000"
echo "      PgAdmin: http://localhost:5050 (admin@edi-project.com / admin)"
echo ""
echo "   3. Start coding! 🚀"
echo ""
