# Contributing to EDI Project

First off, thank you for considering contributing to the EDI Project! It's people like you that make this project a great tool for the community.

## 🚀 Quick Start

1. Fork the repository
2. Clone your fork locally
3. Install dependencies: `npm install`
4. Create a feature branch: `git checkout -b feature/amazing-feature`
5. Make your changes
6. Run tests: `npm test`
7. Commit your changes: `git commit -m 'Add some amazing feature'`
8. Push to the branch: `git push origin feature/amazing-feature`
9. Open a Pull Request

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 🛠 Getting Started

### Prerequisites

- Node.js 18.x or higher
- Python 3.9 or higher
- Docker and Docker Compose
- Git

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/edi-project.git
   cd edi-project
   ```

2. **Install dependencies**
   ```bash
   npm install
   cd frontend && npm install && cd ..
   cd backend && npm install && cd ..
   cd cli && npm install && cd ..
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   cp frontend/.env.example frontend/.env.local
   cp backend/.env.example backend/.env
   ```

4. **Start development services**
   ```bash
   docker-compose up -d postgres redis
   npm run dev
   ```

## 🔄 Development Workflow

### Branch Naming Convention

- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test improvements

### Commit Message Format

We follow the [Conventional Commits](https://conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

#### Examples:
```
feat(auth): add OAuth 2.0 integration
fix(api): resolve null pointer exception in user service
docs(readme): update installation instructions
test(frontend): add unit tests for user component
```

## 🎨 Coding Standards

### JavaScript/TypeScript

- Use **ESLint** and **Prettier** for code formatting
- Follow **Airbnb JavaScript Style Guide**
- Prefer `const` over `let`, avoid `var`
- Use meaningful variable and function names
- Write JSDoc comments for complex functions

```javascript
/**
 * Transforms EDI data to JSON format
 * @param {string} ediData - Raw EDI data string
 * @param {Object} options - Transformation options
 * @returns {Object} Transformed JSON data
 */
const transformEdiToJson = (ediData, options = {}) => {
  // Implementation
};
```

### Python

- Follow **PEP 8** style guide
- Use **Black** for code formatting
- Use **type hints** for function parameters and return values
- Write **docstrings** for all public functions and classes

```python
def transform_edi_to_json(edi_data: str, options: dict = None) -> dict:
    """
    Transform EDI data to JSON format.
    
    Args:
        edi_data: Raw EDI data string
        options: Transformation options (default: None)
        
    Returns:
        Transformed JSON data as dictionary
    """
    # Implementation
```

### General Guidelines

- **DRY**: Don't Repeat Yourself
- **SOLID**: Follow SOLID principles
- **KISS**: Keep It Simple, Stupid
- Write self-documenting code
- Prefer composition over inheritance
- Use meaningful names for variables, functions, and classes

## 🧪 Testing

### Testing Strategy

- **Unit Tests**: Test individual functions and components
- **Integration Tests**: Test component interactions
- **E2E Tests**: Test complete user workflows
- **Visual Tests**: Test UI components with Storybook

### Running Tests

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch

# Run E2E tests
npm run test:e2e
```

### Writing Tests

#### Frontend Tests (Jest + React Testing Library)

```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import { UserProfile } from './UserProfile';

describe('UserProfile', () => {
  it('should display user information', () => {
    const user = { name: 'John Doe', email: 'john@example.com' };
    render(<UserProfile user={user} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });
});
```

#### Backend Tests (Jest/Pytest)

```javascript
// Node.js/Jest
describe('User Service', () => {
  it('should create a new user', async () => {
    const userData = { name: 'John Doe', email: 'john@example.com' };
    const user = await userService.createUser(userData);
    
    expect(user.id).toBeDefined();
    expect(user.name).toBe(userData.name);
  });
});
```

```python
# Python/Pytest
def test_create_user():
    """Test user creation functionality."""
    user_data = {"name": "John Doe", "email": "john@example.com"}
    user = user_service.create_user(user_data)
    
    assert user.id is not None
    assert user.name == user_data["name"]
```

## 📚 Documentation

### Code Documentation

- Write clear and concise comments
- Document complex algorithms and business logic
- Keep comments up-to-date with code changes
- Use JSDoc/Sphinx for API documentation

### README Updates

- Update README.md for significant feature additions
- Include examples and usage instructions
- Update installation and setup instructions
- Add or update badges for build status, coverage, etc.

### API Documentation

- Document all API endpoints
- Include request/response examples
- Document error responses
- Use OpenAPI/Swagger specifications

## 🔄 Pull Request Process

### Before Submitting

1. **Run the full test suite**
   ```bash
   npm run test:all
   npm run lint
   npm run build
   ```

2. **Update documentation** if needed

3. **Add tests** for new functionality

4. **Check code coverage** hasn't decreased significantly

### PR Guidelines

1. **Clear Title**: Use descriptive title following conventional commits
2. **Description**: Explain what changes were made and why
3. **Screenshots**: Include screenshots for UI changes
4. **Breaking Changes**: Document any breaking changes
5. **Testing**: Describe how the changes were tested

### PR Template

```markdown
## Description
Brief description of the changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] E2E tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

### Review Process

1. **Automated Checks**: All CI checks must pass
2. **Code Review**: At least one approved review required
3. **Testing**: Manual testing by reviewers when applicable
4. **Documentation**: Review of documentation updates

## 🚀 Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Steps

1. **Update Version**: Update version in `package.json`
2. **Update Changelog**: Document changes in `CHANGELOG.md`
3. **Create Tag**: `git tag v1.0.0`
4. **Push Tag**: `git push origin v1.0.0`
5. **GitHub Release**: Automated via GitHub Actions

## 🤝 Getting Help

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and discussions
- **Discord/Slack**: Real-time chat (if available)

### Mentorship

New contributors are welcome! Look for issues labeled `good first issue` or `help wanted`.

## 🎯 Project Roadmap

Check our [project roadmap](https://github.com/yourusername/edi-project/projects) to see what we're working on and how you can help.

## 🙏 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Annual contributor highlights

---

Thank you for contributing to the EDI Project! 🎉
