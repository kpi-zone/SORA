# superset_config.py

import os


SECRET_KEY = os.environ.get("SECRET_KEY", "eCeKi3EpACpFV5qGo/BOVMFg3HpQ1Kw/JMIZj7f63yML8SnfFHIXtgks")

# Flask App Config
APP_NAME = "Superset"

# Enable CSRF protection
WTF_CSRF_ENABLED = True

# Enable CORS (Cross-Origin Resource Sharing) if needed
ENABLE_CORS = True
CORS_OPTIONS = {
    "supports_credentials": True,
    "origins": ["*"],  # Adjust for production (don't allow '*')
    "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    "allow_headers": ["Content-Type", "Authorization"]
}

# Session timeout (in seconds)
SUPERSET_WEBSERVER_TIMEOUT = 60 * 60  # 1 hour

# Session lifetime
PERMANENT_SESSION_LIFETIME = 86400  # 1 day

# Cache config (simple file system cache for small deployments)
CACHE_CONFIG = {
    'CACHE_TYPE': 'filesystem',
    'CACHE_DIR': '/tmp/superset_cache',
    'CACHE_DEFAULT_TIMEOUT': 300,
}

# Email alerts (Optional - configure if needed)
EMAIL_NOTIFICATIONS = False

# Row Level Security
FEATURE_FLAGS = {
    "ROW_LEVEL_SECURITY": True,
    "EMBEDDABLE_CHARTS": True,  # If you want to embed charts
    "DASHBOARD_NATIVE_FILTERS": True,  # Native dashboard filters
}

# Logging level
APP_LOG_LEVEL = 'DEBUG'  # Change to 'WARNING' or 'ERROR' in production
