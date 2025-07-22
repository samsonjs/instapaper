# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Run tests**: `bundle exec rake test` or `bundle exec rspec`
- **Run linting**: `bundle exec rubocop`
- **Run both tests and linting**: `bundle exec rake` (default task)
- **Build gem**: `bundle exec rake build`
- **Install dependencies**: `bundle install`
- **Generate documentation**: `bundle exec yard`
- **Interactive console**: `./script/console`

## Architecture Overview

This is a Ruby gem that provides a client library for Instapaper's Full API. The architecture follows a modular design:

### Core Components

- **`Instapaper::Client`** - Main entry point that users instantiate with OAuth credentials
- **API modules** - Separate modules for each API category (Accounts, Bookmarks, Folders, Highlights, OAuth) mixed into the Client
- **HTTP layer** - Custom HTTP handling using the `http.rb` gem with OAuth signature generation
- **Response objects** - Custom model classes (Bookmark, Folder, Highlight, etc.) using Virtus for attribute definition

### Key Patterns

- **Modular API design**: Each API endpoint category is in its own module (`lib/instapaper/api/`)
- **HTTP abstraction**: All API calls go through `Instapaper::HTTP::Request` which handles OAuth signing and response parsing
- **Custom response objects**: API responses are parsed into specific model classes rather than raw hashes
- **Method naming convention**: API methods are descriptive (`star_bookmark`, `add_folder`) rather than generic (`star`, `add`)

### Authentication Flow

Uses OAuth 1.0a with xAuth for obtaining access tokens. The client requires consumer key/secret and access token/secret for API calls.

## Testing

- Uses RSpec with WebMock for stubbing HTTP requests
- Fixtures in `spec/fixtures/` contain sample API responses
- Test coverage tracked with SimpleCov (disabled in CI)
- Tests are organized by API module structure

## Dependencies

- **http.rb** - HTTP client library (replaced Faraday in v1.0)
- **virtus** - Attribute definitions for model objects
- **simple_oauth** - OAuth signature generation
- **addressable** - URI parsing and manipulation