# CLI - Command Line Interface

This is the CLI tool for the EDI Project built with Node.js.

## Getting Started

```bash
# Install dependencies
npm install

# Link CLI globally (for development)
npm link

# Build for production
npm run build
```

## Usage

```bash
# Transform EDI file
edi-cli transform input.edi --output output.json --format json

# Validate EDI file
edi-cli validate input.edi

# Generate EDI mapping
edi-cli generate-mapping --source csv --target edi
```

## Tech Stack

- **Runtime**: Node.js 18+
- **CLI Framework**: Commander.js
- **Testing**: Jest
- **Type Checking**: TypeScript

## Scripts

- `npm run dev` - Start development with watch mode
- `npm run build` - Build TypeScript to JavaScript
- `npm run lint` - Run ESLint
- `npm run test` - Run tests
- `npm run test:coverage` - Run tests with coverage

## Commands

- `edi-cli transform` - Transform data between formats
- `edi-cli validate` - Validate EDI files
- `edi-cli generate-mapping` - Generate transformation mappings
- `edi-cli --help` - Show help information
