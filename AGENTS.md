# Repository Guidelines

## Development Commands

- **Run tests**: `bundle exec rake spec` (or `bundle exec rake test`, aliased)
- **Run linting**: `bundle exec rubocop`
- **Run both tests and linting**: `bundle exec rake` (default task runs `spec` then `rubocop`)
- **Build gem**: `bundle exec rake build`
- **Install dependencies**: `bundle install`
- **Generate documentation**: `bundle exec yard`
- **Interactive console**: `./script/console`

## Architecture Overview

Ruby gem providing a client library for Instapaper's Full API (v1.0.1). Modular design with clean separation between API surface, HTTP transport, and response models.

### Core Components

- **`Instapaper::Client`** (`lib/instapaper/client.rb`) - Main entry point, instantiated with OAuth credentials. Includes all API modules and HTTP utilities.
- **API modules** (`lib/instapaper/api/`) - Separate modules for each API category: Accounts, Bookmarks, Folders, Highlights, OAuth. Mixed into the Client.
- **HTTP layer** (`lib/instapaper/http/`) - Custom HTTP handling using the `http` gem. `Request` builds and executes requests, `Headers` constructs OAuth-signed headers, `Response` parses results, `Utils` provides convenience methods.
- **OAuth signing** (`lib/instapaper/oauth.rb`) - Custom `Instapaper::OAuth::Header` class that generates OAuth 1.0a HMAC-SHA1 signatures. No external OAuth signing library.
- **Response models** (`lib/instapaper/`) - `Bookmark`, `BookmarkList`, `Folder`, `Highlight`, `User`, `Credentials`, `Error` — all built on `Dry::Struct` with custom types.
- **Custom types** (`lib/instapaper/types.rb`) - `Dry::Types` module with `StringOrInteger`, `BooleanFlag`, and `UnixTime` coercions for handling Instapaper's loosely-typed API responses.
- **QLine parser** (`lib/instapaper/http/qline_parser.rb`) - Parses Instapaper's qline-encoded responses (used by the OAuth token endpoint).

### Key Patterns

- **Modular API design**: Each API endpoint category is in its own module under `lib/instapaper/api/`
- **HTTP abstraction**: All API calls go through `Instapaper::HTTP::Request` which handles OAuth signing and response parsing
- **Dry::Struct models**: API responses are parsed into typed model classes using `dry-struct` and `dry-types` rather than raw hashes
- **Method naming convention**: API methods are descriptive (`star_bookmark`, `add_folder`) rather than generic

### Authentication Flow

Uses OAuth 1.0a with xAuth for obtaining access tokens. The client requires consumer key/secret and access token/secret for API calls.

## Testing

- Uses RSpec with WebMock for stubbing HTTP requests
- Fixtures in `spec/fixtures/` contain sample API responses (JSON and plaintext)
- Test coverage tracked with SimpleCov
- Tests organized to mirror source: `spec/instapaper/api/`, `spec/instapaper/http/`, plus top-level specs for `client`, `bookmark_list`, `error`, and `oauth`

## Examples

The `examples/` directory has runnable scripts demonstrating common flows: authorization, obtaining access tokens, verifying credentials, and listing folders.

## Dependencies

### Runtime (gemspec)

- **http** (>= 2, < 6) - HTTP client library
- **dry-struct** (~> 1.0) - Typed struct definitions for model objects
- **dry-types** (~> 1.0) - Type system and coercions
- **addressable** (~> 2.3) - URI parsing and manipulation
- **multi_json** (~> 1) - JSON parsing abstraction
- **base64** (~> 0.3) - Base64 encoding for OAuth signatures

### Development/Test (Gemfile)

- **rspec** (~> 3) - Test framework
- **webmock** (>= 1.22) - HTTP request stubbing
- **rubocop** (>= 0.27) - Linting
- **simplecov** - Code coverage
- **yard** - Documentation generation
- **kramdown** - Markdown processing for YARD
