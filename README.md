# PortfolioLens

A pure local investment portfolio viewer for iOS 17+, iPadOS 17+, and macOS 14+.

## Overview

PortfolioLens is a privacy-focused portfolio tracking app that stores all data locally on your device. No API connections, no broker integrations, no cloud sync. You have complete control over your investment data.

## Features

### Core Functionality
- **Manual Portfolio Management**: Create multiple portfolios (e.g., Retirement, Trading, Crypto)
- **Holdings Tracking**: Add stocks, ETFs, bonds, crypto, and other assets
- **Manual Price Updates**: Update current prices at your convenience
- **Portfolio Overview**: View total value, gain/loss, and allocation at a glance

### Analytics & Insights
- **Asset Allocation Charts**: Visualize your portfolio breakdown by sector and asset type
- **Performance Tracking**: Create snapshots over time to track portfolio performance
- **Dividend Tracking**: Log dividend payments and calculate yield
- **Gain/Loss Analysis**: Track performance on individual holdings and overall portfolio

### Data Management
- **CSV Export**: Export portfolio data for external analysis
- **Multiple Portfolios**: Separate tracking for different investment strategies
- **Local Storage**: All data stored securely on device using SwiftData

### User Experience
- **Dark Mode Support**: Full support for light and dark appearance
- **Universal App**: Native support for iPhone, iPad, and Mac (via Mac Catalyst)
- **SwiftUI Interface**: Modern, native iOS/macOS experience
- **No Subscriptions**: One-time purchase, no recurring fees

## Technical Details

- **Bundle ID**: com.lopodragon.portfoliolens
- **Price**: $6.99 USD (one-time purchase)
- **Minimum Requirements**: iOS 17.0, iPadOS 17.0, macOS 14.0
- **Architecture**: SwiftUI + MVVM
- **Data Persistence**: SwiftData
- **Charts**: Swift Charts
- **Dependencies**: None (100% native Swift)

## Privacy

PortfolioLens is designed with privacy as the top priority:
- No internet connection required
- No data collection or analytics
- No third-party SDKs
- All data stored locally on your device
- No account creation required

## Usage

### Creating a Portfolio
1. Tap the + button on the Portfolios screen
2. Enter a name for your portfolio
3. Tap "Add"

### Adding Holdings
1. Select a portfolio
2. Tap the menu button and select "Add Holding"
3. Enter the ticker symbol, number of shares, cost basis, and current price
4. Select the asset type and sector
5. Tap "Add"

### Updating Prices
1. Navigate to a holding detail view
2. Tap the menu button and select "Update Price"
3. Enter the new price
4. Tap "Update"

### Tracking Performance
1. Open a portfolio
2. Tap "Create Snapshot" to record current values
3. Repeat over time to build performance history
4. View the performance chart to see trends

### Recording Dividends
1. Navigate to a holding detail view
2. In the Dividends section, tap "Add Dividend Payment"
3. Enter the amount and payment date
4. Tap "Add"

### Exporting Data
1. Open a portfolio
2. Tap the menu button and select "Export CSV"
3. Share or save the CSV file

## Building from Source

1. Clone the repository
2. Open `PortfolioLens.xcodeproj` in Xcode 15 or later
3. Select your target device/simulator
4. Build and run (Cmd+R)

No external dependencies or package managers required.

## License

MIT License - See LICENSE file for details

## Support

For bug reports or feature requests, please open an issue on GitHub.

## Roadmap

Future enhancements being considered:
- Customizable currency support
- More chart types and visualizations
- Transaction history tracking
- Tax lot management
- Import from CSV
- iCloud sync (optional)

## Version History

See CHANGELOG.md for version history and release notes.
