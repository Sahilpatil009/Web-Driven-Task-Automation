@echo off
REM Setup script for EDI Project development environment (Windows)

echo 🚀 Setting up EDI Project development environment...

REM Check prerequisites
echo ✅ Checking prerequisites...

REM Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js 18+ first.
    exit /b 1
)

REM Check Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker first.
    exit /b 1
)

REM Check Docker Compose
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    exit /b 1
)

echo ✅ All prerequisites met!

REM Install root dependencies
echo 📦 Installing root dependencies...
call npm install

REM Install workspace dependencies
echo 📦 Installing frontend dependencies...
cd frontend && call npm install && cd ..

echo 📦 Installing backend dependencies...
cd backend && call npm install && cd ..

echo 📦 Installing CLI dependencies...
cd cli && call npm install && cd ..

REM Setup environment files
echo 🔧 Setting up environment files...

if not exist .env (
    if exist .env.example (
        copy .env.example .env
        echo ✅ Created .env from .env.example
    ) else (
        echo ⚠️  No .env.example found, creating basic .env
        (
            echo NODE_ENV=development
            echo DATABASE_URL=postgresql://postgres:password@localhost:5432/edi_dev
            echo REDIS_URL=redis://localhost:6379
            echo JWT_SECRET=your-jwt-secret-change-in-production
        ) > .env
    )
) else (
    echo ✅ .env already exists
)

if not exist frontend\.env.local (
    (
        echo NEXT_PUBLIC_API_URL=http://localhost:8000/api
        echo NEXT_PUBLIC_APP_URL=http://localhost:3000
    ) > frontend\.env.local
    echo ✅ Created frontend/.env.local
) else (
    echo ✅ frontend/.env.local already exists
)

if not exist backend\.env (
    (
        echo NODE_ENV=development
        echo PORT=8000
        echo DATABASE_URL=postgresql://postgres:password@localhost:5432/edi_dev
        echo REDIS_URL=redis://localhost:6379
        echo JWT_SECRET=your-jwt-secret-change-in-production
    ) > backend\.env
    echo ✅ Created backend/.env
) else (
    echo ✅ backend/.env already exists
)

REM Setup Git hooks
echo 🔗 Setting up Git hooks...
call npm run prepare

REM Start development services
echo 🐳 Starting development services...
call docker-compose up -d postgres redis

REM Wait for services to be ready
echo ⏳ Waiting for services to be ready...
timeout /t 10 /nobreak >nul

echo.
echo 🎉 Setup complete!
echo.
echo 📋 Next steps:
echo    1. Start the development servers:
echo       npm run dev
echo.
echo    2. Open your browser:
echo       Frontend: http://localhost:3000
echo       Backend API: http://localhost:8000
echo       PgAdmin: http://localhost:5050 (admin@edi-project.com / admin)
echo.
echo    3. Start coding! 🚀
echo.
