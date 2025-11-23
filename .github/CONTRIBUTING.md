# Contributing to BetaVersion

Thank you for your interest in contributing to BetaVersion! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/App.git`
3. Add upstream remote: `git remote add upstream https://github.com/betaversionio/App.git`
4. Create a new branch: `git checkout -b feature/your-feature-name`

## Development Setup

### Prerequisites

- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / Xcode (for mobile development)
- VS Code with Flutter extension (recommended)

### Installation

```bash
# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment Configuration

Copy `.env.example` to `.env` and configure your environment variables:

```bash
cp .env.example .env
```

## Development Workflow

1. **Sync with upstream**: Always sync your fork with the latest changes

   ```bash
   git fetch upstream
   git checkout dev
   git merge upstream/dev
   ```

2. **Create a feature branch**: Use descriptive names

   ```bash
   git checkout -b feature/add-login-screen
   git checkout -b fix/profile-crash
   git checkout -b refactor/api-service
   ```

3. **Make your changes**: Write clean, maintainable code

4. **Test your changes**: Run tests and manual testing

5. **Commit your changes**: Follow commit guidelines

6. **Push and create PR**: Push to your fork and create a pull request

## Coding Standards

### Dart/Flutter Best Practices

- Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Keep functions small and focused
- Write self-documenting code
- Add comments for complex logic

### Code Organization

```
lib/
├── core/           # Core functionality, utilities, constants
├── features/       # Feature-based modules
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
├── shared/         # Shared widgets and utilities
└── main.dart
```

### Formatting

- Run `dart format .` before committing
- Use 2 spaces for indentation
- Line length: 80 characters
- Run `flutter analyze` to check for issues

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private**: `_prefixWithUnderscore`

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Build system changes
- `ci`: CI/CD changes
- `chore`: Other changes that don't modify src or test files

### Examples

```bash
feat(auth): add biometric authentication

fix(profile): resolve crash on image upload

refactor(api): simplify error handling logic

docs(readme): update installation instructions
```

## Pull Request Process

1. **Update documentation**: Ensure README and other docs are updated

2. **Add tests**: Include tests for new features

3. **Run checks**: Ensure all tests pass and no lint errors

   ```bash
   flutter test
   flutter analyze
   dart format --set-exit-if-changed .
   ```

4. **Update CHANGELOG**: Add your changes to CHANGELOG.md

5. **Fill PR template**: Provide detailed information in the PR description

6. **Request review**: Tag relevant reviewers

7. **Address feedback**: Make requested changes promptly

8. **Squash commits**: Keep history clean (if requested)

### PR Requirements

- [ ] All tests pass
- [ ] No lint errors or warnings
- [ ] Code is properly formatted
- [ ] Documentation is updated
- [ ] CHANGELOG is updated
- [ ] Screenshots added (for UI changes)
- [ ] Tested on multiple devices/OS versions

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/auth_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for critical flows
- Aim for >80% code coverage

### Test Structure

```dart
group('AuthService', () {
  test('should login user successfully', () {
    // Arrange
    // Act
    // Assert
  });
});
```

## Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md) and include:

- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs
- Device and environment information

## Suggesting Enhancements

Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md) and include:

- Clear description of the feature
- Problem it solves
- Proposed solution
- Alternative solutions considered
- Impact assessment

## Code Review Guidelines

### For Contributors

- Be open to feedback
- Explain your approach and decisions
- Be patient and respectful

### For Reviewers

- Be constructive and respectful
- Explain the reasoning behind suggestions
- Approve promptly when ready
- Focus on code quality, not personal preferences

## Need Help?

- Check the [documentation](https://github.com/betaversionio/App/wiki)
- Ask in [GitHub Discussions](https://github.com/betaversionio/App/discussions)
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to BetaVersion! 🚀
