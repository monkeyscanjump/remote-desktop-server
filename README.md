# Remote Desktop Server (Apache Guacamole Stack)

This project provides a fully dockerized remote desktop gateway using [Apache Guacamole](https://guacamole.apache.org/), MariaDB, guacd, and Cloudflared for secure remote access. It is designed for easy deployment and management with Docker Compose.

## Features

- Apache Guacamole web UI for RDP, VNC, and SSH access
- MariaDB for persistent user and connection storage
- guacd proxy daemon
- Cloudflared for secure remote access via Cloudflare Tunnel
- Cross-platform scripts for setup and management

## Prerequisites

- [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/)
- [Node.js](https://nodejs.org/) (for cross-platform scripts)
- A Cloudflare account and tunnel token (if using Cloudflared)

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone https://github.com/monkeyscanjump/remote-desktop-server.git
   cd remote-desktop-server
   ```

2. **Copy and edit environment variables:**

   ```bash
   npm run copy-env
   # Edit .env with your desired passwords and settings
   ```

   Or manually copy `.env.local` to `.env` and edit as needed.

3. **Generate secure passwords (optional):**

   ```bash
   npm run gen-password
   # Copy the output and paste into your .env file
   ```

4. **Build and start the stack:**

   ```bash
   npm start
   # or
   docker compose up --build
   ```

5. **Access Guacamole:**
   - Local: [http://localhost:8080/guacamole/](http://localhost:8080/guacamole/)
   - Via Cloudflare: Use your tunnel URL

6. **First login and securing your system:**
   - Login with:
     - Username: `guacadmin`
     - Password: `guacadmin`
   - Immediately create a new user with the "Administrator" role and a strong password.
   - Log out and log in as your new admin user.
   - Delete the `guacadmin` user from the Users panel to secure your system.

## Environment Setup

You must generate a `.env` file before starting the stack. This project provides a Bash script for this purpose.

### On Linux/macOS (or Windows with Git Bash/MSYS2)

1. **Make the script executable (Linux/macOS only):**
   ```bash
   chmod +x scripts/gen-env.sh
   ```
2. **Run the script:**
   ```bash
   ./scripts/gen-env.sh
   ```
   This will generate a `.env` file based on `.env.local`, randomizing passwords/secrets. All other values (including TUNNEL_TOKEN) are copied as-is from `.env.local`.

### On Windows (CMD/PowerShell)

- You can use Git Bash or WSL to run the script as above.
- Or, copy `.env.local` to `.env` manually and edit as needed.

> **Note:** No Node.js or npm install is required. All scripts are Bash or Docker Compose only.

## Securing Access with Cloudflare Access

To further secure your Guacamole deployment, you can use [Cloudflare Access](https://developers.cloudflare.com/cloudflare-one/identity/) to require identity-based authentication (Google, GitHub, SSO, etc.) before anyone can reach your Guacamole web UI—even before the login page.

### Steps to Secure with Cloudflare Access

1. **Set up your Cloudflare Tunnel**
   - Make sure your `cloudflared` service is running and connected to your Cloudflare account.
   - Your tunnel should point to the Guacamole web service (e.g., `http://guacamole:8080`).

2. **Add an Application in Cloudflare Zero Trust Dashboard**
   - Go to the [Cloudflare Zero Trust dashboard](https://dash.teams.cloudflare.com/).
   - Navigate to **Access > Applications** and click **Add an application**.
   - Choose **Self-hosted**.
   - Set the application domain to your tunnel's public hostname (e.g., `guac.example.com`).
   - Set the path to `/guacamole/*` to protect the entire Guacamole UI.

3. **Configure Access Policies**
   - Add a policy to require login with your preferred identity provider (Google, GitHub, SAML, etc.).
   - You can restrict by email, group, or other rules.
   - Save the policy.

4. **Test Access**
   - Visit your tunnel URL (e.g., `https://guac.example.com/guacamole/`).
   - You should be prompted to authenticate with Cloudflare Access before seeing the Guacamole login page.

### Tips

- You can add multiple identity providers and fine-tune access rules in Cloudflare Access.
- For extra security, disable direct access to your server's public IP using firewall rules—only allow Cloudflare IPs.
- Cloudflare Access logs all authentication attempts for auditing.

For more details, see the [Cloudflare Access documentation](https://developers.cloudflare.com/cloudflare-one/identity/).

## Useful Commands

- Show logs: `npm run logs`
- Stop and remove all containers/volumes: `npm run down`
- Copy .env.local to .env: `npm run copy-env`
- Generate a random password: `npm run gen-password`

## File Structure

- `docker-compose.yml` — Main stack definition
- `.env.local` — Example environment file
- `.env` — Your actual environment file (not committed)
- `initdb.sql` — Guacamole database schema (auto-generated)
- `package.json` — Scripts and project metadata
- `.gitignore` — Files to exclude from git

## Notes

- The MariaDB container will auto-import the Guacamole schema from `initdb.sql` on first run. If you change the schema, run `docker compose down -v` to reset the database.
- The guacamole-initdir service ensures Tomcat can deploy the webapp without permission issues.
- Cloudflared is optional but recommended for secure remote access.

## Troubleshooting

- If you get a 404 or database errors, ensure you have the correct `initdb.sql` and have run `docker compose down -v` before starting.
- If you cannot log in as a new user, make sure you assign the "Administrator" role and set a password.
- For password changes, always use the "Change Password" option in the user menu, not the Users admin panel.

## License

MIT
