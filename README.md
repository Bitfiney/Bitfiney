# Bitfiney

## Simulation Trading Platform

Bitfiney is an independent trading-interface project designed for
simulation and educational purposes.

**IMPORTANT: SIMULATION ONLY**

Bitfiney does not process real cryptocurrency deposits, real
withdrawals, real blockchain transactions, or real investment funds.

---

## Features

### Trading

- BTC/USD simulated market
- Simulated price chart
- Order book
- Recent trades
- Buy and Sell interface
- Limit orders
- Market orders
- Stop orders
- Stop-Limit orders
- Simulated open orders
- Simulated trade history

### Wallets

- Simulated balances
- Simulated deposit information
- Simulated network/chain information
- Simulated withdrawal requests

### Account

- Trading account interface
- Account information
- Mobile-friendly layout

### Administration

The project includes a separate:

`admin.html`

The simulation administrator interface provides prototype controls for:

- Approving simulated deposits
- Rejecting simulated deposits
- Adding simulated profit
- Approving simulated withdrawals
- Rejecting simulated withdrawals
- Changing simulated withdrawal addresses
- Setting simulated deposit addresses
- Setting simulated deposit network chains
- Restricting Trading
- Restricting Futures
- Restricting Buy
- Restricting Sell
- Restricting Withdrawals
- Restoring user features
- Viewing simulated user activity
- Viewing administrator audit logs

---

## Important Architecture Note

The current GitHub Pages version is a browser-based simulation.

Browser `localStorage` is used by the prototype, which means the
administrator page does not yet securely control accounts belonging
to other browsers or devices.

For a real multi-user application, the next architecture should use:

- Supabase Authentication
- PostgreSQL
- Row Level Security (RLS)
- Server-side authorization
- Secure Edge Functions
- Database transaction records
- User profiles
- Admin roles
- Admin audit logs

Sensitive server credentials such as a Supabase service-role key
must never be placed inside public browser JavaScript.

Balance-changing operations should be performed by trusted
server-side functions rather than directly by the browser.

---

## Project Files

### `index.html`

Main Bitfiney simulated trading interface.

### `admin.html`

Simulation administrator control panel.

### `README.md`

Project documentation.

### `schema.sql`

Database schema planned for the Supabase backend.

---

## Deployment

The project can be hosted as a static website using GitHub Pages.

Current project:

**Bitfiney**

GitHub:

`https://github.com/Bitfiney/Bitfiney`

GitHub Pages:

`https://bitfiney.github.io/Bitfiney/`

---

## Safety

Bitfiney is independent software and is not the official Bitfinex
website or application.

The interface may use general exchange-style concepts for
educational and simulation purposes.

All balances, trades, profits, deposits and withdrawals shown in the
current prototype are simulated.

No real funds should be sent to addresses displayed by the prototype.

---

## Planned Development

1. Professional trading dashboard
2. Trading interface
3. Wallet system
4. Orders and trade history
5. Account/profile system
6. Mobile optimization
7. Login and trading-user experience
8. Supabase database integration
9. Secure user authentication
10. Admin authorization
11. Admin controls
12. Activity logging
13. Audit logging
14. Final testing
15. Production security review

---

## Technology

Current prototype:

- HTML
- CSS
- JavaScript
- Browser localStorage
- GitHub Pages

Planned backend:

- Supabase Auth
- PostgreSQL
- Row Level Security
- Supabase Edge Functions

---

## Status

Current status:

**Simulation prototype**

The application is under active development.
    Independent cryptocurrency trading platform — development project
