# NGINX: Secure Reverse Proxy in Vero

NGINX acts as the **reverse proxy** in the Vero architecture, managing routing, hostname resolution, and secure HTTPS access to all services via domain-based virtual hosts.

Combined with **nginx-proxy** and **acme-companion**, it automatically provisions and renews **Let's Encrypt SSL certificates**, making Vero production-ready with minimal manual setup.

> 🔗 [nginx-proxy GitHub](https://github.com/nginx-proxy/nginx-proxy)
> 🔗 [acme-companion GitHub](https://github.com/nginx-proxy/acme-companion)

## Role of NGINX in Vero

NGINX serves as:

- A **reverse proxy** that routes incoming traffic to containerized services
- A centralized point of access via hostname-based virtual hosts (e.g., `n8n.yourdomain.com`, `dashboard.yourdomain.com`)
- An **SSL terminator**, providing secure HTTPS using Let's Encrypt (in production)
- A **production gateway**, enabling publicly accessible, secure deployment with no manual cert handling

With NGINX in place, you can:

- Route traffic to internal services by setting environment variables (`VIRTUAL_HOST`)
- Automatically secure services with valid SSL certificates (**production only**)
- Configure per-service NGINX settings via virtual host overrides

## Setup & Configuration

NGINX is included in the Vero Docker environment and defined in the `docker-compose.yml` under the `nginx` and `letsencrypt` services. It listens on:

```bash
http://yourdomain.com  (port 80)
https://yourdomain.com (port 443)
```

The NGINX reverse proxy stack includes:

- `nginxproxy/nginx-proxy` – main proxy container
- `nginxproxy/acme-companion` – handles Let's Encrypt certificates (production only)
- A shared volume set for logs, certs, virtual hosts, and Docker socket binding

### Environment Variables

Each service registers itself with NGINX using:

- `VIRTUAL_HOST` — the hostname used for routing and access
- `LETSENCRYPT_HOST` — optional, enables HTTPS with Let's Encrypt (only in **production**)
- `LETSENCRYPT_EMAIL` — email used for Let's Encrypt certificate issuance (only in **production**)

> ⚠️ In development, **do not** set `LETSENCRYPT_HOST` or `LETSENCRYPT_EMAIL`. Use HTTP (`localhost`) only.

## Creating Custom Host Configs

To define per-service proxy behavior (e.g., custom headers, caching, security settings), create a virtual host override:

```bash
nginx/vhost.d/yourdomain.com
```

Alternatively, you can rename one of the existing example files in `nginx/vhost.d/`.

> 📁 The filename must match the domain defined in `VIRTUAL_HOST`.

## Required Volumes

The NGINX service uses the following volume mounts:

```yaml
- /var/run/docker.sock:/tmp/docker.sock:ro
- ./nginx/logs:/var/log/nginx
- ./nginx/certs:/etc/nginx/certs:rw
- ./nginx/vhost.d:/etc/nginx/vhost.d
- ./nginx/html:/usr/share/nginx/html
```

These enable:

- Real-time container discovery via Docker socket
- Persistent Let's Encrypt cert storage (production only)
- Custom per-domain configuration
- Static fallback pages (if desired)

## 📁 Folder Structure

```bash
nginx/
├── certs/         # Let's Encrypt SSL certificates (production)
├── logs/          # Access/error logs
├── vhost.d/       # Per-service NGINX configuration overrides
├── html/          # Optional static HTML (fallback pages or maintenance)
```

## Production Deployment Notes

When deploying Vero in production:

- Use publicly resolvable domains and configure DNS accordingly
- Include `LETSENCRYPT_HOST` and `LETSENCRYPT_EMAIL` in your `.env` files to enable SSL
- Ensure ports `80` and `443` are open to allow ACME validation
- You can customize NGINX behavior per domain using `nginx/vhost.d/yourdomain.com`

> In **local development**, leave `LETSENCRYPT_*` variables unset to avoid unnecessary ACME errors.

## Example: Secure n8n Setup in Production

1. In your `n8n/.env` file, set:

```dotenv
VIRTUAL_HOST=n8n.yourdomain.com
LETSENCRYPT_HOST=n8n.yourdomain.com
LETSENCRYPT_EMAIL=admin@yourdomain.com
```

2. (Optional) Create:

```bash
nginx/vhost.d/n8n.yourdomain.com
```

3. Restart Docker Compose:

```bash
docker-compose up -d
```

Once complete, your n8n instance will be available at:

```arduino
https://n8n.yourdomain.com
```

With a valid, auto-renewing SSL certificate.